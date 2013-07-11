//
//  VitMenu.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTGridMenu.h"
#import "MMGridViewVitCell.h"

@interface VTGridMenu ()
{
    BOOL longPressFlag;
}
- (void)reload;
- (void)setupPageControl;
@end

@implementation VTGridMenu
@synthesize menuDelegate,menuTitles,menuIcons,menuIds;

-(id)init
{
    if(!(self = [super init]))
        return nil;
    longPressFlag = NO;
    return self;
}

-(id)initWithLongPressSupport
{
    if(!(self = [super init]))
        return nil;
    longPressFlag = YES;
    return self;
}

-(void)loadView
{
    [super loadView];
    gridView = [[MMGridView alloc] initWithFrame:self.view.bounds];
    gridView.delegate = self;
    gridView.dataSource = self;
    gridView.longPressSupport = longPressFlag;
    [self.view addSubview:gridView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupPageControl];
}

- (void)viewDidUnload
{
    gridView = nil;
    pageControl = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)reload
{
    [gridView reloadData];
}


- (void)setupPageControl
{
    pageControl.numberOfPages = gridView.numberOfPages;
    pageControl.currentPage = gridView.currentPageIndex;
}

// ----------------------------------------------------------------------------------

#pragma - MMGridViewDataSource

- (NSInteger)numberOfCellsInGridView:(MMGridView *)gridView
{
    return [menuTitles count];
}


- (MMGridViewCell *)gridView:(MMGridView *)gridView cellAtIndex:(NSUInteger)index
{
    MMGridViewVitCell *cell = [[MMGridViewVitCell alloc] initWithFrame:CGRectNull];
    cell.textLabel.text = [menuTitles objectAtIndex:index];
    cell.iconImgName = [menuIcons objectAtIndex:index];
    return cell;
}

// ----------------------------------------------------------------------------------

#pragma - MMGridViewDelegate

- (void)gridView:(MMGridView *)gridView didSelectCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index
{
    if (menuDelegate && [menuDelegate respondsToSelector:@selector(controller:didSelectMenuAtIndex:)]) {
        [menuDelegate controller:self didSelectMenuAtIndex:index];
    }
    else if(menuDelegate && [menuDelegate respondsToSelector:@selector(controller:didSelectMenuWithId:)])
    {
        if ([menuIds count] >= index) {
            [menuDelegate controller:self didSelectMenuWithId:[menuIds objectAtIndex:index]];
        }
    }
}

- (void)gridView:(MMGridView *)gridView didLongPressCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index
{
    if (menuDelegate && [menuDelegate respondsToSelector:@selector(controller:didLongPressWithMenuId:)]) {
        if ([menuIds count] >= index) {
            [menuDelegate controller:self didLongPressWithMenuId:[menuIds objectAtIndex:index]];
        }
    }
}

- (void)gridView:(MMGridView *)theGridView changedPageToIndex:(NSUInteger)index
{
    [self setupPageControl];
}

@end
