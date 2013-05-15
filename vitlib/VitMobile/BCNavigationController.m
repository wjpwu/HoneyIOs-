//
//  BCNavigationController.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BCNavigationController.h"
#import "PrettyNavigationBar.h"

@interface BCNavigationController ()

@end

@implementation BCNavigationController
@synthesize _bcTabDelegate;


- (id)initWithRootViewController:(UIViewController *)rootViewController
{

    if(self = [super initWithRootViewController:rootViewController])
    {
        [self setValue:[[PrettyNavigationBar alloc] init] forKeyPath:@"navigationBar"];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}


-(void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"viewDidAppear1 self.navigationBar.center **** %f,%f",self.navigationBar.center.x,self.navigationBar.center.y);
    [super viewDidAppear:animated];
//    self.navigationBar.center = CGPointMake(100, 22);
//    NSLog(@"viewDidAppear3 self.navigationBar.center **** %f,%f",self.navigationBar.center.x,self.navigationBar.center.y);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(void)loadView
{
    [super loadView];

}
-(UIViewController *)popViewControllerAnimated:(BOOL)animated
{

    UIViewController* view =  [super popViewControllerAnimated:animated];
    if (_bcTabDelegate) {
        [_bcTabDelegate changeSelectBCTabTitle:self];
        [_bcTabDelegate shouldTabMoveDown:self];
    }
    return view;
}


-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    if (_bcTabDelegate) {
        [_bcTabDelegate changeSelectBCTabTitle:self];
         [_bcTabDelegate shouldTabMoveDown:self];
    }
}


- (NSMutableArray*) history
{
    if (!history) {
        history = [[NSMutableArray alloc] init];
    }
    return history;
}
@end
