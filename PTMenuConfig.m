//
//  PTMenuConfig.m
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-5-14.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import "PTMenuConfig.h"
#import "CXMLDocument.h"
#import "CXMLElement.h"

@interface PTMenuConfig ()

@property CXMLDocument *xml;

@end

@implementation PTMenuConfig
@synthesize xml = _xml;

static PTMenuConfig *mConfig = nil;



+ (PTMenuConfig*)shareMenuInstance
{
    @synchronized(self) {
        if (mConfig==nil) {
            NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"CommonMenu" ofType:@"xml"];
            NSData *fileData = [NSData dataWithContentsOfFile:xmlPath];
            mConfig = [[PTMenuConfig alloc] initWithMenuConfig:fileData];
        }
    }
    return mConfig;
}


- (id)initWithMenuConfig : (NSData*) xmlData
{
    self = [super init];
    if (self) {
        NSError* error;
        self.xml = [[CXMLDocument alloc] initWithData:xmlData options:0 error:&error];
        if(self.xml == nil || error != nil)
        {
            NSException *ex = [[NSException alloc] initWithName:@"xmlException" reason:@"read xml failed" userInfo:nil];
            @throw ex;
        }
    }
    return self;
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
        
        NSLog(@"menuDict is %@",menuDict);
        return menuDict;
    }
    else{
        NSLog(@"can't find anything");
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

