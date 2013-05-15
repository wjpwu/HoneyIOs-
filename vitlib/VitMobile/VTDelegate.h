//
//  VTDelegate.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VTDelegate <NSObject>

@end



// protocal for select/click menu item
@protocol VTSelectMenuDelegate <NSObject>
-   (void) controller:(UIViewController*)viewController didSelectMenuAtIndex:(NSUInteger)index;
-   (void) controller:(UIViewController*)viewController didSelectMenuWithId:(NSString*) menuId;
@end



@class StringInputTableViewCell;
@class DateInputTableViewCell;
@class SimplePickerInputTableViewCell;
@class IntegerInputTableViewCell;
@class MultipleSelectPickerInputTableViewCell;
@class SexPickerInputTableViewCell;
@class PopListDataPickerTableCell;
@class PopListDataMultiplePickerTableCell;
@class PopTKCalendarPickerTableCell;
@class PopCKCalendarPickTableCell;

@protocol VTTableViewCellDelegate  <NSObject>
@optional
- (void)tableViewCell:(StringInputTableViewCell *)cell didEndEditingWithString:(NSString *)value;
- (void)tableViewCell:(DateInputTableViewCell *)cell didEndEditingWithDate:(NSDate *)value;
- (void)tableViewCell:(SimplePickerInputTableViewCell *)cell didEndEditingWithValue:(NSString *)value;
- (void)tableViewCell:(SexPickerInputTableViewCell *)cell didEndEditingWithSexValue:(NSString *)value;
- (void)tableViewCell:(IntegerInputTableViewCell *)cell didEndEditingWithInteger:(NSUInteger)value;
- (void)tableViewCell:(MultipleSelectPickerInputTableViewCell *)cell didEndEditingWithMSelect:(NSString *)value;
- (void)tableViewCell:(UITableViewCell *)cell didEndEditingWithPickedValue:(id)pickedValue;
- (void)tableViewCell:(PopListDataMultiplePickerTableCell *)cell didEndEditingWithMultiplePickedValues:(NSArray *)pickedValues;
- (void)tableViewCell:(UITableViewCell*)cell didEndPickDate:(NSDate *)theDate;
- (void)tableViewCell:(UITableViewCell*)cell didEndPickFromDate:(NSDate *)theFDate andToDate:(NSDate *)theTDate;
- (void)tableViewCell:(UITableViewCell*)cell didEndPickValueWithPopView:(UIViewController*) controller value:(id) value;
- (void)tableViewCell:(UITableViewCell*)cell didEndWithBool:(BOOL)theFlag;

@end

@class BCNavigationController;
@protocol BCNavigationDelegate <NSObject>

@required
-(void)changeSelectBCTabTitle : (UINavigationController*)anNav;
@optional
-(void)shouldTabMoveDown: (UINavigationController*) nav;
-(void)shouldChangeBackkTab: (UINavigationController*) nav;


@end
