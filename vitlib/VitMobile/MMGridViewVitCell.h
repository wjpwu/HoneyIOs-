//
//  MMGridViewVitCell.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MMGridViewCell.h"

@interface MMGridViewVitCell : MMGridViewCell
{
    UILabel *textLabel;
    UIView *backgroundView;
    UIImageView *iconImage;
}

@property (nonatomic,strong) UILabel *textLabel;
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) UIImageView *iconImage;
@end
