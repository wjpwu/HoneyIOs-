//
//  VTPopCityListView.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTPopCityListView.h"

@interface LeveyPopListView (PrivateMethods)
- (void)initUI;
@end

static VTPopCityListView *instance = nil;
@implementation VTPopCityListView
@synthesize title,cities, keys;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithTitle:@"123" options:nil];
    if (self) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict"   
                                                       ofType:@"plist"]; 
        self.cities = [[NSDictionary alloc]   
                       initWithContentsOfFile:path];
        
        self.keys = [[cities allKeys] sortedArrayUsingSelector:  
                     @selector(compare:)]; 
        [self initUI];
    }
    return self;
}

- (void) initUI
{
    float start_y = [self popListFrame].origin.y;
    CGRect labelFrame = CGRectMake(POPLISTVIEW_SCREENINSET+10,
                                   start_y+10 ,
                                   POPLISTVIEW_TITLE_WIDTH,
                                   30);
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    float maxHeight =  rect.size.height - 2 * POPLISTVIEW_SCREENINSET - POPLISTVIEW_HEADER_HEIGHT - POPLISTRADIUS; 
    CGRect tvFrame = CGRectMake(POPLISTVIEW_SCREENINSET, 
                                start_y + POPLISTVIEW_HEADER_HEIGHT, 
                                POPLISTVIEW_WIDTH,
                                maxHeight);
    
    _titleLabel.frame = labelFrame;
    _tableView.frame = tvFrame;
    _selection = 0;    
}


- (CGRect) popListFrame
{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    
    float popHeight = [self tvHeight] + POPLISTVIEW_HEADER_HEIGHT + POPLISTRADIUS *2;
    float popWidth = POPLISTVIEW_WIDTH;
    float start_x = (rect.size.width - popWidth) /2;
    float start_y = (rect.size.height - popHeight)/2;
    return CGRectMake(start_x, start_y, popWidth, popHeight);    
}

- (float) tvHeight
{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    return rect.size.height - 2 * POPLISTVIEW_SCREENINSET - POPLISTVIEW_HEADER_HEIGHT - POPLISTRADIUS; 
}


+ (VTPopCityListView*) getInstance
{
    @synchronized(self) 
    {
        if (instance==nil) {
            CGRect rect = [[UIScreen mainScreen] applicationFrame];
            instance=[[VTPopCityListView alloc] initWithFrame:rect];
            
        }
    }
    return instance;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *key = [keys objectAtIndex:section];  
    NSArray *citySection = [cities objectForKey:key];
    return [citySection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PopCityListCell";
    
    NSString *key = [keys objectAtIndex:indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    cell.textLabel.text = [[cities objectForKey:key] objectAtIndex:indexPath.row];
//    if (indexPath.section == curSection && indexPath.row == curRow)
//        cell.accessoryType = UITableViewCellAccessoryCheckmark;
//    else
//        cell.accessoryType = UITableViewCellAccessoryNone;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{  
    NSString *key = [keys objectAtIndex:section];  
    return key;  
}  

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView  
{  
    return keys;  
} 


@end
