//
//  PopCKCalendarPeriodPickTableCell.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PopCKCalendarPeriodPickTableCell.h"

@implementation PopCKCalendarPeriodPickTableCell
@synthesize fromDate,toDate,dateFormatter;

- (id)initWithWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initDefaultStyleWithReuseIdentifier:reuseIdentifier];
    if (self) {
        period = [NSMutableDictionary dictionaryWithCapacity:2];
    }
    return self; 
}

//#pragma mark set pop view selection
- (BOOL)becomeFirstResponder {
    CKCalendarAlert *alert = [[CKCalendarAlert alloc] initWithCalendarStyle:pickPeriod  Title:self.textLabel.text cancelButtonTitle:nil messageFormat:nil];
    alert.view.message = self._displayLabel.text;
    alert.delegate = self;
    [alert show];
	return [super becomeFirstResponder];
}

- (NSDateFormatter*) dateFormatter
{
    if (!dateFormatter) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        NSLocale* zhCN = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        [dateFormatter setLocale: zhCN];
        [dateFormatter setLenient: YES];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
        self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }
    return dateFormatter;
}

- (void)setModeObject:(NSMutableDictionary *)theModeObject
{
    modeObject = theModeObject;
    if ([theModeObject objectForKey:@"CK_Value"]) {
        self._displayLabel.text = [theModeObject objectForKey:@"CK_Value"];
        self.fromDate = [[modeObject valueForKey:KK_VALUE] valueForKey:KK_PeriodD1];
        self.toDate = [[modeObject valueForKey:KK_VALUE] valueForKey:KK_PeriodD2];
    }else{
        self.fromDate = nil;
        self.toDate = nil;
    }
}

- (void)willPresentcntAlert:(CKCalendarAlert *)cntAlert
{
    cntAlert.fromDate = self.fromDate;
    cntAlert.toDate = self.toDate;
    if (self.fromDate && self.toDate) {
        cntAlert.view.message = [NSString stringWithFormat:@"%@ ~ %@",
                                 [self.dateFormatter stringFromDate:self.fromDate],
                                 [self.dateFormatter stringFromDate:self.toDate]];
    }
}

- (void)setFromDate:(NSDate *)afromDate
{
    fromDate = afromDate;
}

- (void)cntAlert:(CKCalendarAlert *)cntAlert didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {        
        self.fromDate = cntAlert.fromDate;
        self.toDate = cntAlert.toDate;

        if (self.fromDate && self.toDate) {
            [period setValue:self.fromDate  forKey:KK_PeriodD1];
            [period setValue:self.toDate  forKey:KK_PeriodD2];
            [self.modeObject setValue:period forKey:KK_VALUE];
            self._displayLabel.text = [NSString stringWithFormat:@"%@\r%@",
                                       [self.dateFormatter stringFromDate:self.fromDate],
                                       [self.dateFormatter stringFromDate:self.toDate]];
        }
        else {
            [period removeAllObjects];
            self.fromDate = nil;
            self.toDate = nil;
            [self.modeObject removeObjectForKey:KK_VALUE];
            [self.modeObject removeObjectForKey:@"CK_DefaultValue"];
            [self.modeObject removeObjectForKey:@"CK_Value"];
            self._displayLabel.text = @"";
        }
        
        [self.modeObject setValue:self._displayLabel.text forKey:@"CK_Value"];
        if (self.vitDelegate && [self.vitDelegate respondsToSelector:@selector(tableViewCell:didEndPickFromDate:andToDate:)])
        {
            [self.vitDelegate tableViewCell:self didEndPickFromDate:self.fromDate andToDate:self.toDate];
        }
    }
    //clean
    else if(buttonIndex == 2)
    {
        [period removeAllObjects];
        self.fromDate = nil;
        self.toDate = nil;
        [self.modeObject removeObjectForKey:KK_VALUE];
        [self.modeObject removeObjectForKey:@"CK_DefaultValue"];
        [self.modeObject removeObjectForKey:@"CK_Value"];
        self._displayLabel.text = nil;
        if (self.vitDelegate && [self.vitDelegate respondsToSelector:@selector(tableViewCell:didEndPickFromDate:andToDate:)])
        {
            [self.vitDelegate tableViewCell:self didEndPickFromDate:self.fromDate andToDate:self.toDate];
        }
    }
    UITableView *tv= (UITableView*)self.superview;
    if ([tv indexPathForCell:self]) {
        [tv reloadRowsAtIndexPaths:[NSArray arrayWithObject:[tv indexPathForCell:self]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}



@end
