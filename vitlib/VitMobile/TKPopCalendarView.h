//
//  TKPopCalendarView.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKCalendarMonthView.h"

@protocol TKPopCalendarViewDelegate;
@interface TKPopCalendarView : UIView <TKCalendarMonthViewDelegate,TKCalendarMonthViewDataSource> 
{
    UIView *_headView;
    TKCalendarMonthView *_monthView;
    UILabel *_titleLabel;
    UITextField *_dateField;
    UIButton *_done;
    NSDateFormatter *myDateFormatter;
}
@property (nonatomic,retain) NSDate *selectDate;
@property (nonatomic, assign) id<TKPopCalendarViewDelegate> delegate;


- (id)initWithTitle:(NSString *)aTitle  selectDate : (NSDate*) anDate;

// If animated is YES, PopListView will be appeared with FadeIn effect.
- (void)showInView:(UIView *)aView animated:(BOOL)animated;

- (void)showInMainWindowWithAnimated:(BOOL)animated;


- (void)fadeIn;
- (void)fadeOut;

@end


@protocol TKPopCalendarViewDelegate <NSObject>
@optional
- (void)tkPopListView:(TKPopCalendarView *)popListView didFinishSelectDate:(NSDate*) anSelectDate;
- (void)tkPopListViewDidCancel;
@end
