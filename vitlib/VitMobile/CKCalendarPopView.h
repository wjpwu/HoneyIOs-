//
//  CKCalendarPopView.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CKCalendarView.h"

@protocol CKCalendarPopViewDelegate;
@interface CKCalendarPopView : UIView <CKCalendarDelegate> 
{
    CKGradientView *_headView;
    CKCalendarView *_monthView;
    UILabel *_titleLabel;
    UITextField *_dateField;
    UIButton *_done;
    NSDateFormatter *myDateFormatter;
    NSDateFormatter *periodDateFormatter;
}
@property (nonatomic,retain) NSDate *selectDate;
@property (nonatomic,retain) NSDate *fromDate;
@property (nonatomic,retain) NSDate *toDate;
@property (nonatomic, assign) id<CKCalendarPopViewDelegate> delegate;


- (id)initWithTitle:(NSString *)aTitle selectedDate :(NSDate*)anDate;
- (id)initWithTitle:(NSString *)aTitle selectedFromDate :(NSDate*)anFromDate andToDate :(NSDate*)anToDate;


// If animated is YES, PopListView will be appeared with FadeIn effect.
- (void)showInView:(UIView *)aView animated:(BOOL)animated;
- (void)showInMainWindowWithAnimated:(BOOL)animated;


- (void)fadeIn;
- (void)fadeOut;

@end


@protocol CKCalendarPopViewDelegate <NSObject>
@optional
- (void)ckPopListView:(CKCalendarPopView *)popListView didFinishSelectDate:(NSDate*)anSelectDate;
- (void)ckPopListView:(CKCalendarPopView *)popListView didFinishSelectFromDate:(NSDate*)fDate
            andToDate :(NSDate*)tDate;

- (void)ckPopListViewDidCancel;
@end