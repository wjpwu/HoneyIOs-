//
//  PTNavigate.m
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-5-15.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import "PTNavigate.h"
#import "PTMenus.h"
#import "PTWebViewUI.h"
#import "VitMobile/VTGridMenu.h"
#import "VitMobile/VTTableViewMenu.h"
#import "VitMobile/PrettyNavigationBar.h"
#import "LoadingUI.h"
#import "LoginUI.h"
#import "PTGridMenuUI.h"
#import "PTWelcomeUI.h"
#import "QREncodeUI.h"
#import "QRDecodeUI.h"
#import "PTSession.h"
#import "PTNavigationController.h"

@interface PTNavigate () <VTSelectMenuDelegate,PTModLoginDelegate,UIAlertViewDelegate>

@property (retain, nonatomic) PTMenus *config;
// to store the first view menu id
@property (retain, nonatomic) NSArray *superMenuIds;
@property (retain, nonatomic) UITabBarController *tabBarController;


@end

@implementation PTNavigate
@synthesize rootViewController;
@synthesize tabBarController;
@synthesize config;
@synthesize superMenuIds;


static PTNavigate *menuGate;

+ (PTNavigate*)shareInstance
{
    @synchronized(self) {
        if (menuGate==nil) {
            menuGate = [[PTNavigate alloc] init];
        }
    }
    return menuGate;
}

- (id) init
{
    self = [super  init];
    if (self) {
        LoadingUI *load = [[LoadingUI alloc] init];
        rootViewController = [[UINavigationController alloc] initWithRootViewController:load];
        [rootViewController setNavigationBarHidden:YES];
        self.config = [PTMenus shareMenuInstance];
    }
    return self;
}

- (void)popToTabbarController
{
    [self setupTabs];
    [self.rootViewController pushViewController:self.tabBarController animated:YES];
}

- (void) setupTabs
{
    self.tabBarController = [[UITabBarController alloc] init];
    //tab menu collection
//    superMenuIds = [NSArray arrayWithObjects:@"1",@"2",@"4",@"9", nil];
    superMenuIds = [NSArray arrayWithObjects:@"1",@"2",@"9",@"login", nil];
    self.tabBarController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];

    //init tab viewcontrollers
    NSMutableArray *tabs = [NSMutableArray arrayWithCapacity:[superMenuIds count]];
    for (NSString *superId in superMenuIds) {
        [tabs addObject:[self uiControllerWithSuperMenuId:superId]];
    }
    self.tabBarController.viewControllers = tabs;
}

- (void) updateTabsAfterLogin
{
    NSMutableArray* tabs = [tabBarController.viewControllers mutableCopy];
    [tabs removeObjectAtIndex:3];
    [tabs addObject:[self uiControllerWithSuperMenuId:@"4"]];
    self.tabBarController.viewControllers = tabs;
    superMenuIds = [NSArray arrayWithObjects:@"1",@"2",@"9",@"4", nil];
}

- (UIViewController*) uiControllerWithSuperMenuId:(NSString*) tt
{
    if ([tt isEqualToString:@"login"]) {
        id menu = [config menuInfoWithId:@"4"];
        LoginUI *login = [[LoginUI alloc] init];
        login.tabBarItem.image = [UIImage imageNamed:[menu valueForKey:@"img"]];
        login.tabBarItem.title = [menu valueForKey:@"text"];
        UINavigationController *nav = [[PTNavigationController alloc] initWithRootViewController:login];
        UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plogo"]];
//        titleView.frame = CGRectMake(0, 0, 240, 32);
        login.navigationItem.titleView = titleView;
        [nav setValue:[[PrettyNavigationBar alloc] init] forKeyPath:@"navigationBar"];
        return nav;
    }
    else{
        id menu = [config menuInfoWithId:tt];
        UINavigationController *nav = [[PTNavigationController alloc] initWithRootViewController:[self viewControllerWithMenuId:tt]];
        nav.tabBarItem.image = [UIImage imageNamed:[menu valueForKey:@"img"]];
        nav.tabBarItem.title = [menu valueForKey:@"text"];
        [nav setValue:[[PrettyNavigationBar alloc] init] forKeyPath:@"navigationBar"];
        [nav.view setBackgroundColor:[UIColor clearColor]];
        return nav;
    }
}


