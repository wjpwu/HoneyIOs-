//
//  PTWebViewUI.m
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-5-16.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import "PTWebViewUI.h"
#import "VitMobile/PrettyNavigationBar.h"
#import "PTNavigationController.h"


@interface PTWebViewUI () <UIWebViewDelegate, UINavigationBarDelegate>
{
}
@property (nonatomic, strong) UIWebView *mainWebView;
@property (nonatomic, strong) UIButton *webBack;
@property (nonatomic, strong) UIBarButtonItem *barBackButton;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) UIActivityIndicatorView *indicator;
@property (nonatomic, assign) BOOL hidingbar;



@end


@implementation PTWebViewUI
@synthesize URL;
@synthesize mainWebView;
@synthesize webBack;
@synthesize barBackButton;
@synthesize indicator;
@synthesize hidingbar;

#pragma mark - Initialization

- (id)initWithAddress:(NSString *)urlString {
    return [self initWithAddress:urlString hidenavBar:NO];
}

- (id) initWithAddress:(NSString *)urlString hidenavBar:(BOOL)hiding
{
    if(self = [super init]) {
        self.URL = [NSURL URLWithString:urlString];
        self.hidingbar = hiding;
    }
    
    return self;
}


#pragma mark - Memory management

- (void)dealloc {
    mainWebView.delegate = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - View lifecycle

- (void)loadView {
    mainWebView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    mainWebView.delegate = self;
    mainWebView.scalesPageToFit = NO;
    [mainWebView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    self.view = mainWebView;
        
    [self.view setBackgroundColor:[UIColor clearColor]];
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.view addSubview:indicator];
    indicator.center = self.view.center;
    [indicator startAnimating];
    [indicator setHidesWhenStopped:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (hidingbar) {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (hidingbar) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
	[super viewDidLoad];
    PrettyNavigationBar* customNavigationBar = (PrettyNavigationBar*)self.navigationController.navigationBar;
   

    self.webBack = [customNavigationBar backButtonWith:[UIImage imageNamed:@"button_back.png"] highlight:nil leftCapWidth:12.0];
    [self.webBack addTarget:self action:@selector(webGoBack:) forControlEvents:UIControlEventTouchUpInside];
    [customNavigationBar setText:@"返回" onBackButton:self.webBack];
    self.barBackButton = [[UIBarButtonItem alloc] initWithCustomView:self.webBack];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    URL = nil;
    webBack = nil;
    indicator = nil;
    mainWebView = nil;
    barBackButton = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        return YES;
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
}


#pragma mark web goback / go forward

- (void) webGoForwardWithInfo: (id) forWardPageInfo
{
    if ([mainWebView canGoBack]) {
        self.navigationItem.leftBarButtonItem = self.barBackButton;
//        NSArray *items = self.navigationController.navigationBar.items;
//        if ([items count] > 0) {
//            UINavigationItem *preItem = [items objectAtIndex:[items count] -1];
//            preItem.backBarButtonItem.title = @"abcc";
//            NSMutableArray *ay = [[NSMutableArray alloc] initWithArray:items];
//            [ay removeLastObject];
//            [ay addObject:preItem];
//            [self.navigationController.navigationBar setItems:ay];
//        }
        
//        PTNavigationController *ptnav = (PTNavigationController*)self.navigationController;
//        [ptnav setBackButtonTitle:@"返回111"];
    }
    [self updateBackbarItem];
}

- (void) webGoBack: (id) sender
{
    if ([mainWebView canGoBack]) {
        [mainWebView goBack];
    }
    [self updateBackbarItem];
}

- (void) updateBackbarItem
{
    if ([mainWebView canGoBack]) {
        self.navigationItem.leftBarButtonItem = self.barBackButton;
    }
    else{
        self.navigationItem.leftBarButtonItem = nil;
    }
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [indicator setHidden:NO];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [indicator startAnimating];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [indicator stopAnimating];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    [self webGoForwardWithInfo:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.view setBackgroundColor:[UIColor clearColor]];
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked &&
        [[[request URL] absoluteString] isEqualToString:@"http://cmbandroid/tool"]) {
        if([webView canGoBack])
        {
            [webView goBack];
        }
        else
            [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    return YES;
}


@end
