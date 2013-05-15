//
//  CKCalendarAlert.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-9-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CNTAlert.h"
#import "CKCalendarView.h"


@interface CKCalendarAlert : CNTAlert <CKCalendarDelegate>
{
    NSDateFormatter *formatter; 
}
@property (nonatomic,retain) NSDate *selectDate;
@property (nonatomic,retain) NSDate *fromDate;
@property (nonatomic,retain) NSDate *toDate;
@property (nonatomic) datePickType type;


- (id)initWithCalendarStyle:(datePickType) pickStyle Title:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle messageFormat:(NSString *)message, ...;
+ (id)alertWithTitle:(NSString *)title cancelButtonTitle:(NSString *)cancelTitle messageFormat:(NSString *)message, ...;

- (void)show;

@end
