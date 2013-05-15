//
//  VitComplexMenuView.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTComplexMenuView.h"

@interface VTComplexMenuView ()

@property MenuLayoutStyle style;
- (void)setupMenu;
- (void)switchMenu;
@end

@implementation VTComplexMenuView
@synthesize menuIcons,menuTitles,style;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initMenuWithStyle:(MenuLayoutStyle)layoutStyle
{
    self = [super init];
    if (self) {
        self.style = layoutStyle;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *reloadButton = [[UIBarButtonItem alloc] initWithTitle:@"change" style:UIBarButtonItemStylePlain target:self action:@selector(switchMenu)];
    self.navigationItem.rightBarButtonItem = reloadButton;
    [self setupMenu];
	// Do any additional setup after loading the view.
    debug_NSLog(@"invoke class name : %@",self.class);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - init view
- (void)setupMenu
{
    switch (self.style) {
        case GridViewLayoutStyle:
        {
            self.view = self.gridMenu.view;
            break;
        }
        case TableViewLayoutStyle:
        {
            self.view = self.tableMenu.view;
            break;   
        }
        default:
            break;
    }
}

-(void)switchMenu
{
    switch (self.style) {
        case GridViewLayoutStyle:
        {
            self.style = TableViewLayoutStyle;
            self.view = self.tableMenu.view;
            break;
        }
        case TableViewLayoutStyle:
        {
            self.style = GridViewLayoutStyle;
            self.view = self.gridMenu.view;
            break;   
        }
        default:
            break;
    }
}

#pragma mark - private controller
- (UIViewController*) gridMenu
{
    if (!gridMenu) {
        gridMenu = [[VTGridMenu alloc] init];
        gridMenu.menuIcons = self.menuIcons;
        gridMenu.menuTitles = self.menuTitles;
        gridMenu.menuDelegate = self;
    }
    return gridMenu;
}

- (UIViewController*) tableMenu
{
    if (!tableMenu) {
        tableMenu = [[VTTableViewMenu alloc] init];
        tableMenu.menuIcons = self.menuIcons;
        tableMenu.menuTitles = self.menuTitles;
        tableMenu.menuDelegate = self;
    }
    return tableMenu;
}

#pragma mark - VitSelectMenuDelegate
-(void)didSelectMenuAtIndex:(NSUInteger)index
{
    debug_NSLog(@"menu tap : %d",index);
}
@end
