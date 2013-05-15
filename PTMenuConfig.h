//
//  PTMenuConfig.h
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-5-14.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTMenuConfig : NSObject

+ (PTMenuConfig*)shareMenuInstance;
- (NSMutableDictionary*)menuInfoWithId:(NSString*) menuId;
- (NSMutableDictionary*)menuInfoWithid:(NSString*) menuId  childInfo:(BOOL) child;
- (NSString*)superMenuWithId:(NSString*) menuId;
- (NSArray*)menuPathWithId:(NSString*) menuId;

@end
