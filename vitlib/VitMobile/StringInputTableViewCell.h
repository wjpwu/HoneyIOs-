//
//  StringInputTableViewCell.h
//  ShootStudio
//
//  Created by Tom Fewster on 19/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTTableViewCell.h"
#import "VTPopPickTextField.h"


#define KK_INPUTTYPE    @"KK_INPUTTYPE"
#define KK_INPUTMAXLONG    @"CK_MaxLength"

@interface StringInputTableViewCell :  VTTableViewCell<UITextFieldDelegate> {
	UITextField *textField;
    VTUILabel *_displayLabel;
    int inputType;
}

@property (nonatomic, strong) NSString *stringValue;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, assign) NSString *maxLength;


@end
