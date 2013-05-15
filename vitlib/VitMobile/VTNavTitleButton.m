//
//  VitNavTitleButton.m
//  TestCustomComboBox
//
//  Created by Aaron.Wu on 12-7-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTNavTitleButton.h"
#import "VTConstant.h"

@implementation ColumnBar
@synthesize delegate,linkButton;
@synthesize titleButton = _titleButton;


- (id) initPageNavi {
    CGRect mF = [[UIScreen mainScreen] applicationFrame];
    CGRect columnBarFrame = CGRectMake(mF.origin.x, mF.origin.y + 10, mF.size.width, 50);
    self = [super initWithFrame:columnBarFrame];
    return self;
}

- (id) initWithUIToolbar:(NSArray *)titleAry;
{
    self = [self initPageNavi];
    [self addSubview:[self segmentToolbar:titleAry]];
    return self;
}

- (id) initWithPreNextBar{
    self = [self initPageNavi];
    [self addSubview:self.preNexttoolBar];
    return self;
}


- (UIView *)preNexttoolBar {
    
    if (!preNexttoolBar) {
        preNexttoolBar = [[UIToolbar alloc] init];
        preNexttoolBar.barStyle = UIBarStyleBlackTranslucent;
        [preNexttoolBar setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bar_bg"]]];
        preNexttoolBar.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [preNexttoolBar sizeToFit];
        CGRect frame = preNexttoolBar.frame;
        frame.size.height = 44.0f;
        preNexttoolBar.frame = frame;
        
        UIButton *pre = [UIButton buttonWithType:UIButtonTypeCustom];
        pre.frame = CGRectMake(0, 0, 48, 33);
        pre.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [pre setBackgroundImage:[UIImage imageNamed:@"pre_month_btn_normal.png"] forState:UIControlStateNormal];
        [pre setBackgroundImage:[UIImage imageNamed:@"pre_month_btn_selected.png"] forState:UIControlStateHighlighted];
        UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
        next.frame = CGRectMake(0, 0, 48, 33);
        [next setBackgroundImage:[UIImage imageNamed:@"next_month_btn_normal.png"] forState:UIControlStateNormal];
        [next setBackgroundImage:[UIImage imageNamed:@"next_month_btn_selected.png"] forState:UIControlStateHighlighted];
        UIBarButtonItem *preb = [[UIBarButtonItem alloc] initWithCustomView:pre];
        UIBarButtonItem *nextb = [[UIBarButtonItem alloc] initWithCustomView:next];
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        NSArray *array = [NSArray arrayWithObjects:preb,flex, nextb, nil];
        [preNexttoolBar setItems:array];
    }
    return preNexttoolBar;
}

- (UIView *)segmentToolbar : (NSArray*)titles{
    
    if (!segmentToolbar) {
        segmentToolbar = [[UIToolbar alloc] init];
        segmentToolbar.barStyle = UIBarStyleBlackOpaque;
        preNexttoolBar.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [segmentToolbar sizeToFit];
        CGRect frame = segmentToolbar.frame;
        frame.size.height = 44.0f;
        segmentToolbar.frame = frame;
        
        UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:titles];
        segment.segmentedControlStyle = UISegmentedControlStyleBar;
        segment.tintColor = [UIColor darkGrayColor];
        [segment addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
        [segment sizeToFit];
        CGRect frame1 = segment.frame;
        frame1.size.width = 308.0f;
        segment.frame = frame1;
        UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithCustomView:segment];
        NSArray *array = [NSArray arrayWithObjects:bar, nil];
        [segment setSelectedSegmentIndex:0];
        [segmentToolbar setItems:array];  
        [segmentToolbar setBackgroundColor:[UIColor clearColor]];
        [segmentToolbar setAlpha:0.8];
    }
    return segmentToolbar;
}

