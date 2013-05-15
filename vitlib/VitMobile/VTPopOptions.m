//
//  VitPopOptions.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTPopOptions.h"

static VTPopOptions *instance = nil;

@implementation VTPopOptions
@synthesize popOptions;


- (id)init
{
    self = [super init];
    if (self) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"poplistpick" ofType:@"plist"]; 
        self.popOptions = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return self;
}

+(VTPopOptions*)getInstance
{
    @synchronized(self) 
    {
        if (instance==nil) {
            instance=[[VTPopOptions alloc] init];
        }
    }
    return instance;
}

+ (NSArray*)getPopList : (NSString*) anKey
{
    return [[VTPopOptions getInstance].popOptions objectForKey:anKey];
}

+ (NSDictionary*) getOptionDictionaryWithHostCode : (NSString*) hostCode hostCodeKey:(NSString*)hKey arrayKey :(NSString*) anKey
{
    NSArray *options = [VTPopOptions getPopList:anKey];
    // normal find
    for (NSDictionary *info in options) {
        if (hostCode && [hostCode isEqualToString:[info objectForKey:hKey]]) {
            return info;
        }
    }
    // if not find, change to special find
    for (NSDictionary *info in options) {
        if (hostCode && [self isPureFloat:hostCode] && [self isPureFloat:[info objectForKey:hKey]]) {
            if ([[info objectForKey:hKey] length] >0 && [hostCode floatValue] == [[info objectForKey:hKey] floatValue]) {
                return info;
            }
        }
    }
    return nil;
}


+ (NSDictionary*) getOptionDictionaryWithHostCode : (NSString*) hostCode array :(NSArray*) options
{
    // normal find
    for (NSDictionary *info in options) {
        if (hostCode && [hostCode isEqualToString:[info objectForKey:@"code"]]) {
            return info;
        }
    }
    // if not find, change to special find
    for (NSDictionary *info in options) {
        if (hostCode && [self isPureFloat:hostCode] && [self isPureFloat:[info objectForKey:@"code"]]) {
            if ([[info objectForKey:@"code"] length] >0 && [hostCode floatValue] == [[info objectForKey:@"code"] floatValue]) {
                return info;
            }
        }
    }
    return nil;
}

+ (NSDictionary*) getOptionDictionaryWithHostCode : (NSString*) hostCode arrayKey :(NSString*) anKey
{
    NSArray *options = [VTPopOptions getPopList:anKey];
    // normal find
    for (NSDictionary *info in options) {
        if (hostCode && [hostCode isEqualToString:[info objectForKey:@"code"]]) {
            return info;
        }
    }
    // if not find, change to special find
    for (NSDictionary *info in options) {
        if (hostCode && [self isPureFloat:hostCode] && [self isPureFloat:[info objectForKey:@"code"]]) {
            if ([[info objectForKey:@"code"] length] >0 && [hostCode floatValue] == [[info objectForKey:@"code"] floatValue]) {
                return info;
            }
        }
    }
    return nil;
}

//判断是否为整形：

+ (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    int val;
    
    return[scan scanInt:&val] && [scan isAtEnd];
    
}



//判断是否为浮点形：

+ (BOOL)isPureFloat:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    
    float val;
    
    return[scan scanFloat:&val] && [scan isAtEnd];
    
}

+ (NSDictionary*) getOptionDictionaryWithText : (NSString*) theText arrayKey :(NSString*) anKey
{
    NSArray *options = [VTPopOptions getPopList:anKey];
    for (NSDictionary *info in options) {
        if (theText && [theText isEqualToString:[info objectForKey:@"text"]]) {
            return info;
        }
    }
    return nil;
}

+ (NSArray*) getOptionDictionaryArrayWithHostCodes : (NSArray*) hostCodeArray arrayKey :(NSString*) anKey
{
    NSArray *options = [VTPopOptions getPopList:anKey];
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    for (NSString *hostCode in hostCodeArray) {
        for (NSDictionary *info in options) {
            if (hostCode && [hostCode isEqualToString:[info objectForKey:@"code"]]) {
                [tmp addObject:info];
            }
        }
    }
    return tmp;
}


@end
