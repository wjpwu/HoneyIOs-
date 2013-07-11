//
//  PTGridViewVitCell.m
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-6-6.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import "PTGridViewVitCell.h"
#import "PTFiles.h"
#import "PTSession.h"

@implementation PTGridViewVitCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) didGetIcon:(NSNotification*) sender
{
    UIImage *img = [UIImage imageWithData:[[sender object] valueForKey:@"data"]];
    [self setImage:img forState:UIControlStateNormal];
    [self layoutSubviews];
}

- (void)setIconImgName:(NSString *)iconImgName
{
    _iconImgName = iconImgName;
    if (iconImgName) {
        UIImage *img = nil;
        if (!img) {
            img = [UIImage imageWithData:[[PTFiles shareInstance] fileDataFromDocumentWithName:iconImgName]];
        }
        if (!img) {
            NSString *ns = [NSString stringWithFormat:@"%@%@",NNDidGetIcon,iconImgName];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didGetIcon:) name:ns object:nil];
            [[PTSession shareInstance] doGetIconWithName:iconImgName];
        } else
        [self setImage:[UIImage imageNamed:iconImgName] forState:UIControlStateNormal];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
//    if (self.isRemovable) {
//        // place a remove button on top right corner for removing item from the board
//        UIButton removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [removeButton setFrame:CGRectMake(65, 5, 20, 20)];
//        [removeButton setImage:[UIImage imageNamed:@"btn_delete.png"] forState:UIControlStateNormal];
//        removeButton.backgroundColor = [UIColor clearColor];
//        [removeButton addTarget:self action:@selector(removeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//        removeButton.tag = tag;
//        [removeButton setHidden:YES];
//        [self addSubview:removeButton];
//    }
}

@end
