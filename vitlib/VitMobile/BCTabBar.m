#import "BCTabBar.h"
#import "VTUI.h"
#define kTabMargin 0.0

@interface BCTabBar ()
@property (nonatomic, retain) UIImage *backgroundImage;

- (void)positionArrowAnimated:(BOOL)animated;
@end

@implementation BCTabBar
@synthesize tabs, selectedTab, backgroundImage, arrow, delegate, backTab;

- (id)initWithFrame:(CGRect)aFrame {
	return [self initWithFrame:aFrame WithBackTab:NO : PlainTabType];
}

- (id)initWithFrame:(CGRect)aFrame WithBackTab:(Boolean)anBackTab :(BCTabType)type
{
    if (self = [super initWithFrame:aFrame]) {
        //		self.backgroundImage = [UIImage imageNamed:@"BCTabBarController.bundle/tab-bar-background.png"];
        //		self.arrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BCTabBarController.bundle/tab-arrow.png"]];
        //		CGRect r = self.arrow.frame;
        //        r.origin.x = 60;
        //		r.origin.y = -2;
        //		self.arrow.frame = r;
        //		[self addSubview:self.arrow];
		self.userInteractionEnabled = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | 
        UIViewAutoresizingFlexibleTopMargin;
        self.backgroundColor = [UIColor clearColor];
        if (anBackTab) {
            switch (type) {
                case LogoutTabType:
                    backTab = [[BCTab alloc] initWithTitle:@"退出"];
                    break;
                    
                default:
                    backTab = [[BCTab alloc] initWithTitle:@"返回"];
                    break;
            }
            [backTab addTarget:self action:@selector(tabBack:) forControlEvents:UIControlEventTouchDown];
        }
	}
	
	return self;
}


// tab back

- (void)tabBack:(BCTab *)sender 
{
    [self.delegate tab:sender tabBar:self didTabBackForIndex:[self.tabs indexOfObject:self.selectedTab]];
}


- (void)setTabs:(NSArray *)array {
    if (tabs != array) {
        for (BCTab *tab in tabs) {
            [tab removeFromSuperview];
        }

        tabs = array;        
        
        for (BCTab *tab in tabs) {
            tab.userInteractionEnabled = YES;
            [tab addTarget:self action:@selector(tabSelected:) forControlEvents:UIControlEventTouchDown];
        }
        [self setNeedsLayout];

    }
}

- (void)setSelectedTab:(BCTab *)aTab animated:(BOOL)animated {
	if (aTab != selectedTab) {
		selectedTab = aTab;
		selectedTab.selected = YES;
		for (BCTab *tab in tabs) {
			if (tab == aTab) continue;
			tab.selected = NO;
		}
	}	
	[self positionArrowAnimated:animated];	
}

- (void)setSelectedTab:(BCTab *)aTab {
	[self setSelectedTab:aTab animated:YES];
}

- (void)tabSelected:(BCTab *)sender {
	[self.delegate tabBar:self didSelectTabAtIndex:[self.tabs indexOfObject:sender]];
}

- (void)positionArrowAnimated:(BOOL)animated {
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
	}
    for (BCTab *tab in tabs) {
        [tab positionAnimated];
    }
	if (animated) {
		[UIView commitAnimations];
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect f = self.bounds;
    f.size.height /= self.tabs.count;
	f.size.height -= (kTabMargin * (self.tabs.count + 1)) / self.tabs.count;
    
    float backHeight = 80.0;
    float totalHeight = [UIScreen mainScreen].bounds.size.height - 10;
    if(backTab && !backTab.hidden)
        totalHeight -= backHeight;
    else {
        totalHeight -= 44.0f;
        f.origin.y += 3;
    }
    
	for (BCTab *tab in self.tabs) {
        [tab removeFromSuperview];
//        CGSize constraint = CGSizeMake(BCTABBAR_WIDTH, 200);
//        CGSize size = [tab.bcTitleLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:BCTABBAR_TEXTFONT] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
        CGFloat height = (totalHeight - 0)/4;
		f.origin.y += kTabMargin;
        tab.frame = CGRectMake(f.origin.x, f.origin.y, floorf(30), height);
		f.origin.y += height - 2;
		[self addSubview:tab];
	}
	
    if (backTab) {
//        CGSize constraint = CGSizeMake(200., BCTABBAR_WIDTH);
//        CGSize size = [backTab.bcTitleLabel.text sizeWithFont:[UIFont fontWithName:@"Helvetica" size:BCTABBAR_TEXTFONT] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
//        CGFloat height = MIN(size.width+20, 200.0f);
        backTab.frame = CGRectMake(floorf(f.origin.x - BCTABBAR_WIDTH / 2), f.origin.y, floorf(30), 80);
        [self addSubview:backTab];
    }
	[self positionArrowAnimated:NO];
}

- (void)setFrame:(CGRect)aFrame {
	[super setFrame:aFrame];
	[self setNeedsDisplay];
}


#pragma mark BCNavigationDelegate delegate
-(void)changeSelectBCTabTitle:(UINavigationController *)anNav
{
    if (selectedTab && anNav.topViewController.title) {
        if ([anNav.topViewController isKindOfClass:[VTUI class]]) {
            if (!((VTUI*)anNav.topViewController).hideTabBarTitle) {
                selectedTab.bcTitleLabel.text = anNav.topViewController.title;
            }
        }
    }    
    if (anNav.viewControllers.count == 1) {
        backTab.bcTitleLabel.text = @"退出";
    }else {
        backTab.bcTitleLabel.text = @"返回";
    }
    [self layoutSubviews];
}


-(void)shouldTabMoveDown: (UINavigationController*) navCol
{  
    [self positionTabBarAnimated:YES moveFlag:!navCol.navigationBar.isHidden];
    [self layoutSubviews];
}


- (void)positionTabBarAnimated: (BOOL)animated moveFlag :(BOOL) moveDown{
	
    CGRect f = self.frame;
    if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.1];
	}
    if (moveDown) {
        self.frame = CGRectMake(f.origin.x, 40., f.size.width, f.size.height);
        if (backTab) {
            [backTab setHidden:YES];
        }
    }
    else {
        self.frame = CGRectMake(f.origin.x, 0, f.size.width, f.size.height);
        if (backTab) {
            [backTab setHidden:NO];
        }
    }
	if (animated) {
		[UIView commitAnimations];
	}
}

- (void)subTabpositionTabBarAnimated: (BOOL)animated
{
    CGRect f = self.frame;
    if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.1];
	}
    if (self.frame.origin.y == 0) {
        self.frame = CGRectMake(f.origin.x, 40., f.size.width, f.size.height);
        if (backTab) {
            [backTab setHidden:YES];
        }
        [self layoutSubviews];
    }
	if (animated) {
		[UIView commitAnimations];
	}
}


@end
