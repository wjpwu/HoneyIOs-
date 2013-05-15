//
//  MBUtils.h
//  MBDemoIOS4
//
//  Created by Bill Yang on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VTUtils : NSObject
/*
 Helper method for setting the common table view cell selection bg color.
 */
+ (void)setCellBgColor : (UITableView*) tableView : (NSIndexPath *) indexPath: (UITableViewCell *) cell;

/*
 * Helper method for doing the page up transition style
 */
+ (void)customTransitionNavigationPush: (UINavigationController*) navigationController:(UIViewController*) viewController;
/*
 * Helper method for create a text field input for fill the cell
 */
+ (UITextField *) createTextFieldWithTag: (NSInteger) tag delegate :(id) sender placeHolder :(NSString *) 
placeHolder secureEntry: (BOOL)secureEntry enable: (BOOL) enable ;

/*
 * Validating the given field, and show the given message if meets the condition
 */
+(BOOL)validateTextField: (UITextField *) textField fieldName: (NSString *) fieldName isDigits: (BOOL) isDigits lengthOfString : (NSInteger) lengthOfString title : (NSString *) title message : (NSString *) message delegate:(id) sender;

+ (NSString*)amountInputTextFieldDidEndEditing:(UITextField *)theTextField;

+ (BOOL)amountInputTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string maxLength:(NSInteger) maxLength;

@end


