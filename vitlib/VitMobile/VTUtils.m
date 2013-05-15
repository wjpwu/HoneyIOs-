//
//  MBUtils.m
//  MBDemoIOS4
//
//  Created by Bill Yang on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "VTUtils.h"
#import "VTCustomCellBackgroundView.h"
#import "VTConstant.h"
#import "UINavigationControllerAdditions.h"

@implementation VTUtils

+ (void)setCellBgColor : (UITableView*) tableView : (NSIndexPath *) indexPath: (UITableViewCell *) cell
{
    //open the switch for cell selection style.
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];

    //setting the cell selection bg color
    VTCustomCellBackgroundView *cellBGView = [[VTCustomCellBackgroundView alloc] initWithFrame:CGRectZero];
    
    //handling for each sections
    int nos = [tableView numberOfSections];
    for (int i = 0; i < nos; i ++)
    {
        
        //assume it's the middle first, will be override in later steps.
        cellBGView.position = CustomCellBackgroundViewPositionMiddle;

        //check if it's the first row
        if (indexPath.row == 0) {
            cellBGView.position = CustomCellBackgroundViewPositionTop;
        }
        
        //check if it's the last row
        if (indexPath.row == [tableView numberOfRowsInSection:i] - 1) 
        {
            cellBGView.position = CustomCellBackgroundViewPositionBottom;
        }
        
        //check if it's single row
        if (indexPath.row == 0 && (indexPath.row == [tableView numberOfRowsInSection:i] - 1))
        {
            cellBGView.position = CustomCellBackgroundViewPositionSingle;
        }
        
    }
    //set the selected cell bg color
    cellBGView.fillColor = [UIColor colorWithRed:BG_RED_SELECTED/255.0 green:BG_GREEN_SELECTED/255.0 blue:BG_BLUE_SELECTED/255.0 alpha:0.8];
    //set the selected cell bg border line
    cellBGView.borderColor = [UIColor colorWithRed:BG_RED_SELECTED/255.0 green:BG_GREEN_SELECTED/255.0 blue:BG_BLUE_SELECTED/255.0 alpha:1];
    cell.selectedBackgroundView = cellBGView;
}

+ (void)customTransitionNavigationPush: (UINavigationController*) navigationController:(UIViewController*) viewController
{
    [navigationController pushViewController:viewController withCustomTransition:CustomViewAnimationTransitionCurlUp subtype:CustomViewAnimationSubtypeFromBottom];
}

+ (UITextField *) createTextFieldWithTag: (NSInteger) tag delegate :(id) sender placeHolder :(NSString *) 
placeHolder secureEntry: (BOOL)secureEntry enable: (BOOL) enable
{
    UITextField *tempTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 7, 185, 30)];
    tempTextField.adjustsFontSizeToFitWidth = YES;
    tempTextField.tag = tag;
    tempTextField.placeholder = placeHolder;
    tempTextField.secureTextEntry = secureEntry;
    tempTextField.enabled = enable;
    tempTextField.delegate = sender;
    tempTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;   
    
    //set the text color
    tempTextField.textColor = [UIColor colorWithRed:FC_VALUE_R green:FC_VALUE_G blue:FC_VALUE_B alpha:1];
    
    //set the text font size
    tempTextField.font = [UIFont systemFontOfSize:FS_BODY_CONTENT];

    
    //set the placeholder color
    [tempTextField setValue:[UIColor colorWithRed:FC_VALUE_R green:FC_VALUE_G blue:FC_VALUE_B alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    //set the placeholder font size
    [tempTextField setValue:[UIFont systemFontOfSize:FS_BODY_CONTENT] forKeyPath:@"_placeholderLabel.font"];    

    return tempTextField;
}

+(BOOL)validateTextField: (UITextField *) textField fieldName: (NSString *) fieldName isDigits: (BOOL) isDigits lengthOfString : (NSInteger) lengthOfString title : (NSString *) title message : (NSString *) message delegate:(id) sender
{
    if (!title)
    {
        title = @"错误信息";
    }
    
    NSString *tempMsg;
    
    //first validate if the string is empty
    if([textField.text length] == 0)
    {
        if (!message)
        {
            tempMsg = @"，不能为空";
        }
        
        // open a alert with an OK button
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:[NSMutableString stringWithFormat:@"%@%@",fieldName,tempMsg] delegate:sender cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        return NO;
    }else //do further validation
    {
        if (isDigits)
        {

            if(!message)
            {
                tempMsg = @"，必须为合法手机号 － #含非数字字符";
            }
            NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
            
            NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:textField.text];
            debug_NSLog(@"alphaNums = %@", alphaNums);
            debug_NSLog(@"inStringSet = %@", inStringSet);

            if (![alphaNums isSupersetOfSet:inStringSet])
            {
                // open a alert with an OK button
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:[NSMutableString stringWithFormat:@"%@%@",fieldName,tempMsg] delegate:sender cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show]; 
                return NO;
            }
        }
        if(lengthOfString > 0)
        {
            if(!message)
            {
                tempMsg = @"，必须为合法手机号 － #长度不为11位";
            }
            
            if(lengthOfString != [textField.text length])
            {
                // open a alert with an OK button
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:[NSMutableString stringWithFormat:@"%@%@",fieldName,tempMsg] delegate:sender cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alert show]; 
                return NO;
                
                
            }
        }
        
    }
    
    return YES;
    
}


+ (NSString*)amountInputTextFieldDidEndEditing:(UITextField *)theTextField {
    NSString *str = theTextField.text;
    str = [NSString stringWithFormat:@"%.0f",[str doubleValue]];
    theTextField.text = str;
    return str;
}

// (maxlength,2)
+ (BOOL)amountInputTextField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string maxLength:(NSInteger) maxLength
{
    if (maxLength > 0) {
        // if is decimal, (8,2)
        NSString *input = textField.text;
        int length = [textField.text length];
        NSRange iStart = [input rangeOfString:@"."];
        if (iStart.length > 0) {
            if ([string isEqualToString:@"."]) {
                return NO;
            }
            
            NSString *subStr1 = [input substringToIndex:iStart.location];
            NSString *subStr2 = [input substringFromIndex:iStart.location + 1];
            debug_NSLog(@"input is  %@ - %@",subStr1,subStr2);
            if (subStr1.length >= maxLength && range.location < length - 2&& ![string isEqualToString:@""]) {
                subStr1 = [subStr1 substringToIndex:maxLength];
                textField.text = [NSString stringWithFormat:@"%@.%@", subStr1 , subStr2];
                return NO;
            }
            else if (subStr2.length >= 2 && range.location > length - 2&& ![string isEqualToString:@""]) {
                subStr2 = [subStr2 substringToIndex:2];
                textField.text = [NSString stringWithFormat:@"%@.%@", subStr1 , subStr2];
                return NO;
            }
        }
        else if (length >= maxLength && ![string isEqualToString:@""] && ![string isEqualToString:@"."]) {
            textField.text = [textField.text substringToIndex:maxLength];
            return NO;
        }
    }
    return YES;
}


@end