- (UIViewController*) viewControllerWithMenuId:(NSString*) mm
{
    id menu = [config menuInfoWithid:mm childInfo:YES];
    // display grid view
    if ([[menu valueForKey:@"type"] isEqualToString:@"grid"]) {
        PTGridMenuUI *controller = nil;
        if ([mm isEqualToString:@"4"]) {
            controller = [[PTWelcomeUI alloc] init];
        } else
            controller = 
        [mm isEqualToString:@"1"] ? [[PTGridMenuUI alloc] initWithLongPressSupport] : [[PTGridMenuUI alloc] init];
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
            UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plogo"]];
//            titleView.frame = CGRectMake(0, 0, 240, 32);
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
            UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plogo"]];
//            titleView.frame = CGRectMake(0, 0, 240, 32);
            controller.navigationItem.titleView = titleView;
        }
        return controller;
    }
    
    else if ([[menu valueForKey:@"type"] isEqualToString:@"func"])
    {
        NSString *url = [[menu valueForKey:@"msg"] stringByReplacingOccurrencesOfString:@"Post(" withString:@""];
        PTWebViewUI *web = [[PTWebViewUI alloc] initWithAddress:[url stringByReplacingOccurrencesOfString:@")" withString:@""] hidenavBar:YES];
        return web;
    }
    
    else if ([[menu valueForKey:@"type"] isEqualToString:@"funcc"])
    {
        NSString *url = [[menu valueForKey:@"msg"] stringByReplacingOccurrencesOfString:@"Post(" withString:@""];
        PTWebViewUI *web = [[PTWebViewUI alloc] initWithAddress:[url stringByReplacingOccurrencesOfString:@")" withString:@""] hidenavBar:NO];
        return web;
    }
    
    else if ([[menu valueForKey:@"type"] isEqualToString:@"web"])
    {
        NSString *url = [[menu valueForKey:@"msg"] stringByReplacingOccurrencesOfString:@"PostRequest(" withString:@""];
        url = [url stringByReplacingOccurrencesOfString:@")" withString:@""];
        PTWebViewUI *web = [[PTWebViewUI alloc] initWithAddress: wwhostwithfunc(url)];
        web.navigationItem.title = [menu valueForKey:@"text"];
        return web;
    }
    
    else if ([[menu valueForKey:@"type"] isEqualToString:@"qrencode"])
    {
        QREncodeUI *qr = [[QREncodeUI alloc] init];
        qr.navigationItem.title = [menu valueForKey:@"text"];
        return qr;
    }
    else if ([[menu valueForKey:@"type"] isEqualToString:@"qrdecode"])
    {
        QRDecodeUI *qr = [[QRDecodeUI alloc] init];
        qr.navigationItem.title = [menu valueForKey:@"text"];
        return qr;
    }
    else return  nil;
}

//delegate
- (void)controller:(UIViewController *)viewController didSelectMenuWithId:(NSString *)menuId
{    
    // required login but didn't login
    id menu = [config menuInfoWithid:menuId childInfo:NO];
    if ([[menu valueForKey:@"type"] isEqualToString:@"web"] && ![[PTSession shareInstance] sessionValueWithKey:@"token"]) {
        // store into session
        [[PTSession shareInstance] storeSessionValueWithKey:@"ptnav-viewcontroller" value:viewController];
        [[PTSession shareInstance] storeSessionValueWithKey:@"ptnav-menuid" value:menuId];

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该功能要求使用登陆，您当前还没有登陆，您需要登陆吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
    else {
        NSString *superMenuId = [config superMenuWithId:menuId];
        // compare superMenuId with superMenuIds
        int index = [superMenuIds indexOfObject:superMenuId];
        
        if (index > -1 && index < [superMenuIds count]) {
            UINavigationController *togoNavigate = [self.tabBarController.viewControllers objectAtIndex:index];
            UIViewController *controller = [self viewControllerWithMenuId:menuId];
            //        if ([controller isKindOfClass:[PTWebViewUI class]]) {
            //            togoNavigate.navigationBarHidden = YES;
            //        }
            //function invoke in current tab
            if ([togoNavigate isEqual:viewController.navigationController]) {
                [togoNavigate pushViewController:controller animated:YES] ;
            }
            //switch to related tab and invoke
            //to do
            else{
                [self.tabBarController setSelectedIndex:index];
                [togoNavigate popToRootViewControllerAnimated:NO];
                [togoNavigate pushViewController:controller animated:YES] ;
            }
        }
    }
}


#pragma UIAlert delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        LoginUI *login = [[LoginUI alloc] initForMo];
        login.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:login];
        [nav setValue:[[PrettyNavigationBar alloc] init] forKeyPath:@"navigationBar"];
        UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"plogo"]];
//        titleView.frame = CGRectMake(0, 0, 240, 32);
        login.navigationItem.titleView = titleView;
        [self.tabBarController presentModalViewController:nav animated:YES];
    }
}


#pragma delegate : PTModLoginDelegate

- (void)didFinishLogin
{
    [self.tabBarController dismissModalViewControllerAnimated:YES];
    if([[PTSession shareInstance] sessionValueWithKey:@"token"])
    {
        [self controller:[[PTSession shareInstance] sessionValueWithKey:@"ptnav-viewcontroller"]
     didSelectMenuWithId:[[PTSession shareInstance] sessionValueWithKey:@"ptnav-menuid"]];
        [[PTSession shareInstance] removeFromSessionWithKey:@"ptnav-viewcontroller"];
        [[PTSession shareInstance] removeFromSessionWithKey:@"ptnav-menuid"];
    }
}

- (void)didCancelLogin
{
    [self.tabBarController dismissModalViewControllerAnimated:YES];
    [[PTSession shareInstance] removeFromSessionWithKey:@"ptnav-viewcontroller"];
    [[PTSession shareInstance] removeFromSessionWithKey:@"ptnav-menuid"];
}



@end
