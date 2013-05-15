//
//  MMGridViewVitCell.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define K_DEFAULT_LABEL_HEIGHT  17
#define K_DEFAULT_LABEL_FONTSIZE   14
#define K_DEFAULT_LABEL_INSET_X   5

#define K_DEFAULT_ICON_MARGIN_X   6
#define K_DEFAULT_ICON_MARGIN_Y   5
#define K_DEFAULT_ICON_SIZE   57



#import "MMGridViewVitCell.h"

@implementation MMGridViewVitCell

@synthesize textLabel,backgroundView,iconImage;

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) {
        // Background view
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectNull];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backgroundView];
        
        // ICON View
        self.iconImage = [[UIImageView alloc] initWithFrame:CGRectNull];
        [self addSubview:self.iconImage];
        // Label
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectNull];
        self.textLabel.textAlignment = UITextAlignmentCenter;
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textAlignment = UITextAlignmentCenter;
        self.textLabel.lineBreakMode = UILineBreakModeMiddleTruncation;
        self.textLabel.font = [UIFont systemFontOfSize:K_DEFAULT_LABEL_FONTSIZE];
        [self addSubview:self.textLabel];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    // Background view
    self.backgroundView.frame = self.bounds;
    self.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.iconImage.frame = CGRectMake((self.bounds.size.width - K_DEFAULT_ICON_SIZE)/2
                                      ,K_DEFAULT_ICON_MARGIN_Y
                                      ,K_DEFAULT_ICON_SIZE 
                                      ,K_DEFAULT_ICON_SIZE);
    self.iconImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
   CGRect f =  CGRectMake(0
                        ,K_DEFAULT_ICON_MARGIN_Y + K_DEFAULT_ICON_SIZE+K_DEFAULT_LABEL_INSET_X
                        ,self.bounds.size.width
                        ,K_DEFAULT_LABEL_HEIGHT);
    self.textLabel.frame = f;

    self.textLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}


#pragma - Touch event handling

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundView.backgroundColor = [UIColor orangeColor];
    [super touchesBegan:touches withEvent:event];
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundView.backgroundColor = [UIColor clearColor];
    [super touchesEnded:touches withEvent:event];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundView.backgroundColor = [UIColor clearColor];
    [super touchesCancelled:touches withEvent:event];
}

@end
