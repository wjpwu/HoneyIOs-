//
//  PopListCityPickerTableCell.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PopListBaseTableCell.h"
#import "SBTableAlert.h"

@interface PopListCityPickerTableCell : PopListBaseTableCell <SBTableAlertDataSource,SBTableAlertDelegate>


@property (nonatomic, retain) NSString *selectCity;
@property (nonatomic, retain) NSArray *_vPopOptionArray;

- (id)initWithWithReuseIdentifier:(NSString *)reuseIdentifier;

@end

