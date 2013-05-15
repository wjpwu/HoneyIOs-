//
//  CKCalendarPopView.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CKCalendarPopView.h"

@implementation CKCalendarPopView
@synthesize selectDate,delegate,fromDate,toDate;

#pragma mark - initialization & cleaning up

- (id)initWithTitle:(NSString *)aTitle selectedFromDate :(NSDate*)anFromDate andToDate :(NSDate*)anToDate
{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    if (self = [super initWithFrame:rect])
    {
        self.fromDate = anFromDate;
        self.toDate = anToDate;
        self.backgroundColor = [UIColor clearColor];
        _headView = [[CKGradientView alloc] initWithFrame:CGRectZero];
        [_headView setBackgroundColor:[UIColor grayColor]];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = UITextAlignmentRight;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.];
        _titleLabel.text = aTitle;
        [_headView addSubview:_titleLabel];
        
        _dateField = [[UITextField alloc] initWithFrame:CGRectZero];	        
        _dateField.adjustsFontSizeToFitWidth = YES;
        _dateField.textColor = [UIColor blackColor];
        _dateField.tag = 1;
        _dateField.enabled = NO;
        _dateField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _dateField.backgroundColor = [UIColor whiteColor];
        _dateField.borderStyle = UITextBorderStyleRoundedRect;
        _dateField.font = [UIFont boldSystemFontOfSize:16];
        _dateField.textAlignment = UITextAlignmentCenter;
        [_headView addSubview:_dateField];
        
        _done =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_done.titleLabel setFont:[UIFont systemFontOfSize:14.]];
        [_done setTitle:@"OK" forState:UIControlStateNormal];    
        _done.titleLabel.textColor = [UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.];
        [_done addTarget:self action:@selector(didFinish:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:_done];
        
        [self addSubview:_headView];
        
        _monthView = [[CKCalendarView alloc] initWithStartDay:startSunday pickType:pickPeriod frame:CGRectMake(10, 10, 300, 470)];
        _monthView.delegate = self;
        [self addSubview:_monthView];
        [_monthView setHidden:NO];
        
        [self formatDateField];
        if(self.fromDate)
            [_monthView setFromDate:self.fromDate];
        if(self.toDate)
            [_monthView setToDate:self.toDate];
        [self initUI];
    }
    [self setBackgroundColor:[UIColor colorWithRed:0.4 green:0.449 blue:0.461 alpha:0.6]];
    return self;
}

- (id)initWithTitle:(NSString *)aTitle selectedDate :(NSDate*)anDate
{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    if (self = [super initWithFrame:rect])
    {
        self.selectDate = anDate;
        self.backgroundColor = [UIColor clearColor];
        _headView = [[CKGradientView alloc] initWithFrame:CGRectZero];
        [_headView setBackgroundColor:[UIColor grayColor]];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = UITextAlignmentRight;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.];
        _titleLabel.text = aTitle;
        [_headView addSubview:_titleLabel];
        
        _dateField = [[UITextField alloc] initWithFrame:CGRectZero];	        
        _dateField.adjustsFontSizeToFitWidth = YES;
        _dateField.textColor = [UIColor blackColor];
        _dateField.tag = 1;
        _dateField.enabled = NO;
        _dateField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _dateField.backgroundColor = [UIColor whiteColor];
        _dateField.borderStyle = UITextBorderStyleRoundedRect;
        _dateField.font = [UIFont boldSystemFontOfSize:16];
        _dateField.textAlignment = UITextAlignmentCenter;
        [_headView addSubview:_dateField];

        _done =[UIButton buttonWithType:UIButtonTypeRoundedRect];
        [_done.titleLabel setFont:[UIFont systemFontOfSize:14.]];
        [_done setTitle:@"OK" forState:UIControlStateNormal];    
        _done.titleLabel.textColor = [UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.];
        [_done addTarget:self action:@selector(didFinish:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:_done];
        
        [self addSubview:_headView];
        
        _monthView = [[CKCalendarView alloc] initWithStartDay:startSunday frame:CGRectMake(10, 10, 300, 470)];
        _monthView.delegate = self;
        [self addSubview:_monthView];
        [_monthView setHidden:NO];
        if(!self.selectDate)
            self.selectDate = [NSDate date];
        _dateField.text = [self.myDateFormatter stringFromDate:self.selectDate];
        [_monthView setSelectedDate:self.selectDate];
        [self initUI];
    }
    [self setBackgroundColor:[UIColor colorWithRed:0.4 green:0.449 blue:0.461 alpha:0.6]];
    return self;    
}

#pragma mark - initialization tableview frame and title label frame
- (void) initUI
{
    CGRect f = _monthView.frame ;    
    _headView.frame = CGRectMake(f.origin.x, f.origin.y + 90, f.size.width, 40);
    
    _titleLabel.frame = CGRectMake(f.origin.x, 5, 70, 30);
    _dateField.frame = CGRectMake(f.origin.x + 75, 5, 170 , 30);
    _done.frame = CGRectMake(255, 5 ,40, 30);
    _monthView.frame = CGRectMake(f.origin.x, f.origin.y + 130, f.size.width, f.size.height);
}




- (NSDateFormatter*) myDateFormatter{
    if(myDateFormatter == nil){
        myDateFormatter = [[NSDateFormatter alloc] init];
        myDateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return myDateFormatter;
}

- (NSDateFormatter*) periodDateFormatter{
    if(periodDateFormatter == nil){
        periodDateFormatter = [[NSDateFormatter alloc] init];
        periodDateFormatter.dateFormat = @"yy-MM-dd";
    }
    return periodDateFormatter;
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    _dateField.text = [self.myDateFormatter stringFromDate:date];
    self.selectDate = date;
}

- (void)calendar:(CKCalendarView *)calendar didSelectFromDate:(NSDate *)afromDate andToDate:(NSDate *)atoDate
{
    self.fromDate = afromDate;
    self.toDate = atoDate;
    [self formatDateField];
}

- (void) formatDateField
{
    NSString *fr = [self.periodDateFormatter stringFromDate:self.fromDate];
    NSString *to = [self.periodDateFormatter stringFromDate:self.toDate];
    _dateField.text = [NSString stringWithFormat:@"%@ ~ %@",
                       fr == nil? @"" : fr,
                       to == nil? @"" : to];
}


//#pragma mark - Private Methods
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Instance Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self];
    if (animated) {
        [self fadeIn];
    }
}

- (void)showInMainWindowWithAnimated:(BOOL)animated
{
    [self showInView:[UIApplication sharedApplication].keyWindow animated:animated];
}

// click ok
-(void) didFinish : (id)sender
{
    if (self.selectDate) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(ckPopListView:didFinishSelectDate:)]) {
            [self.delegate ckPopListView:self didFinishSelectDate:self.selectDate];
        }
    }
    else if((self.fromDate && self.toDate) || (self.fromDate == nil && self.toDate == nil)){
        if (self.delegate && [self.delegate respondsToSelector:@selector(ckPopListView:didFinishSelectFromDate:andToDate:)]) {
            [self.delegate ckPopListView:self didFinishSelectFromDate:self.fromDate andToDate:self.toDate];
        }
    }

    // dismiss self
    [self fadeOut];
}


#pragma mark - TouchTouchTouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint pointtask=[[touches anyObject] locationInView:self];
    if (pointtask.y < 90 ) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(tkPopListViewDidCancel)]) {
            [self.delegate ckPopListViewDidCancel];
        }
        [self fadeOut];
    }
}


@end
