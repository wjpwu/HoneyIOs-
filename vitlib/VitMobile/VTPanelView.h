//
//  VTPanelView.h
//  BCTabBarController
//
//  Created by Aaron.Wu on 12-8-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "VTButton.h"

@interface VTPanelView : UIView
{
    IBOutlet UIButton *showHideBtn;
    Boolean isExpanded;
}
- (IBAction)controlPanelShowHide:(id)sender;

@property Boolean isExpanded;

- (void)exPandedPanel:(BOOL)animated;
- (void) hidePanel :(BOOL)animated;
- (void) showPanel :(BOOL)animated;

@end