//
//  PTFirstViewController.m
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-5-13.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import "PTFirstViewController.h"
#import "CXMLDocument.h"
#import "PTMenus.h"

@interface PTFirstViewController ()

@end

@implementation PTFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"First", @"First");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSError* error;
    NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"CommonMenu" ofType:@"xml"];
    NSData *fileData = [NSData dataWithContentsOfFile:xmlPath];
    CXMLDocument *xml = [[CXMLDocument alloc] initWithData:fileData options:0 error:&error];
    [[PTMenus shareMenuInstance] menuInfoWithId:@""];
    
//    NSLog(@"xml %@",xml);
//    [[[MenuItem alloc] init] parseRoot:xml];
    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
