
#import <UIKit/UIKit.h>
#import "BCTab.h"
#import "VTDelegate.h"

@class BCTab;

@protocol BCTabBarDelegate;

@interface BCTabBar : UIView <BCNavigationDelegate>

- (id)initWithFrame:(CGRect)aFrame;
- (id)initWithFrame:(CGRect)aFrame WithBackTab : (Boolean) backTab : (BCTabType) type;
- (void)setSelectedTab:(BCTab *)aTab animated:(BOOL)animated;
- (void)positionTabBarAnimated: (BOOL)animated moveFlag :(BOOL) moveDown;
- (void)subTabpositionTabBarAnimated: (BOOL)animated;


@property (nonatomic, retain) NSArray *tabs;
@property (nonatomic, retain) BCTab *selectedTab;
@property (nonatomic, retain) BCTab *backTab;
@property (nonatomic, assign) id <BCTabBarDelegate> delegate;
@property (nonatomic, retain) UIImageView *arrow;
@end

@protocol BCTabBarDelegate
- (void)tabBar:(BCTabBar *)aTabBar didSelectTabAtIndex:(NSInteger)index;
@optional
// back/exit button
- (Boolean) tab :(BCTab*) aTab tabBar:(BCTabBar *)aTabBar didTabBackForIndex:(NSInteger)index;


@end