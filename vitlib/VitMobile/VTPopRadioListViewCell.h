//
//  VitPopRadioListViewCell.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTPopRadioListViewCell : UITableViewCell
{
    UIImageView *radioOff;
    UIImageView *radioOn;
}

@property (nonatomic,retain)UIView       *radio;
@property (nonatomic,retain)NSDictionary *modelObject;


- (void) switchRadio :(Boolean)radioFlag;

@end
