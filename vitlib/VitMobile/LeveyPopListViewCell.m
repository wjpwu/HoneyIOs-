//
//  LeveyPopListViewCell.m
//  LeveyPopListViewDemo
//
//  Created by Levey on 2/21/12.
//  Copyright (c) 2012 Levey. All rights reserved.
//

#import "LeveyPopListViewCell.h"

@implementation LeveyPopListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor blackColor];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect f = self.imageView.frame;
    self.imageView.frame = CGRectMake(10, f.origin.y + 5, 60, f.size.height - 10); 
//    CGRectOffset(self.imageView.frame, 6, 0);
    f = self.textLabel.frame;
    self.textLabel.frame = CGRectMake(90, f.origin.y, 160., f.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
