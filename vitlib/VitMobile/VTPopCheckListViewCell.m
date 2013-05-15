//
//  VitPopCheckListViewCell.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTPopCheckListViewCell.h"

@implementation VTPopCheckListViewCell
@synthesize modelObject,check;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor blackColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.];
        check = [[UIView alloc] initWithFrame:CGRectMake(210, 12, 20, 20)];
        [check addSubview:self.checkOff];
        [self addSubview:check];
    }
    return self;
}

- (UIImageView*) checkOn
{
    if (!checkOn) {
        checkOn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkbox_select.png"]];
    }
    return checkOn;
}

- (UIImageView*) checkOff
{
    if (!checkOff) {
        checkOff = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checkbox_unselect.png"]];
    }
    return checkOff;
}

- (void) switchCheck :(Boolean)flag;
{
    for (UIView *v in check.subviews) {
        [v removeFromSuperview];
    }
    if (flag) {
        [check addSubview:self.checkOn];
    }
    else {
        [check addSubview:self.checkOff];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame = CGRectOffset(self.textLabel.frame, 6, 0);
    checkOn.bounds = CGRectMake(0, 0, 15, 15);
    checkOff.bounds = CGRectMake(0, 0, 15, 15);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
