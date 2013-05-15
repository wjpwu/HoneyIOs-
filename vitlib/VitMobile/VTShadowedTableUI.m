//
//  VitShadowedTableUI.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTShadowedTableUI.h"

@interface VTShadowedTableUI ()

@end

@implementation VTShadowedTableUI

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    self.tableView = [[ShadowedTableView alloc] init];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    return self;
}

- (id)initPlain
{
    self = [super initWithStyle:UITableViewStylePlain];
    self.tableView = [[ShadowedTableView alloc] init];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor lightTextColor]];
    [self.tableView setAlpha:0.85];
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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

@end
