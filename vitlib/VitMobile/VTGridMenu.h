//
//  VitMenu.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTUI.h"
#import "MMGridView.h"
#import "VTDelegate.h"

@interface VTGridMenu : VTUI<MMGridViewDataSource, MMGridViewDelegate> 
{
    UIPageControl *pageControl;
    MMGridView *gridView;
}

@property (nonatomic, assign)id<VTSelectMenuDelegate> menuDelegate;

#pragma mark - menu porperties
@property (nonatomic, retain) NSArray *menuTitles;
@property (nonatomic, retain) NSArray *menuIcons;
@property (nonatomic, retain) NSArray *menuIds;

-(id)initWithLongPressSupport;


#pragma mark - To be implemented in subclasses
- (void)gridView:(MMGridView *)gridView didSelectCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index;
- (void)gridView:(MMGridView *)gridView didLongPressCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index;

@end
