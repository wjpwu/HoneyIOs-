//
//  VTRotateMenuUI.h
//  BCTabBarController
//
//  Created by Aaron.Wu on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define VTROTATER_ADIUS 110.

#import <UIKit/UIKit.h>
#import "VTRotateMenu.h"
#import "VTUI.h"

@class VTRotateMenuView;

@interface VTRotateMenuUI : VTUI <VTRotateMenuDelegate>
{
    VTRotateMenuView *vtMenuView;
}
// nsdictory array
@property (nonatomic, retain) NSArray *rotateMenu;


- (void) setupUI;
- (float) getRadius;

@end
