//
//  VitTableViewMenu.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#define VITMENUCELLIDENTITY @"VitMenuCell"

#import "VTTableViewMenu.h"

@interface VTTableViewMenu ()

@end

@implementation VTTableViewMenu
@synthesize menuIcons,menuTitles,menuDelegate,menuIds;


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [menuTitles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:VITMENUCELLIDENTITY];
    if (cell == nil) {
        cell = [[ClearLabelsCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:VITMENUCELLIDENTITY];
        cell.backgroundView = [[GradientView alloc] init];
        cell.imageView.image = [UIImage imageNamed:[self.menuIcons objectAtIndex:indexPath.row]];
        cell.textLabel.text = [self.menuTitles objectAtIndex:indexPath.row];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [VTUtils setCellBgColor:tableView :indexPath :cell];
    }    
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:FS_CELL_MENU]];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (menuDelegate && [menuDelegate respondsToSelector:@selector(controller:didSelectMenuAtIndex:)]) {
        [menuDelegate controller:self didSelectMenuAtIndex:indexPath.row];
    }
    else if(menuDelegate && [menuDelegate respondsToSelector:@selector(controller:didSelectMenuWithId:)])
    {
        if ([menuIds count] >= indexPath.row) {
            [menuDelegate controller:self didSelectMenuWithId:[menuIds objectAtIndex:indexPath.row]];
        }
    }
}

@end
