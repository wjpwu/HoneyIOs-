//
//  BCNavigationController.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTDelegate.h"

@interface BCNavigationController : UINavigationController
{
    NSMutableArray *history;
}
@property (nonatomic, retain) id<BCNavigationDelegate> _bcTabDelegate;


//-(UIViewController *)popViewControllerAnimated:(BOOL)animated;
//-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end
