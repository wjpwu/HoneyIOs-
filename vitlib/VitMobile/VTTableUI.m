//
//  VitTableUI.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTTableUI.h"

@interface VTTableUI ()

@end

@implementation VTTableUI


- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self != nil) {
        defaultNotifCenter = [NSNotificationCenter defaultCenter];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateTheme:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTheme:)
                                                 name:@"kThemeDidChangeNotification"
                                               object:nil];
    debug_NSLog(@"invoke class name : %@",self.class);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)updateTheme:(NSNotification*)notif
{  
   [[ThemeManager sharedThemeManager] setThemeBackgroundForController:self];
}
@end
