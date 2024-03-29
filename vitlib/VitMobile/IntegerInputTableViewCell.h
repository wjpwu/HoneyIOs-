//
//  IntegerInputTableViewCell.h
//  InputTest
//
//  Created by Tom Fewster on 18/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VTTableViewCell.h"


@interface IntegerInputTableViewCell : VTTableViewCell <UIKeyInput, UITextInputTraits> {
	NSUInteger numberValue;
	BOOL valueChanged;
	NSUInteger lowerLimit;
	NSUInteger upperLimit;
	
//	UIToolbar *inputAccessoryView;
	UIEdgeInsets originalContentInsets;
	UIEdgeInsets originalScrollInsets;
    

}

@property (nonatomic, assign) NSUInteger numberValue;
@property (nonatomic, assign) NSUInteger lowerLimit;
@property (nonatomic, assign) NSUInteger upperLimit;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;

@property(nonatomic) UITextAutocapitalizationType autocapitalizationType;
@property(nonatomic) UITextAutocorrectionType autocorrectionType;
@property(nonatomic) BOOL enablesReturnKeyAutomatically;
@property(nonatomic) UIKeyboardAppearance keyboardAppearance;
@property(nonatomic) UIKeyboardType keyboardType;
@property(nonatomic) UIReturnKeyType returnKeyType;
@property(nonatomic, getter=isSecureTextEntry) BOOL secureTextEntry;
@property(nonatomic) UITextSpellCheckingType spellCheckingType;

@end
