//
//  MenuNavigate.m
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-5-15.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import "MenuNavigate.h"
#import "PTMenuConfig.h"
#import "SessionManager.h"
#import "VitMobile/VTGridMenu.h"
#import "VitMobile/VTTableViewMenu.h"

@interface MenuNavigate () <VTSelectMenuDelegate>

@property (retain, nonatomic) PTMenuConfig *config;
@property (retain, nonatomic) SessionManager *sessionControl;
// to store the first view menu id
@property (retain, nonatomic) NSArray *superMenuIds;
@property (retain, nonatomic) UINavigationController *tab1;
@property (retain, nonatomic) UINavigationController *tab2;
@property (retain, nonatomic) UINavigationController *tab3;
@property (retain, nonatomic) UINavigationController *tab4;

@end

@implementation MenuNavigate

@synthesize tabBarController;
@synthesize config;
@synthesize superMenuIds;
@synthesize sessionControl;
@synthesize tab1,tab2,tab3,tab4;

- (id) init
{
    self = [super  init];
    if (self) {
        self.tabBarController = [[UITabBarController alloc] init];
        self.config = [PTMenuConfig shareMenuInstance];
        self.sessionControl = [[SessionManager alloc] init];
    }
    return self;
}

- (void) setupTabs
{
    //tab menu collection
    superMenuIds = [NSArray arrayWithObjects:@"1",@"2",@"4",@"9", nil];
    self.tabBarController.view.backgroundColor = [UIColor whiteColor];

    //init tab viewcontrollers
    NSMutableArray *tabs = [NSMutableArray arrayWithCapacity:[superMenuIds count]];
    for (NSString *superId in superMenuIds) {
        [tabs addObject:[self navigateControllerWithSuperMenuId:superId]];
    }
    self.tabBarController.viewControllers = tabs;
    
    
}

- (UINavigationController*) navigateControllerWithSuperMenuId:(NSString*) tt
{
    id menu = [config menuInfoWithId:tt];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[self viewControllerWithMenuId:tt]];
    nav.tabBarItem.image = [UIImage imageNamed:[menu valueForKey:@"img"]];
    nav.tabBarItem.title = [menu valueForKey:@"text"];
    return nav;
}


- (UIViewController*) viewControllerWithMenuId:(NSString*) mm
{
    id menu = [config menuInfoWithid:mm childInfo:YES];
    // display grid view
    if ([[menu valueForKey:@"type"] isEqualToString:@"grid"]) {
        VTGridMenu *controller = [[VTGridMenu alloc] init];
        controller.menuIcons = [[menu valueForKey:@"subs"] valueForKey:@"img"];
        controller.menuTitles = [[menu valueForKey:@"subs"] valueForKey:@"text"];
        controller.menuIds = [[menu valueForKey:@"subs"] valueForKey:@"menuId"];
        controller.menuDelegate = self;
        // have super menu,set title as is
        if (![[menu valueForKey:@"menuUpId"] isEqualToString:@"0"]) {
            controller.navigationItem.title = [menu valueForKey:@"text"];
        }
        // is super menu, set logo to navigationItem
        else{
            controller.navigationItem.title = [menu valueForKey:@"text"];
            UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
            titleView.frame = CGRectMake(0, 0, 80, 25);
            controller.navigationItem.titleView = titleView;
        }
        return controller;
    }
    else if([[menu valueForKey:@"type"] isEqualToString:@"list"])
    {
        VTTableViewMenu *controller = [[VTTableViewMenu alloc] initWithStyle:UITableViewStyleGrouped];
        controller.menuIcons = [[menu valueForKey:@"subs"] valueForKey:@"img"];
        controller.menuTitles = [[menu valueForKey:@"subs"] valueForKey:@"text"];
        controller.menuIds = [[menu valueForKey:@"subs"] valueForKey:@"menuId"];
        controller.menuDelegate = self;
        // have super menu,set title as is
        if (![[menu valueForKey:@"menuUpId"] isEqualToString:@"0"]) {
            controller.navigationItem.title = [menu valueForKey:@"text"];
        }
        // is super menu, set logo to navigationItem
        else{
            controller.navigationItem.title = [menu valueForKey:@"text"];
            UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
            titleView.frame = CGRectMake(0, 0, 80, 25);
            controller.navigationItem.titleView = titleView;
        }
        return controller;
    }
    else return  nil;
}

//delegate
- (void)controller:(UIViewController *)viewController didSelectMenuWithId:(NSString *)menuId
{
    NSString *superMenuId = [config superMenuWithId:menuId];
    // compare superMenuId with superMenuIds
    int index = [superMenuIds indexOfObject:superMenuId];
    
    if (index > -1 && index < [superMenuIds count]) {
        UINavigationController *togoNavigate = [self.tabBarController.viewControllers objectAtIndex:index];
        //function invoke in current tab
        if ([togoNavigate isEqual:viewController.navigationController]) {
            [togoNavigate pushViewController:[self viewControllerWithMenuId:menuId] animated:YES] ;
        }
        //switch to related tab and invoke
        //to do
        else{
            [self.tabBarController setSelectedIndex:index];
            [togoNavigate popToRootViewControllerAnimated:NO];
        }
    }
}


@end
