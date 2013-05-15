//
//  PopBaseView.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"

#define POPLISTVIEW_SCREENINSET 40.
#define POPLISTVIEW_HEADER_HEIGHT 50.
#define POPLISTRADIUS 0.
#define POPLISTVIEW_TITLE_WIDTH 160

#define POPLISTVIEW_WIDTH 240.

@protocol PopBaseViewDelegate;
@interface PopBaseView : UIViewController
{
    UILabel *_titleLabel;
}

@property (nonatomic, assign) id<PopBaseViewDelegate> delegate;


- (void)setupUI;
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (void)showInMainWindowWithAnimated:(BOOL)animated;



- (void)fadeIn;
- (void)fadeOut;

@end

@protocol PopBaseViewDelegate <NSObject>
@optional
- (void)popView:(PopBaseView *)popView dismissWithResponse:(id)_response;
- (void)popViewDidCancel;
@end