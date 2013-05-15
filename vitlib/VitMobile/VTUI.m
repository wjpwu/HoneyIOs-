//
//  VitUI.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTUI.h"

@interface VTUI ()

@end

@implementation VTUI
@synthesize popDelegate;
@synthesize hideTabBarTitle;

#pragma mark init method
- (id)init
{
    self = [super init];
    if (self) {
        defaultNotifCenter = [NSNotificationCenter defaultCenter];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        defaultNotifCenter = [NSNotificationCenter defaultCenter];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [defaultNotifCenter addObserver:self selector:@selector(updateTheme:) name:kThemeDidChangeNotification 
        object:nil];
    [self updateTheme:nil];
    debug_NSLog(@"invoke class name : %@",self.class);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [defaultNotifCenter removeObserver:self name:kThemeDidChangeNotification object:nil];
    defaultNotifCenter = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)resignResponder
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIView   *firstResponder = [keyWindow performSelector:@selector(firstResponder)];
    if ([firstResponder isKindOfClass:[UIView class]]) {
        [firstResponder resignFirstResponder];
    }
}

- (void)setupUI
{
//    [self.view setBackgroundColor:[UIColor colorWithRed:0.4 green:0.449 blue:0.461 alpha:0.6]];
}

- (void)popBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

//#pragma mark - Private Methods
- (void)fadeIn
{
//    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.view.alpha = 1;
//        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}

- (void)fadeOut
{
    if ([self.view superview]) {
        [UIView animateWithDuration:.35 animations:^{
//            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
            self.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.view removeFromSuperview];
            }
        }];
    }
}

#pragma mark - Instance Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    if ([[aView subviews] indexOfObject:self.view] > -1) {
        [aView bringSubviewToFront:self.view];
    }
    else {
        self.view.frame = aView.bounds;
        self.view.alpha = 0.0f;
        [aView addSubview:self.view];
        if (animated) {
            [self fadeIn];
        }
    }
}

- (void)showInMainWindowWithAnimated:(BOOL)animated
{
    [self showInView:[UIApplication sharedApplication].keyWindow animated:animated];
}


-(void)updateTheme:(NSNotification*)notif
{  
    [[ThemeManager sharedThemeManager] setThemeBackgroundForController:self];
}

@end
