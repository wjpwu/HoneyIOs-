//
//  PopTKCalendarPickerTableCell.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PopTKCalendarPickerTableCell.h"

@implementation PopTKCalendarPickerTableCell
@synthesize myDate,dateFormatter;

- (id)initWithWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initDefaultStyleWithReuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self; 
}

//#pragma mark set pop view selection

- (BOOL)becomeFirstResponder {
	[self.popMonth showInMainWindowWithAnimated:YES];
	return [super becomeFirstResponder];
}

- (NSDateFormatter*) dateFormatter
{
    if (!dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
        self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }
    return dateFormatter;
}

- (TKPopCalendarView*) popMonth
{
    if (!popMonth) {
        popMonth = [[TKPopCalendarView alloc] initWithTitle:self.textLabel.text selectDate:myDate];
        popMonth.delegate = self;
    }
    return popMonth;
}


//
-(void)tkPopListViewDidCancel
{
    
}

//
-(void)tkPopListView:(TKPopCalendarView *)popListView didFinishSelectDate:(NSDate *)anSelectDate
{
    debug_NSLog(@"pop tk calendar cell.tag %d", self.tag);
    self.myDate = anSelectDate;
    self._displayLabel.text = [self.dateFormatter stringFromDate:self.myDate]; 
    [self.modeObject setObject:self._displayLabel.text forKey:@"CK_Value"];
    if (self.vitDelegate && [self.vitDelegate respondsToSelector:@selector(tableViewCell:didEndPickDate:)])
    {
        [self.vitDelegate tableViewCell:self didEndPickDate:anSelectDate];
    }
}

@end
