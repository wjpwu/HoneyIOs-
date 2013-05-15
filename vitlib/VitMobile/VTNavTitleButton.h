//
//  VitNavTitleButton.h
//  TestCustomComboBox
//
//  Created by Aaron.Wu on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol ColumnBarDelegate;

@interface ColumnBar : UIView
{
    UIToolbar *preNexttoolBar;
    UIToolbar *segmentToolbar;
}
@property (nonatomic) UISegmentedControl *linkButton;
@property (nonatomic, unsafe_unretained) id<ColumnBarDelegate>  delegate;
@property (strong) UIButton *titleButton;

- (id) initWithUIToolbar:(NSArray *)titleAry;
- (id) initWithPreNextBar;


@end



@protocol ColumnBarDelegate <NSObject>

- (void) columnBar:(ColumnBar *)columnBar didSelectedTabAtIndex:(int)index;

@end


@interface VTNavTitleButton : NSObject
{
    NSArray *navTitleArray;
    UIViewController<ColumnBarDelegate> *controller;
    UIButton *titleButton;
    ColumnBar *columnBar;
    UISegmentedControl *titleSeg;
}

@property  NSArray *navTitleArray;
@property  UIViewController<ColumnBarDelegate> *controller;

- (id) initWithTarget:sender : (NSArray*) titles;

@end
