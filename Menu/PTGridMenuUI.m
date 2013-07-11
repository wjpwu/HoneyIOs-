//
//  PTGridMenuUI.m
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-5-15.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import "PTGridMenuUI.h"
#import "PTGridViewVitCell.h"

@interface PTGridMenuUI ()

@end

@implementation PTGridMenuUI
@synthesize menuTitles,menuIcons;


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (NSInteger)numberOfCellsInGridView:(MMGridView *)gridView
{
    return [menuTitles count];
}


- (MMGridViewCell *)gridView:(MMGridView *)gridView cellAtIndex:(NSUInteger)index
{
    PTGridViewVitCell *cell = [[PTGridViewVitCell alloc] initWithFrame:CGRectNull];
    cell.textLabel.text = [menuTitles objectAtIndex:index];
    cell.iconImgName = [menuIcons objectAtIndex:index];
    return cell;
}


@end
