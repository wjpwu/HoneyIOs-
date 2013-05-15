#import "BCTabBarController.h"
#import "BCTabBar.h"
#import "BCTab.h"
#import "BCTabBarView.h"
#import "BCNavigationController.h"

@interface BCTabBarController ()

- (void)loadTabs;

@property (nonatomic, retain) UIImageView *selectedTab;
@property (nonatomic, readwrite) BOOL visible;

@end


@implementation BCTabBarController
@synthesize viewControllers, tabBar, selectedTab, selectedViewController, tabBarView, visible;

-(id)initWithBackTab: (Boolean) anFlag
{
    self = [super init];
    if (self) {
        backTab = anFlag;
    }
    return self;
}

- (void)loadView {
	self.tabBarView = [[BCTabBarView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.view = self.tabBarView;
	self.tabBar = [[BCTabBar alloc] initWithFrame:CGRectMake(0, 0, BCTABBAR_WIDTH, self.view.bounds.size.height) WithBackTab:backTab:self.backTabstyle];
	self.tabBar.delegate = self;
	
	self.tabBarView.tabBar = self.tabBar;
	[self loadTabs];
	
	UIViewController *tmp = selectedViewController;
	selectedViewController = nil;
	[self setSelectedViewController:tmp];
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];

}

-(Boolean)tab:(BCTab *)aTab tabBar:(BCTabBar *)aTabBar didTabBackForIndex:(NSInteger)index
{
//    UIViewController *vc = [self.viewControllers objectAtIndex:index];
//	if (self.selectedViewController == vc) {
//		if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
//			[(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
//		}
//	} else {
//		self.selectedViewController = vc;
//	}
    if (self.selectedViewController) {
        if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
			[(UINavigationController *)self.selectedViewController popViewControllerAnimated:YES];
		}
    }
    return NO;
}

- (void)tabBar:(BCTabBar *)aTabBar didSelectTabAtIndex:(NSInteger)index {
	UIViewController *vc = [self.viewControllers objectAtIndex:index];
//	if (self.selectedViewController == vc) {
//		if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
//			[(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
//		}
//	} else {
//		self.selectedViewController = vc;
//	}
	self.selectedViewController = vc;
    if ([self.selectedViewController isKindOfClass:[UINavigationController class]]) {
        if (((UINavigationController*)vc).viewControllers.count == 1) {
            tabBar.backTab.bcTitleLabel.text = @"退出";
        }else {
            tabBar.backTab.bcTitleLabel.text = @"返回";
        }
    }

}

- (void)setSelectedViewController:(UIViewController *)vc {
	UIViewController *oldVC = selectedViewController;
	if (selectedViewController != vc) {
		selectedViewController = vc;
        if (!self.childViewControllers && visible) {
			[oldVC viewWillDisappear:NO];
			[selectedViewController viewWillAppear:NO];
		}
		self.tabBarView.contentView = vc.view;
        if (!self.childViewControllers && visible) {
			[oldVC viewDidDisappear:NO];
			[selectedViewController viewDidAppear:NO];
		}
		
		[self.tabBar setSelectedTab:[self.tabBar.tabs objectAtIndex:self.selectedIndex] animated:(oldVC != nil)];
        if ([vc isKindOfClass:[BCNavigationController class]]) {
            [((BCNavigationController*)vc)._bcTabDelegate shouldTabMoveDown:((BCNavigationController*)vc)];
        }
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewDidAppear:animated];
    
	visible = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
    if (!self.childViewControllers)
        [self.selectedViewController viewWillDisappear:animated];	
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    
    if (![self respondsToSelector:@selector(addChildViewController:)])
        [self.selectedViewController viewDidDisappear:animated];
	visible = NO;
}

- (NSUInteger)selectedIndex {
	return [self.viewControllers indexOfObject:self.selectedViewController];
}

- (void)setSelectedIndex:(NSUInteger)aSelectedIndex {
	if (self.viewControllers.count > aSelectedIndex)
		self.selectedViewController = [self.viewControllers objectAtIndex:aSelectedIndex];
}
//////////////mode
- (void)loadTabs {
	NSMutableArray *tabs = [NSMutableArray arrayWithCapacity:self.viewControllers.count];
	for (UIViewController *vc in self.viewControllers) {
//		[tabs addObject:[[BCTab alloc] initWithTitle:[vc title]]];
        BCTab * tab = [[BCTab alloc] initWithTitle:[vc title]];
        if ([vc isKindOfClass:[BCNavigationController class]]) {
            ((BCNavigationController*)vc)._bcTabDelegate = self.tabBar;
        }
        [tabs addObject:tab];
	}
	self.tabBar.tabs = tabs;
//	[self.tabBar setSelectedTab:[self.tabBar.tabs objectAtIndex:self.selectedIndex] animated:NO];
}

- (void)viewDidUnload {
	self.tabBar = nil;
	self.selectedTab = nil;
}

- (void)setViewControllers:(NSArray *)array {
	if (array != viewControllers) {
		viewControllers = array;
		
		if (viewControllers != nil) {
			[self loadTabs];
		}
	}
	
//	self.selectedIndex = 0;
}

// override by sub class
- (BCTabType) backTabstyle
{
    return PlainTabType;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return [self.selectedViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateFirstHalfOfRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateFirstHalfOfRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
}

- (void)willAnimateSecondHalfOfRotationFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation duration:(NSTimeInterval)duration {
	[self.selectedViewController willAnimateSecondHalfOfRotationFromInterfaceOrientation:fromInterfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.selectedViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

@end
