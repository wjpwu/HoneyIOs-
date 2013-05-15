//
//  PopCKCalendarPickTableCell.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PopListBaseTableCell.h"
#import "CKCalendarAlert.h"
#import "CNTAlert.h"

@interface PopCKCalendarPickTableCell : PopListBaseTableCell <CNTAlertDelegate>

@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSDate *myDate;

- (id)initWithWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
