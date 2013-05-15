//
//  PopListCityPickerTableCell.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PopListCityPickerTableCell.h"

@interface PopListCityPickerTableCell ()

@property (nonatomic, retain) NSArray *states;
@end

@implementation PopListCityPickerTableCell
@synthesize states;
@synthesize selectCity;
@synthesize _vPopOptionArray;

- (id)initWithWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initDefaultStyleWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self._vPopOptionArray = [self getCities];        
    }
    return self; 
}

static NSArray *cities = nil;
- (NSArray*) getCities
{
    if (cities == nil) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"]; 
        cities =  [NSArray arrayWithContentsOfFile:path];
    }
    return cities;
}

//#pragma mark set pop view selection
- (BOOL)becomeFirstResponder {

    SBTableAlert *alert	= [[SBTableAlert alloc] initWithTitle:self.textLabel.text cancelButtonTitle:NSLocalizedString(@"取消",@"") messageFormat:nil];
    [alert setDelegate:self];
	[alert setDataSource:self];
	alert.maximumVisibleRows = 7;
    alert.rowHeight = 44.0f;
	[alert show];
	return [super becomeFirstResponder];
}


- (NSIndexPath*) indexWithCity :(NSString*) tcity
{
    int section,row;
    if (tcity) {
        for (NSDictionary *pp in _vPopOptionArray) {
            NSArray *cities = [pp objectForKey:@"cities"];
            for (NSString *city in cities) {
                if ([city isEqualToString:tcity]) {
                    row = [cities indexOfObject:tcity];
                    section = [_vPopOptionArray indexOfObject:pp];
                    return [NSIndexPath indexPathForRow:row inSection:section];
                }
            }
        }
    }
    return nil;
}

#pragma mark tableAlert delegate
- (void)willPresentTableAlert:(SBTableAlert *)tableAlert
{
    if (!selectCity) {
        selectCity = @"厦门";
    }
    NSIndexPath *path = [self indexWithCity:selectCity];
    if (path) {
        [tableAlert.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
}

- (CGFloat)tableAlert:(SBTableAlert *)tableAlert heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableAlert:(SBTableAlert *)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *popCell;
	
    static NSString *cellIdentity = @"CityCell";
    popCell = [tableAlert.tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (popCell == nil) {
        popCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
        popCell.backgroundColor = [UIColor clearColor];
        popCell.textLabel.textColor = [UIColor blackColor];
        [popCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        popCell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.];
        popCell.accessoryType = UITableViewCellAccessoryNone;
    }    
	[popCell.textLabel setText: [[[_vPopOptionArray objectAtIndex:indexPath.section] objectForKey:@"cities"] objectAtIndex:indexPath.row]];
    
    if ([popCell.textLabel.text isEqualToString:selectCity])
        [popCell setAccessoryType:UITableViewCellAccessoryCheckmark];
    else
        [popCell setAccessoryType:UITableViewCellAccessoryNone];
    
	return popCell;
}

- (NSInteger)tableAlert:(SBTableAlert *)tableAlert numberOfRowsInSection:(NSInteger)section {
    
    NSArray *cities = [[_vPopOptionArray objectAtIndex:section] objectForKey:@"cities"];
    return cities.count;
}

- (NSInteger)numberOfSectionsInTableAlert:(SBTableAlert *)tableAlert {
    return _vPopOptionArray.count;
}

- (NSString *)tableAlert:(SBTableAlert *)tableAlert titleForHeaderInSection:(NSInteger)section {
    return [[_vPopOptionArray objectAtIndex:section] objectForKey:@"state"];
}

- (void)tableAlert:(SBTableAlert *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [tableAlert.tableView cellForRowAtIndexPath:indexPath];
    
    if (![cell.textLabel.text isEqualToString:selectCity]) {
        NSString *oldCt = selectCity;
        selectCity = cell.textLabel.text;
        [tableAlert.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[self indexWithCity:oldCt]] withRowAnimation:UITableViewScrollPositionNone];
    }            
    [self sendSelectInfo];    
//    [tableAlert.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark
- (void) sendSelectInfo
{
    self._displayLabel.text = selectCity;
    if (selectCity) {
        [self.modeObject setObject:selectCity forKey:KK_VALUE];
    }
    [self.modeObject setObject:self._displayLabel.text forKey:@"CK_Value"];
    if (self.vitDelegate && [self.vitDelegate respondsToSelector:@selector(tableViewCell:didEndEditingWithPickedValue:)]) 
    {
        [self.vitDelegate tableViewCell:self didEndEditingWithPickedValue:selectCity];
    }
}
@end
