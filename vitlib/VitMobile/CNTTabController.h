//
//  CNTTabController.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-9-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BCTabBar.h"
#import "VTUI.h"
@class BCTabBarView;


@interface CNTTabController : VTUI
{
}

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) UIViewController *selectedViewController;
@property (nonatomic, retain) BCTabBarView *tabBarView;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic, readonly) BOOL visible;

@end

