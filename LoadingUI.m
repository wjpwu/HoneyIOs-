//
//  LoadingUI.m
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-6-5.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import "LoadingUI.h"
#import "PTSession.h"
#import "PTNavigate.h"
#import "Reachability.h"

@interface LoadingUI ()
@property (nonatomic) NSTimer *timer;
@property (nonatomic) UIAlertView *alert;
@end

@implementation LoadingUI
@synthesize progress;
@synthesize timer;
@synthesize alert;

- (id)init
{
    self = [super initWithNibName:@"LoadingUI" bundle:nil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated
{
    [defaultNotifCenter addObserver:self selector:@selector(doneSessionInit) name:NNDidFinishInitMenus object:nil];
    [progress startAnimating];
    timer=[NSTimer scheduledTimerWithTimeInterval:3
                                           target:self
                                         selector:@selector(startSession)
                                         userInfo:nil
                                          repeats:YES];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [defaultNotifCenter removeObserver:self];
    [progress stopAnimating];
    [super viewDidDisappear:animated];
}


- (void)viewDidUnload {
    [self setProgress:nil];
    [super viewDidUnload];
}


- (void) startSession
{
    if (alert) {
        [alert dismissWithClickedButtonIndex:-1 animated:YES];
    }
    [[PTSession shareInstance] startSession];
}

- (void) doneSessionInit
{
    [timer invalidate];
    [[PTNavigate shareInstance] popToTabbarController];
}

- (void) handlerError:(NSError *)error
{
    alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.localizedDescription delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
