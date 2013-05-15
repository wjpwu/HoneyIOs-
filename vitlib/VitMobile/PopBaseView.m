//
//  PopBaseView.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PopBaseView.h"

@implementation PopBaseView
@synthesize delegate;



//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

- (void)setupUI
{
    [self.view setBackgroundColor:[UIColor colorWithRed:0.4 green:0.449 blue:0.461 alpha:0.6]];
//    NSArray *cor = [NSArray arrayWithObjects:UIColorFromRGB(0xCCCFD5), [UIColor whiteColor], nil];
//    [self setColors:cor];
}

//#pragma mark - Private Methods
- (void)fadeIn
{
    self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.view.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.view.alpha = 1;
        self.view.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.view removeFromSuperview];
        }
    }];
}

#pragma mark - Instance Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self.view];
    if (animated) {
        [self fadeIn];
    }
}

- (void)showInMainWindowWithAnimated:(BOOL)animated
{
    [self showInView:[UIApplication sharedApplication].keyWindow animated:animated];
}

@end
