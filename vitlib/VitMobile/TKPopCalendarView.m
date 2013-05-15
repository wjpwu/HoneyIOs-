//
//  TKPopCalendarView.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TKPopCalendarView.h"

@implementation TKPopCalendarView
@synthesize selectDate,delegate;

#pragma mark - initialization & cleaning up
- (id)initWithTitle:(NSString *)aTitle  selectDate : (NSDate*) anDate;
{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    if (self = [super initWithFrame:rect])
    {
        self.selectDate = anDate;
        self.backgroundColor = [UIColor clearColor];
        _headView = [[UIView alloc] initWithFrame:CGRectZero];
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
        [_done addTarget:self action:@selector(didFinishCheckBoxSelection:) forControlEvents:UIControlEventTouchUpInside];
        [_headView addSubview:_done];
        
        [self addSubview:_headView];
        
        _monthView = [[TKCalendarMonthView alloc] initWithSundayAsFirst:YES];
        _monthView.delegate = self;
        _monthView.dataSource = self;
        [self addSubview:_monthView];
        [_monthView reload];
        [_monthView setHidden:NO];
        
        _dateField.text = self.selectDate == nil ?[self.myDateFormatter stringFromDate:[NSDate date]] :[self.myDateFormatter stringFromDate:self.selectDate];
        if(self.selectDate)
            [_monthView selectDate:self.selectDate];
        
        [self initUI];
        
    }
    [self setBackgroundColor:[UIColor colorWithRed:0.4 green:0.449 blue:0.461 alpha:0.6]];
    return self;    
}

#pragma mark - initialization tableview frame and title label frame
- (void) initUI
{

    CGRect f = _monthView.frame ;
    
    _headView.frame = CGRectMake(0, f.origin.y + 90, f.size.width, 40);
    _titleLabel.frame = CGRectMake(10, 5, 100, 30);
    _dateField.frame = CGRectMake(115, 5, 120 , 30);
    _done.frame = CGRectMake(265, 5 ,40, 30);
    _monthView.frame = CGRectMake(f.origin.x, f.origin.y + 130, f.size.width, f.size.height);
}



- (NSArray*) calendarMonthView:(TKCalendarMonthView*)monthView marksFromDate:(NSDate*)startDate toDate:(NSDate*)lastDate{
	return nil;
}


- (NSDateFormatter*) myDateFormatter{
    if(myDateFormatter == nil){
        myDateFormatter = [[NSDateFormatter alloc] init];
        myDateFormatter.dateFormat = @"yyyy-MM-dd";
    }
    return myDateFormatter;
}

-(void)calendarMonthView:(TKCalendarMonthView *)monthView didSelectDate:(NSDate *)date
{
    _dateField.text = [self.myDateFormatter stringFromDate:date];
    self.selectDate = date;
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
-(void) didFinishCheckBoxSelection : (id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tkPopListView:didFinishSelectDate:)]) {
        [self.delegate tkPopListView:self didFinishSelectDate:self.selectDate];
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
            [self.delegate tkPopListViewDidCancel];
        }
         [self fadeOut];
    }
}

#pragma mark - DrawDrawDraw
//- (void)drawRect1:(CGRect)rect
//{
//    
//    CGRect bgRect = [self popListFrame];
//    
//    CGRect separatorRect = CGRectMake(POPLISTVIEW_SCREENINSET, bgRect.origin.y + POPLISTVIEW_HEADER_HEIGHT - 2,
//                                      rect.size.width - 2 * POPLISTVIEW_SCREENINSET, 2);    
//    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//    // Draw the background with shadow
//    CGContextSetShadowWithColor(ctx, CGSizeZero, 6., [UIColor colorWithWhite:0 alpha:.75].CGColor);
//    [[UIColor colorWithWhite:0 alpha:.75] setFill];
//    
//    
//    float x = bgRect.origin.x;
//    float y = bgRect.origin.y;
//    float width = bgRect.size.width;
//    float height = bgRect.size.height;
//    CGMutablePathRef path = CGPathCreateMutable();
//	CGPathMoveToPoint(path, NULL, x, y + POPLISTRADIUS);
//	CGPathAddArcToPoint(path, NULL, x, y, x + POPLISTRADIUS, y, POPLISTRADIUS);
//	CGPathAddArcToPoint(path, NULL, x + width, y, x + width, y + POPLISTRADIUS, POPLISTRADIUS);
//	CGPathAddArcToPoint(path, NULL, x + width, y + height, x + width - POPLISTRADIUS, y + height, POPLISTRADIUS);
//	CGPathAddArcToPoint(path, NULL, x, y + height, x, y + height - POPLISTRADIUS, POPLISTRADIUS);
//	CGPathCloseSubpath(path);
//	CGContextAddPath(ctx, path);
//    CGContextFillPath(ctx);
//    CGPathRelease(path);
//    
//    // Draw the title and the separator with shadow
//    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 0.5f, [UIColor blackColor].CGColor);
//    [[UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.] setFill];
//    CGContextFillRect(ctx, separatorRect);
//}
@end
