//
//  VitComplexMenuView.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

typedef enum {
    GridViewLayoutStyle,
    TableViewLayoutStyle
} MenuLayoutStyle;


#import <UIKit/UIKit.h>
#import "VTGridMenu.h"
#import "VTTableViewMenu.h"
#import "VTDelegate.h"

@interface VTComplexMenuView : UIViewController <VTSelectMenuDelegate>
{
    IBOutlet VTGridMenu *gridMenu;
    IBOutlet VTTableViewMenu *tableMenu;
}

#pragma mark - menu porperties
@property (nonatomic, retain) NSArray *menuTitles;
@property (nonatomic, retain) NSArray *menuIcons;

- (id) initMenuWithStyle: (MenuLayoutStyle)layoutStyle;

@end
