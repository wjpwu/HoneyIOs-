//
//  VTRotateMenuView.h
//  BCTabBarController
//
//  Created by Aaron.Wu on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "VTRotateMenu.h"
#import <QuartzCore/CoreAnimation.h>

@interface VTRotateMenuView : UIView <VTRotateMenuDelegate,UIGestureRecognizerDelegate>
{
    float _rotateRadius;
    float _centerX;
    float _centerY;
    CGPoint _menuCenter;
}

@property (nonatomic, retain) NSArray *menus;
@property (nonatomic, retain) VTRotateMenu *selectedMenu;
@property (nonatomic, retain) id<VTRotateMenuDelegate> _rotDelegate;

- (id) initWithFrame:(CGRect)frame Radius: (float) anRadius;

@end
