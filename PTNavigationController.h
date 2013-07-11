//
//  PTNavigationController.h
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-6-18.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PTNavigateDelegate <NSObject>

@optional
- (BOOL) shouldPushItem:(UINavigationItem *)item;
- (void) didPushItem:(UINavigationItem *)item;
- (BOOL) shouldPopItem:(UINavigationItem *)item;
- (void) didPopItem:(UINavigationItem *)item;

@end

@interface PTNavigationController : UINavigationController

@property (nonatomic, assign) id<PTNavigateDelegate> ptDelegate;

@end
