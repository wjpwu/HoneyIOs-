//
//  CNTAlert.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-9-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNTAlert.h"

@interface CNTAlert ()
@property (nonatomic, assign) BOOL presented;
- (void)increaseHeightBy:(CGFloat)delta;
- (void)layout;

@end

@implementation CNTAlert
@synthesize view;
@synthesize delegate;
@synthesize contentView = _contentView;
@synthesize presented = _presented;



#pragma mark -
- (void)show {
	[self.view show];
}


- (id<UIAlertViewDelegate>)alertViewDelegate {
	return self.view.self.delegate;
}

- (void)setAlertViewDelegate:(id<UIAlertViewDelegate>)alertViewDelegate {
	[self.view setDelegate:alertViewDelegate];
}


#pragma mark - Private
- (void)increaseHeightBy:(CGFloat)delta {
	CGPoint c = self.view.center;
	CGRect r = self.view.frame;
	r.size.height += delta;
    r.size.width = 280;
	self.view.frame = r;
	self.view.center = c;
	self.view.frame = CGRectIntegral(self.view.frame);
	
	for(UIView *subview in [self.view subviews]) {
		if([subview isKindOfClass:[UIControl class]]) {
			CGRect frame = subview.frame;
			frame.origin.y += delta;
			subview.frame = frame;
		}
	}
}


- (void)layout {
	CGFloat height = 0.;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
	CGFloat resultHeigh;
	
    if(height > screenRect.size.height) {
        if(UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
            resultHeigh = screenRect.size.height - self.view.frame.size.height - 65.;
        else
            resultHeigh = screenRect.size.width - self.view.frame.size.height - 65.;
    }
    
    resultHeigh = self.contentView.frame.size.height;
	
	[self increaseHeightBy:resultHeigh];
    [self.contentView setFrame:CGRectMake(12,
                                    self.view.frame.size.height - resultHeigh - 65,
                                    self.view.frame.size.width - 24,
                                    resultHeigh)];
}


#pragma mark -
#pragma mark UIAlertViewself.delegate
- (void)alertViewCancel:(UIAlertView *)alertView {
	if ([self.delegate respondsToSelector:@selector(cntAlertCancel:)])
		[self.delegate cntAlertCancel:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if ([self.delegate respondsToSelector:@selector(cntAlert:clickedButtonAtIndex:)])
		[self.delegate cntAlert:self clickedButtonAtIndex:buttonIndex];
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
	if (!_presented)
		[self layout];
	_presented = YES;
	if ([self.delegate respondsToSelector:@selector(willPresentcntAlert:)])
		[self.delegate willPresentcntAlert:self];
}
- (void)didPresentAlertView:(UIAlertView *)alertView {
	if ([self.delegate respondsToSelector:@selector(didPresentcntAlert:)])
		[self.delegate didPresentcntAlert:self];
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
	if ([self.delegate respondsToSelector:@selector(cntAlert:willDismissWithButtonIndex:)])
		[self.delegate cntAlert:self willDismissWithButtonIndex:buttonIndex];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	_presented = NO;
	if ([self.delegate respondsToSelector:@selector(cntAlert:didDismissWithButtonIndex:)])
		[self.delegate cntAlert:self didDismissWithButtonIndex:buttonIndex];
}

@end
