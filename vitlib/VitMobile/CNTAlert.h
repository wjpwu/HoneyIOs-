//
//  CNTAlert.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-9-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CNTAlert;
@protocol CNTAlertDelegate <NSObject>
@optional

- (void)cntAlertCancel:(CNTAlert *)cntAlert;

- (void)cntAlert:(CNTAlert *)cntAlert clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)willPresentcntAlert:(CNTAlert *)cntAlert;
- (void)didPresentcntAlert:(CNTAlert *)cntAlert;

- (void)cntAlert:(CNTAlert *)cntAlert willDismissWithButtonIndex:(NSInteger)buttonIndex;
- (void)cntAlert:(CNTAlert *)cntAlert didDismissWithButtonIndex:(NSInteger)buttonIndex;

@end

@interface CNTAlert : NSObject

@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIAlertView *view;
@property (nonatomic, assign) id <CNTAlertDelegate> delegate;




- (void)show;
- (void)increaseHeightBy:(CGFloat)delta ;

@end
