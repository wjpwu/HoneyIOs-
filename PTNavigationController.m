//
//  PTNavigationController.m
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-6-18.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import "PTNavigationController.h"

@interface PTNavigationController ()

@end

@implementation PTNavigationController
@synthesize ptDelegate;

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
    }
    return self;
}

//- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item
//{
//    if (ptDelegate && [ptDelegate respondsToSelector:@selector(shouldPushItem:)]) {
//        return [ptDelegate shouldPushItem:item];
//    }
//    return YES;
//}
//
//- (void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item
//{
//    if (ptDelegate && [ptDelegate respondsToSelector:@selector(didPushItem:)]) {
//        [ptDelegate didPushItem:item];
//    }
//}
//
//- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item
//{
//    if (ptDelegate && [ptDelegate respondsToSelector:@selector(shouldPopItem:)]) {
//        return [ptDelegate shouldPopItem:item];
//    }
//    return YES;
//}
//
//- (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item
//{
//    if (ptDelegate && [ptDelegate respondsToSelector:@selector(didPopItem:)]) {
//        [ptDelegate didPopItem:item];
//    }
//}


@end
