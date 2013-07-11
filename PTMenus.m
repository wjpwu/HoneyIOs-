//
//  PTMenuConfig.m
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-5-14.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import "PTMenus.h"
#import "CXMLDocument.h"
#import "CXMLElement.h"
#import "PTFiles.h"
#import "PTSession.h"

@interface PTMenus ()

@property CXMLDocument *xml;

@end

@implementation PTMenus
@synthesize xml = _xml;

static PTMenus *mConfig = nil;



+ (PTMenus*)shareMenuInstance
{
    @synchronized(self) {
        if (mConfig==nil) {
            mConfig = [[PTMenus alloc] init];
        }
    }
    return mConfig;
}


- (id)init
{
    self = [super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetUUID:) name:NNDidGetUUID object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetMenu:) name:NNDidGetMenu object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetMenuMD5:) name:NNDidGetMenuMD5 object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}


- (void) sendNotificationWithStatus:(NSDictionary*) nt
{
    NSNotification *notification = [NSNotification notificationWithName:NNDidFinishInitMenus object:nt];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}



- (void) loadMenus
{
    NSData *xmlData = [[PTFiles shareInstance] fileDataFromDocumentWithName:menuname];
    if (!xmlData) {
        [[PTSession shareInstance] doGetMenu];
    }
    else{
        NSError* error;
        self.xml = [[CXMLDocument alloc] initWithData:xmlData options:0 error:&error];
        if (error) {
            [self sendNotificationWithStatus:[NSDictionary dictionaryWithObject:@"0" forKey:@"status"]];
            debug_NSLog(@"fail to init context menus :%@",error);
        }
        else
            [self sendNotificationWithStatus:[NSDictionary dictionaryWithObject:@"1" forKey:@"status"]];
    }
}

- (void) didGetUUID :(NSNotification*) sender
{
    if([[[sender object] valueForKey:@"status"] isEqualToString:@"1"])
    {
        [[PTSession shareInstance] doGetFileMD5WithName:[NSString stringWithFormat:@"%@",menuname]];
    }
}

- (void) didGetMenuMD5 :(NSNotification*) sender
{
    if([[[sender object] valueForKey:@"status"] boolValue])
    {
        id data1 = [[sender object] valueForKey:@"data"];
        NSData *data2 = [[PTFiles shareInstance] fileDataFromDocumentWithName:[NSString stringWithFormat:@"%@%@",menuname,@"MD5"]];
        NSString *str1 = [[NSString alloc] initWithData: data1 encoding: NSUTF8StringEncoding];
        NSString *str2 = [[NSString alloc] initWithData: data2 encoding: NSUTF8StringEncoding];

        debug_NSLog(@"MD5 compare%@,/n %@",str1,str2);
        // to update menu
        if (![str1 isEqualToString:str2]) {
            [[PTSession shareInstance] doGetMenu];
        } else{
            [self loadMenus];
        }
    }
}

- (void) didGetMenu :(NSNotification*) sender
{
    if([[[sender object] valueForKey:@"status"] boolValue])
    {
        NSError* error;
        self.xml = [[CXMLDocument alloc] initWithData:[[sender object] valueForKey:@"data"]options:0 error:&error];
        if (error) {
            [self sendNotificationWithStatus:[NSDictionary dictionaryWithObject:@"0" forKey:@"status"]];
            debug_NSLog(@"fail to init context menus :%@",error);
        }
        else
            [self sendNotificationWithStatus:[NSDictionary dictionaryWithObject:@"1" forKey:@"status"]];
    }
}


// get item info only
- (NSMutableDictionary*)menuInfoWithid:(NSString*) menuId  childInfo:(BOOL) child
{
    NSArray *menus = [self.xml nodesForXPath:[NSString stringWithFormat:@"//item[@id='%@']",menuId] error:nil];
    // should have only one record
    if([menus count] == 1 && [[menus objectAtIndex:0] isKindOfClass:[CXMLElement class]])
    {
        CXMLElement *menuXml = [menus objectAtIndex:0];
        NSMutableDictionary *menuDict = [[NSMutableDictionary alloc] init];
        [menuDict setValue:[[menuXml attributeForName:@"id"] stringValue] forKey:@"menuId"];
        [menuDict setValue:[[menuXml attributeForName:@"upid"] stringValue] forKey:@"menuUpId"];
        [menuDict setValue:[[menuXml attributeForName:@"msg"] stringValue] forKey:@"msg"];
        [menuDict setValue:[[menuXml attributeForName:@"img"] stringValue] forKey:@"img"];
        [menuDict setValue:[[menuXml attributeForName:@"text"] stringValue] forKey:@"text"];
        [menuDict setValue:[[menuXml attributeForName:@"type"] stringValue] forKey:@"type"];
        // have sub menus
        if (child && [menuXml childCount] > 0) {
            NSMutableArray *subMenuAry = [[NSMutableArray alloc] initWithCapacity:[menuXml childCount]];
            for (int i = 0; i < [menuXml childCount]; i++)
            {
                if ([[[menuXml children] objectAtIndex:i] isKindOfClass:[CXMLElement class]])
                {
                    CXMLElement *subMenuXml = [[menuXml children] objectAtIndex:i];
                    NSMutableDictionary *subMenuItem = [[NSMutableDictionary alloc] init];
                    [subMenuItem setValue:[[subMenuXml attributeForName:@"id"] stringValue] forKey:@"menuId"];
                    [subMenuItem setValue:[[subMenuXml attributeForName:@"upid"] stringValue] forKey:@"menuUpId"];
                    [subMenuItem setValue:[[subMenuXml attributeForName:@"msg"] stringValue] forKey:@"msg"];
                    [subMenuItem setValue:[[subMenuXml attributeForName:@"img"] stringValue] forKey:@"img"];
                    [subMenuItem setValue:[[subMenuXml attributeForName:@"text"] stringValue] forKey:@"text"];
                    [subMenuItem setValue:[[subMenuXml attributeForName:@"type"] stringValue] forKey:@"type"];
                    [subMenuAry addObject:subMenuItem];
                }
            }
            [menuDict setValue:@"1" forKey:@"boolean"];
            [menuDict setValue:subMenuAry forKey:@"subs"];
        }
        // have no sub
        else{
            [menuDict setValue:@"0" forKey:@"boolean"];
        }
        
//        NSLog(@"menuDict is %@",menuDict);
        return menuDict;
    }
    else{
        NSLog(@"can't find anything or menuid is not unique");
        return nil;
    }
}

// get item info and child info both
- (NSMutableDictionary*)menuInfoWithId:(NSString*) menuId
{
    return [self menuInfoWithid:menuId childInfo:NO];
}

- (NSString*)superMenuWithId:(NSString*) menuId
{
    id menu = [self menuInfoWithId:menuId];
    if (menu) {
        if ([[menu valueForKey:@"menuUpId"] isEqualToString:@"0"]) {
            return [menu valueForKey:@"menuId"];
        }
        return [self superMenuWithId:[menu valueForKey:@"menuUpId"]];
    }
    return nil;
}

- (NSArray*)menuPathWithId:(NSString*) menuId
{
    NSArray *menus = [self.xml nodesForXPath:[NSString stringWithFormat:@"//item[@id='1.1.3.6']/ancestor-or-self::*"] error:nil];

}

@end

