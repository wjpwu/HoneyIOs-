//
//  VTRadioTableCell.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-10-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTTableViewCell.h"

@interface VTRadioTableCell : VTTableViewCell
{
    BOOL radioFlag;
}

@property (nonatomic,retain)UIButton *radio;
@property (nonatomic,retain)UILabel  *radioLabel;

- (void) switchRadioWithFlag :(Boolean)radioFlag;

@end

