//
//  CKCalendarAlert.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-9-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CKCalendarAlert.h"
#import <QuartzCore/QuartzCore.h>



@implementation CKCalendarAlert
@synthesize view = _alertView;
@synthesize contentView = _monthView;
@synthesize type=_type;
@synthesize delegate = _delegate;
@synthesize selectDate,fromDate,toDate;


- (id)initWithCalendarStyle:(datePickType) pickStyle Title:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle messageFormat:(NSString *)format args:(va_list)args {
	if ((self = [super init])) {
		NSString *message = format ? [[NSString alloc] initWithFormat:format arguments:args] : nil;
		_type = pickStyle;
        if (pickStyle == pickDate) {
            _alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:@"清除",nil];
        }
        else{
            _alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:nil];
            UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"取消",@"确定",@"清除", nil]];
            segment.segmentedControlStyle = UISegmentedControlStyleBar;
            segment.tintColor = [UIColor darkGrayColor];
            [segment addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
            [segment sizeToFit];
             segment.frame = CGRectMake(10, 82, 260, 40);
            [_alertView addSubview:segment];
        }

        _monthView = [[CKCalendarView alloc] initWithStartDay:startSunday pickType:pickStyle];
        ((CKCalendarView*)_monthView).delegate = self;
		[_alertView addSubview:_monthView];
		[[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidChangeStatusBarOrientationNotification object:nil queue:nil usingBlock:^(NSNotification *n) {
			dispatch_after(DISPATCH_TIME_NOW, dispatch_get_main_queue(), ^{[self layout];});
		}];
	}
	
	return self;
}

- (id)initWithCalendarStyle:(datePickType) pickStyle Title:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle messageFormat:(NSString *)message, ... {
	va_list list;
	va_start(list, message);
	self = [self initWithCalendarStyle:pickStyle Title:title cancelButtonTitle:cancelTitle messageFormat:message args:list];
	va_end(list);
	return self;
}

+ (id)alertWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle messageFormat:(NSString *)message, ... {
	return [[CKCalendarAlert alloc] initWithCalendarStyle:pickDate Title:title cancelButtonTitle:cancelTitle messageFormat:message];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)segmentChange: (UISegmentedControl*)sender {
    [_alertView dismissWithClickedButtonIndex:sender.selectedSegmentIndex animated:YES]; 
}

#pragma mark -
- (void)show {
    [self updateMessage];
	[super show];
}

#pragma mark - Properties

- (void)setToDate:(NSDate *)ttoDate
{
    toDate = ttoDate;
    ((CKCalendarView*)_monthView).toDate = ttoDate;
}

- (void)setSelectDate:(NSDate *)sselectDate
{
    selectDate = sselectDate;
    ((CKCalendarView*)_monthView).selectedDate = sselectDate;
}

- (void)setFromDate:(NSDate *)ffromDate
{
    fromDate = ffromDate;
    ((CKCalendarView*)_monthView).fromDate = ffromDate;
}

- (id<UIAlertViewDelegate>)alertViewDelegate {
	return _alertView.delegate;
}

- (void)setAlertViewDelegate:(id<UIAlertViewDelegate>)alertViewDelegate {
	[_alertView setDelegate:alertViewDelegate];
}


#pragma mark - Private

- (void)increaseHeightBy:(CGFloat)delta {
	CGPoint c = _alertView.center;
	CGRect r = _alertView.frame;
	r.size.height += delta;
    r.size.width = 280;
	_alertView.frame = r;
	_alertView.center = c;
	_alertView.frame = CGRectIntegral(_alertView.frame);
	
	for(UIView *subview in [_alertView subviews]) {
		if([subview isKindOfClass:[UIControl class]]) {
			CGRect frame = subview.frame;
			frame.origin.y += delta;
			subview.frame = frame;
		}
	}
}


- (void)layout {
    // calendar height
    float resultHeigh = 280;
	[self increaseHeightBy:resultHeigh];
    float oy = _alertView.frame.size.height - resultHeigh - 75;
    if (_type == pickDate)
    {
        oy += 10;
    }
    [_monthView setFrame:CGRectMake(12,
                                    oy,
                                    _alertView.frame.size.width - 24,
                                    resultHeigh)];
}



#pragma mark CKCalendarView delegate
static NSDateFormatter *instance = nil;
- (NSDateFormatter*) formatter{
    if(instance == nil){
        instance = [[NSDateFormatter alloc] init];
        NSLocale* zhCN = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [instance setLocale: zhCN];
        [instance setLenient: YES];
        [instance setDateFormat:@"yyyy-MM-dd"];
        instance.timeStyle = NSDateFormatterNoStyle;
        instance.dateStyle = NSDateFormatterMediumStyle;
        instance.dateFormat = @"yyyy-MM-dd";
    }
    return instance;
}


- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    self.selectDate = date;
    [self updateMessage];
    [_alertView dismissWithClickedButtonIndex:-1 animated:YES];    
}

- (void)calendar:(CKCalendarView *)calendar didSelectFromDate:(NSDate *)afromDate andToDate:(NSDate *)atoDate
{
    self.fromDate = afromDate;
    self.toDate = atoDate;
    [self updateMessage];
}

- (void) updateMessage
{
    if (_type == pickDate) {
        _alertView.message = [self.formatter stringFromDate:selectDate];
    }
    else{
        NSString *fr = [self.formatter stringFromDate:self.fromDate];
        NSString *to = [self.formatter stringFromDate:self.toDate];
        _alertView.message = [NSString stringWithFormat:@"%@ ~ %@",
                              fr == nil? @"" : fr,
                              to == nil? @"" : to];
        [_alertView setNeedsDisplay];
    }
}


@end
