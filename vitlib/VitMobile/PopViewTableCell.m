//
//  PopViewTableCell.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PopViewTableCell.h"

@implementation PopViewTableCell
@synthesize pop,popParView,popV;

- (BOOL)becomeFirstResponder {
    if(pop)
    {
        self.pop.popDelegate = self;
        if (popParView) {
            [self.pop showInView:popParView animated:YES];
        }
        else {
            [self.pop showInMainWindowWithAnimated:YES];
        }
    }
    else if(popV)
    {
        [popV performSelector:@selector(presentInMainView)];
//        if(popParView)
//          [self presentpopView:popV InView:popParView];
//        else
//            [self presentpopView:popV InView:[UIApplication sharedApplication].keyWindow];
    }

	return [super becomeFirstResponder];
}

- (void)presentpopView:(UIView*)popview InView:(UIView*)parentview {
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    window.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.5f];
    [window makeKeyWindow];
	popview.frame = window.bounds;
    window.alpha = 1.0;
//	popview.alpha = 0.0f;
    
    window.windowLevel = UIWindowLevelStatusBar;
    window.hidden = NO;
    window.userInteractionEnabled = YES;
    window.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.5f];
	
	[window addSubview:popview];
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.15f];
//	popview.alpha = 1.0f;
//	[UIView commitAnimations];
}

static UIWindow *window = nil;

- (void)addToMainWindow:(UIView *)view
{
    if(!window)
    {
        window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    if (window.hidden)
    {
//        _previousKeyWindow = [[[UIApplication sharedApplication] keyWindow] retain];
        self.alpha = 0.0f;
        self.hidden = NO;
        self.userInteractionEnabled = YES;
//        [self makeKeyWindow];
    }
    
    if (self.subviews.count > 0)
    {
        ((UIView*)[self.subviews lastObject]).userInteractionEnabled = NO;
    }
    
//    if (_backgroundImage)
//    {
//        UIImageView *backgroundView = [[UIImageView alloc] initWithImage:_backgroundImage];
//        backgroundView.frame = self.bounds;
//        backgroundView.contentMode = UIViewContentModeScaleToFill;
//        [self addSubview:backgroundView];
//        [backgroundView release];
//        [_backgroundImage release];
//        _backgroundImage = nil;
//    }
    
    [self addSubview:view];
}
// override
- (void) formatterResponse :(id)respose
{
    
}

- (void)popViewController:(UIViewController *)popView dismissWithResponse:(id)_response
{
    [self formatterResponse:_response];
    if (self.vitDelegate && [self.vitDelegate respondsToSelector:@selector(tableViewCell:didEndPickValueWithPopView:value:)]) {
        [self.vitDelegate tableViewCell:self didEndPickValueWithPopView:popView value:_response];
    }
    UITableView *tv= (UITableView*)self.superview;
    if ([tv indexPathForCell:self]) {
        [tv reloadRowsAtIndexPaths:[NSArray arrayWithObject:[tv indexPathForCell:self]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

@end
