//
//  MMGridViewVitCell.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define K_DEFAULT_LABEL_HEIGHT  17
#define K_DEFAULT_LABEL_FONTSIZE   12
#define K_DEFAULT_LABEL_INSET_X   5

#define K_DEFAULT_ICON_MARGIN_X   6
#define K_DEFAULT_ICON_MARGIN_Y   5
#define K_DEFAULT_ICON_SIZE   57



#import "MMGridViewVitCell.h"

@implementation MMGridViewVitCell

@synthesize textLabel = _textLabel, backgroundView = _bbackgroundView,iconImgName = _iconImgName;

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) {
        // Background view
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectNull];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backgroundView];
        
        // Label
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectNull];
        self.textLabel.textAlignment = UITextAlignmentCenter;
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textAlignment = UITextAlignmentCenter;
        self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.textLabel.font = [UIFont systemFontOfSize:K_DEFAULT_LABEL_FONTSIZE];
        self.textLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.textLabel];
    }
    return self;
}

- (void)setIconImgName:(NSString *)iconImgName
{
    _iconImgName = iconImgName;
    if (iconImgName) {
        [self setImage:[UIImage imageNamed:iconImgName] forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // Background view
    self.backgroundView.frame = self.bounds;
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.imageView.frame = CGRectMake((self.bounds.size.width - K_DEFAULT_ICON_SIZE)/2
                                      ,K_DEFAULT_ICON_MARGIN_Y
                                      ,K_DEFAULT_ICON_SIZE 
                                      ,K_DEFAULT_ICON_SIZE);
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   CGRect f =  CGRectMake(0
                        ,K_DEFAULT_ICON_MARGIN_Y + K_DEFAULT_ICON_SIZE+K_DEFAULT_LABEL_INSET_X
                        ,self.bounds.size.width
                        ,K_DEFAULT_LABEL_HEIGHT);
    self.textLabel.frame = f;
    self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}


@end
