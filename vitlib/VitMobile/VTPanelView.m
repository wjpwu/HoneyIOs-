//
//  VTPanelView.m
//  BCTabBarController
//
//  Created by Aaron.Wu on 12-8-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTPanelView.h"

@implementation VTPanelView

@synthesize isExpanded;

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"VTPanelView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.frame = frame;
        self.isExpanded = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

-(IBAction) controlPanelShowHide:(id)sender
{
    [self exPandedPanel:YES];
}


- (void) hidePanel :(BOOL)animated
{
    if (self.isExpanded) {
        [self exPandedPanel:animated];
    }
}
- (void) showPanel :(BOOL)animated
{
    if (!self.isExpanded) {
        [self exPandedPanel:animated];
    }
}

- (void)exPandedPanel:(BOOL)animated
{    
    if (animated) {
        void (^anims)(void) = ^(void){
            CGRect frame = self.frame;
            if (!self.isExpanded)
            {
                self.isExpanded = YES;
                frame.origin.x -= 290;
                self.frame = frame;                             
            } else {
                self.isExpanded = NO;                             
                frame.origin.x += 290;
                self.frame = frame;
            }
        };
        
        void (^animsFinish)(BOOL finished) = ^(BOOL finished){
            if (self.isExpanded)
                [showHideBtn setImage:[UIImage imageNamed:@"VitMobile.bundle/Images/iconCollapse.png"] forState:UIControlStateNormal];
            else
                [showHideBtn setImage:[UIImage imageNamed:@"VitMobile.bundle/Images/iconExpand.png"] forState:UIControlStateNormal];
            
        };
        [UIView animateWithDuration:.7 animations:anims completion:animsFinish];
	}
    else {
        CGRect frame = self.frame;
        if (!self.isExpanded)
        {
            self.isExpanded = YES;
            frame.origin.x -=290;
            self.frame = frame;
            [showHideBtn setImage:[UIImage imageNamed:@"VitMobile.bundle/Images/iconCollapse.png"] forState:UIControlStateNormal];
        } else {
            self.isExpanded = NO;                             
            frame.origin.x +=290;
            self.frame = frame;
            [showHideBtn setImage:[UIImage imageNamed:@"VitMobile.bundle/Images/iconExpand.png"] forState:UIControlStateNormal];
        }
    }
}

@end
