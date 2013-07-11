//
//  MenuNavigate.h
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-5-15.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTNavigate : NSObject

@property (retain, nonatomic) UINavigationController *rootViewController;

+ (PTNavigate*)shareInstance;

- (void) popToTabbarController;
- (void) setupTabs;
- (void) updateTabsAfterLogin;

@end
