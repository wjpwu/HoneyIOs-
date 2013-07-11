//
//  PTWelcomeUI.m
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-6-20.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import "PTWelcomeUI.h"
#import "PTSession.h"

@interface PTWelcomeUI ()
@property (nonatomic, strong) UIWebView *mainWebView;
@end

@implementation PTWelcomeUI
@synthesize mainWebView;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)loadView
{
    [super loadView];
    mainWebView = [[UIWebView alloc] initWithFrame:CGRectMake(20, 120, 280, 230)];
    mainWebView.scalesPageToFit = NO;
    mainWebView.scrollView.scrollEnabled = NO;
    [mainWebView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    [self.view addSubview:mainWebView];;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSURL *url = [NSURL URLWithString:wwhostwithfunc(@"mwelcome")];
    [mainWebView loadRequest:[NSURLRequest requestWithURL:url]];
}

@end
