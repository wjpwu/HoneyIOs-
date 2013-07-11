//
//  PTAppDelegate.h
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-5-13.
//  Copyright (c) 2013年 aaron. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "PTNavigate.h"
#import "PTSession.h"

@interface PTAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController *tabBarController;
@property (strong, nonatomic) PTNavigate *menuNavigate;
@property (strong, nonatomic) PTSession *ptHttp;

@end
