//
//  VitPopRadioListViewCell.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTPopRadioListViewCell.h"

@implementation VTPopRadioListViewCell
@synthesize radio,modelObject;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor blackColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.textLabel.adjustsFontSizeToFitWidth = true;
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
//        self.textLabel.preferredMaxLayoutWidth = 200;
        self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.];
        radio = [[UIView alloc] initWithFrame:CGRectMake(210, 12, 20, 20)];
        [radio addSubview:self.radioOff];
        [self addSubview:radio];
    }
    return self;
}

- (UIImageView*) radioOn
{
    if (!radioOn) {
        radioOn = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"radio-on.png"]];
    }
    return radioOn;
}

- (UIImageView*) radioOff
{
    if (!radioOff) {
        radioOff = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"radio-off.png"]];
    }
    return radioOff;
}

//TODO
- (void) switchRadio :(Boolean)radioFlag;
{
    for (UIView *v in radio.subviews) {
        [v removeFromSuperview];
    }
    if (radioFlag && self.self.textLabel.text.length < 200) {
        [radio addSubview:self.radioOn];
    }
    else {
        [radio addSubview:self.radioOff];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect f = self.bounds;
    radio.frame = CGRectMake(f.size.width - 40, f.size.height/2 - 10, 20, 20);
    self.textLabel.frame = CGRectMake(10, 10, f.size.width - 60, f.size.height - 20);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
