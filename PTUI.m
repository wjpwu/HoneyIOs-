//
//  PTUI.m
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-6-7.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import "PTUI.h"

@interface PTUI ()

@end

@implementation PTUI

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    [super viewDidAppear:animated];
    [defaultNotifCenter addObserver:self selector:@selector(didReceivedFail:) name:NNDidGetFail object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [defaultNotifCenter removeObserver:self];
    [super viewDidDisappear:animated];
}

- (void) didReceivedFail:(NSNotification*) sender
{
    id a = [[sender object] valueForKey:@"error"];
    if ([a isKindOfClass:[NSError class]]) {
//        NSError *e = (NSError*)a;
//        [[e userInfo] valueForKey:@"Code"];
        [self handlerError:a];
    }
}

- (void) handlerError :(NSError*) error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.localizedDescription delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

@end
