//
//  PopTKCalendarPickerTableCell.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PopListBaseTableCell.h"
#import "TKPopCalendarView.h"

@interface PopTKCalendarPickerTableCell : PopListBaseTableCell <TKPopCalendarViewDelegate>
{
    TKPopCalendarView *popMonth;
}
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSDate *myDate;

- (id)initWithWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
