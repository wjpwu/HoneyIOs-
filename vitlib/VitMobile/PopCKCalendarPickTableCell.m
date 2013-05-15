//
//  PopCKCalendarPickTableCell.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PopCKCalendarPickTableCell.h"

@implementation PopCKCalendarPickTableCell
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
    CKCalendarAlert *alert = [[CKCalendarAlert alloc] initWithCalendarStyle:pickDate  Title:self.textLabel.text cancelButtonTitle:NSLocalizedString(@"取消",@"") messageFormat:@""];
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
        self.myDate = [modeObject valueForKey:KK_VALUE];
    }
}

- (void)willPresentcntAlert:(CKCalendarAlert *)cntAlert
{
    cntAlert.selectDate = self.myDate;
    cntAlert.view.message = self._displayLabel.text;
}

- (void)cntAlert:(CKCalendarAlert *)cntAlert didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    debug_NSLog(@"pop tk calendar cell.tag %d", self.tag);
    if (buttonIndex == -1) {
        self.myDate = cntAlert.selectDate;
        self._displayLabel.text = [self.dateFormatter stringFromDate:self.myDate];
        [self.modeObject setObject:self._displayLabel.text forKey:@"CK_Value"];
        if (self.myDate) {
            [self.modeObject setObject:self.myDate forKey:KK_VALUE];
        }
        if (self.vitDelegate && [self.vitDelegate respondsToSelector:@selector(tableViewCell:didEndPickDate:)])
        {
            [self.vitDelegate tableViewCell:self didEndPickDate:myDate];
        }
    }
    else if(buttonIndex == 1)
    {
        self.myDate = nil;
        self._displayLabel.text = @"";
        [self.modeObject removeObjectForKey:@"CK_Value"];
        [self.modeObject removeObjectForKey:KK_VALUE];
        if (self.vitDelegate && [self.vitDelegate respondsToSelector:@selector(tableViewCell:didEndPickDate:)])
        {
            [self.vitDelegate tableViewCell:self didEndPickDate:myDate];
        }
    }
    UITableView *tv= (UITableView*)self.superview;
    if([tv indexPathForCell:self])
        [tv reloadRowsAtIndexPaths:[NSArray arrayWithObject:[tv indexPathForCell:self]] withRowAnimation:UITableViewRowAnimationAutomatic];
}


@end
