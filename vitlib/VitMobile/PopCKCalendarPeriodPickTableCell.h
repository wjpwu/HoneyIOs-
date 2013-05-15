//
//  PopCKCalendarPeriodPickTableCell.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PopListBaseTableCell.h"
#import "CKCalendarAlert.h"

#define KK_PeriodD1     @"KK_PeriodD1"
#define KK_PeriodD2     @"KK_PeriodD2"

@interface PopCKCalendarPeriodPickTableCell : PopListBaseTableCell <CNTAlertDelegate>
{
    NSMutableDictionary *period;
}
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSDate *fromDate;
@property (nonatomic, retain) NSDate *toDate;

- (id)initWithWithReuseIdentifier:(NSString *)reuseIdentifier;

@end