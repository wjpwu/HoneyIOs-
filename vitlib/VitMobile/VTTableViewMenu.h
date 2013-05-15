//
//  VitTableViewMenu.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTTableUI.h"
#import "VTDelegate.h"

@interface VTTableViewMenu : VTTableUI


@property (nonatomic, assign) id<VTSelectMenuDelegate> menuDelegate;
#pragma mark - menu properties

@property (nonatomic, retain) NSArray *menuTitles;
@property (nonatomic, retain) NSArray *menuIcons;
@property (nonatomic, retain) NSArray *menuIds;


@end
