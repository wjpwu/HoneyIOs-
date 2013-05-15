//
//  VTRadioTableCell.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-10-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTRadioTableCell.h"
#import "VTConstant.h"

@implementation VTRadioTableCell

@synthesize radio;
@synthesize radioLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        radio = [UIButton buttonWithType:UIButtonTypeCustom];
        [radio setImage:[UIImage imageNamed:@"checkbox_unselect.png"] forState:UIControlStateNormal];
        [radio setFrame:CGRectMake(260, 12, 15, 15)];
        [radio addTarget:self action:@selector(switchRadio:) forControlEvents:UIControlEventTouchUpInside];
        [radio setUserInteractionEnabled:NO];
        [self addSubview:radio];
        radioFlag = NO;
        radioLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 5, 90, 30)];
        radioLabel.textAlignment = UITextAlignmentRight;
        [self addSubview:radioLabel];        
        //set the text color
        self.radioLabel.textColor = [UIColor colorWithRed:FC_VALUE_R green:FC_VALUE_G blue:FC_VALUE_B alpha:1];
        //set the text font size
        self.radioLabel.font = [UIFont systemFontOfSize:FS_BODY_CONTENT];
    }
    return self;
}


- (void) switchRadio
{
    radioFlag = !radioFlag;
    [modeObject setValue:[NSNumber numberWithBool:radioFlag] forKey:@"CK_Value"];
    [modeObject setValue:[NSNumber numberWithBool:radioFlag] forKey:KK_VALUE];
    if (radioFlag) {
        [radio setImage:[UIImage imageNamed:@"checkbox_select.png"] forState:UIControlStateNormal];
    }
    else {
        [radio setImage:[UIImage imageNamed:@"checkbox_unselect.png"] forState:UIControlStateNormal];
    }
    if (self.vitDelegate && [self.vitDelegate respondsToSelector:@selector(tableViewCell:didEndWithBool:)]) {
        [self.vitDelegate tableViewCell:self didEndWithBool:radioFlag];
    }
}

- (void)setModeObject:(NSMutableDictionary *)thModeObject
{
    modeObject = thModeObject;
    if ([modeObject objectForKey:@"CK_Value"]) {
        [modeObject removeObjectForKey:@"CK_DefaultValue"];
        [self switchRadioWithFlag:[[modeObject objectForKey:@"CK_Value"] boolValue]];
    }
}

- (void) switchRadioWithFlag :(Boolean)tRadioFlag
{
    radioFlag = tRadioFlag;
    if (radioFlag) {
        [radio setImage:[UIImage imageNamed:@"checkbox_select.png"] forState:UIControlStateNormal];
    }
    else {
        [radio setImage:[UIImage imageNamed:@"checkbox_unselect.png"] forState:UIControlStateNormal];
    }
    [modeObject setObject:[NSNumber numberWithBool:radioFlag] forKey:KK_VALUE];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.textLabel.frame = CGRectOffset(self.textLabel.frame, 6, 0);
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	if (selected) {
		[self switchRadio];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	if (selected) {
		[self switchRadio];
	}
}


@end
