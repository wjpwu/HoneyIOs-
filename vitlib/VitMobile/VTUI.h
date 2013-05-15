//
//  VitUI.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeManager.h"

extern NSString *const kThemeDidChangeNotification;

@protocol PopViewDelegate;

@interface VTUI : UIViewController
{
    NSNotificationCenter *defaultNotifCenter;
}

@property (nonatomic, assign) id<PopViewDelegate> popDelegate;
@property (nonatomic, assign) BOOL  hideTabBarTitle;

- (void)setupUI;
- (void)resignResponder;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (void)showInMainWindowWithAnimated:(BOOL)animated;

- (void)popBack;

- (void)fadeIn;
- (void)fadeOut;

-(void)updateTheme:(NSNotification*)notif;

@end

@protocol PopViewDelegate <NSObject>
@optional
- (void)popViewController:(UIViewController *)popView dismissWithResponse:(id)_response;
- (void)popViewDidCancel;
@end