//
//  VitPopCheckListViewCell.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTPopCheckListViewCell : UITableViewCell
{
    UIImageView *checkOff;
    UIImageView *checkOn;
}

@property (nonatomic,retain) UIView *check;
@property (nonatomic,retain) NSDictionary *modelObject;

- (void) switchCheck :(Boolean)flag;
@end
