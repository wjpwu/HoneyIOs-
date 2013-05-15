


#import "BCTabBar.h"
#import "VTUI.h"
@class BCTabBarView;


@interface BCTabBarController : VTUI <BCTabBarDelegate>
{
    Boolean backTab;
    BCTabType backTabstyle;
}

@property (nonatomic, retain) NSArray *viewControllers;
@property (nonatomic, retain) BCTabBar *tabBar;
@property (nonatomic, retain) UIViewController *selectedViewController;
@property (nonatomic, retain) BCTabBarView *tabBarView;
@property (nonatomic) NSUInteger selectedIndex;
@property (nonatomic, readonly) BOOL visible;


-(id)initWithBackTab: (Boolean) anFlag;

@end