-(void)segmentChange: (UISegmentedControl*)sender {
    debug_NSLog(@"Menu tapped for tag = %d", sender.selectedSegmentIndex);
    NSString *title = [sender titleForSegmentAtIndex:sender.selectedSegmentIndex];
    [linkButton setTitle:title forSegmentAtIndex:0];
    [linkButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    [linkButton sendActionsForControlEvents:UIControlEventValueChanged];
    [self.titleButton setTitle:title forState:UIControlStateNormal];
    //[self.titleButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    //[self.titleButton sendActionsForControlEvents:UIControlEventValueChanged];
    if(delegate && [delegate respondsToSelector:@selector(columnBar:didSelectedTabAtIndex:)]){
        [delegate columnBar:self didSelectedTabAtIndex:sender.selectedSegmentIndex];
    }
}

@end


@implementation VTNavTitleButton
@synthesize controller,navTitleArray;



- (id) initWithTarget:sender
{
    self = [super init];
    if (self)
    {
        self.controller = sender; 
    }
    return self;
}

- (id) initWithTarget:sender : (NSArray*) titles{
    self = [self initWithTarget:sender];
    self.navTitleArray = titles;
    [self setUpNavColumnBar];
    return self;
}



-(void) setUpNavColumnBar{
    CGRect mF = [[UIScreen mainScreen] applicationFrame];
    CGRect titleFrame = CGRectMake((mF.size.width - mF.origin.x)/2 - 50, mF.origin.y + 5 , 100, 37);    
    CGRect buttonFrame = CGRectMake(0, 5 , 100, 27);    
    UIView *titleView = [[UIView alloc] initWithFrame:titleFrame];
    NSString *firstTitle = [navTitleArray objectAtIndex:0];
    
    titleButton = [[UIButton alloc] initWithFrame:buttonFrame];
//    [titleButton setBorderColor:[UIColor darkGrayColor]];
//	[titleButton setNavigationButtonWithColor:[UIColor darkGrayColor]];
	[titleButton addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    //titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    //set the top nav button title font size and color
    [titleButton.titleLabel setFont:[UIFont boldSystemFontOfSize:FS_NAV_TITLE]];
    titleButton.tintColor = [UIColor colorWithRed:FC_NAV_T_R green:FC_NAV_T_G blue:FC_NAV_T_B alpha:1];
    
	[titleButton setTitle:firstTitle forState:UIControlStateNormal];
//    [titleButton setBackgroundImage:[UIImage imageNamed:@"common_titlebar_common_btn_normal.png"] forState:UIControlStateNormal];
//    [titleButton setBackgroundImage:[UIImage imageNamed:@"common_titlebar_common_btn_selected.png"] forState:UIControlStateHighlighted];
    NSArray *t = [NSArray arrayWithObjects:firstTitle, nil];
    titleSeg = [[UISegmentedControl alloc] initWithItems:t];
    titleSeg.segmentedControlStyle = UISegmentedControlStyleBar;
    titleSeg.tintColor = [UIColor darkGrayColor];
    titleSeg.frame = buttonFrame;
    titleSeg.momentary = YES;
    [titleSeg setAlpha:0.8];
    [titleSeg addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventValueChanged];
	//[titleView addSubview:titleSeg];
    
    //use the title as the header section title
    UIView *comboTitle = [[UIView alloc] initWithFrame:CGRectMake(0,0,114,35)];
        
    UIImageView *dt = [[UIImageView alloc] initWithFrame:CGRectMake(70, 15, 14, 8)];
    dt.image = [UIImage imageNamed:@"d_t"];
    //[comboTitle addSubview:titleLabel];
    
    titleSeg.backgroundColor = [UIColor clearColor];
    [comboTitle addSubview:titleButton];
    [comboTitle addSubview:dt];
    
 
    [titleView addSubview:comboTitle];
    
    
    self.controller.navigationItem.titleView = titleView;
    [self.controller.view addSubview:self.columnBar];

    
}

-(UIView *) columnBar{
    if(!columnBar){
        columnBar = [[ColumnBar alloc] initWithUIToolbar:navTitleArray];
        columnBar.linkButton = titleSeg;
        columnBar.delegate = self.controller;
        columnBar.titleButton = titleButton;
        CGRect mF = [[UIScreen mainScreen] applicationFrame];
        [columnBar setCenter:CGPointMake(mF.size.width/2, -25)];
    }
    return columnBar;
}

- (void) buttonClicked
{
    CGRect mF = [[UIScreen mainScreen] applicationFrame];

    CATransition *animation = [CATransition animation];
    animation.duration = 0.2f;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
	animation.fillMode = kCAFillModeForwards;
    if(columnBar.center.y > 0)
    {   //should use dt icon here
        debug_NSLog(@"center.y>0");
        animation.type = kCATransitionPush;
        animation.subtype = kCATransitionFromTop;
        [columnBar.layer addAnimation:animation forKey:@"animation"];
        [columnBar setCenter:CGPointMake(mF.size.width/2, -20)];
    }
    else {
        //should use ut icon here
        debug_NSLog(@"cente.y else");
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromBottom;
        [columnBar.layer addAnimation:animation forKey:@"animation"];
        [columnBar setCenter:CGPointMake(mF.size.width/2, 25)];
    }
}
@end
