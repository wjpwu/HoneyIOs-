//
//  MenuNavigate.h
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-5-15.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuNavigate : NSObject
@property (retain, nonatomic) UITabBarController *tabBarController;

- (void) setupTabs;

@end
