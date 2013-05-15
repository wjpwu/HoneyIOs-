//
//  VTRotateMenuUI.m
//  BCTabBarController
//
//  Created by Aaron.Wu on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTRotateMenuUI.h"
#import "VTRotateMenuView.h"

@interface VTRotateMenuUI ()

@end

@implementation VTRotateMenuUI
@synthesize rotateMenu;


-(id)init
{
    if(!(self = [super init]))
        return nil;
    return self;
}

- (void)viewDidLoad
{
    [self setupUI];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    rotateMenu = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void) setupUI
{
    self.view = self.vtMenuView;
}

- (float) getRadius
{
    return VTROTATER_ADIUS;
}

- (VTRotateMenuView*) vtMenuView
{
    if (!vtMenuView) {
        CGRect f = self.view.bounds;
        CGRect vf = CGRectMake(f.origin.x + 20, f.origin.y, f.size.width, f.size.height);
        vtMenuView = [[VTRotateMenuView alloc] initWithFrame:vf Radius:[self getRadius]];
        NSMutableArray *menus = [[NSMutableArray alloc] init];
        for (NSDictionary *menuConfig in rotateMenu) {
            NSString *title = [menuConfig objectForKey:@"text"];
            UIImage *img = [UIImage imageNamed:[menuConfig objectForKey:@"img"]];
            VTRotateMenu *mView =	[[VTRotateMenu alloc]initWithImage:img text:title];
            mView.tag = [((NSNumber*)[menuConfig objectForKey:@"tag"]) integerValue];
            [menus addObject:mView];
            if ([menuConfig objectForKey:@"enable"]) {
                mView.enable = [[menuConfig objectForKey:@"enable"] boolValue];
            }
        }
        vtMenuView.menus = menus;
        vtMenuView._rotDelegate = self;
    }
    return vtMenuView;
}

-(void)didClickMenuItem:(id)_rotateMenu
{
    
}


@end
