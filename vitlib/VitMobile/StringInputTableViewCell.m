//
//  StringInputTableViewCell.m
//  ShootStudio
//
//  Created by Tom Fewster on 19/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
//#define cellInputFont 14.0f

#import "StringInputTableViewCell.h"
#import "VTConstant.h"

@implementation StringInputTableViewCell

@synthesize stringValue;
@synthesize textField;
@synthesize maxLength;

- (void)initalizeInputView {
	// Initialization code
	self.textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 7, 185, 30)];
	self.textField.autocorrectionType = UITextAutocorrectionTypeDefault;
	self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
	self.textField.textAlignment = UITextAlignmentRight;
	//self.textField.textColor = [UIColor blueColor];
	//self.textField.font = [UIFont systemFontOfSize:cellInputFont];
	self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    self.textField.borderStyle = UITextBorderStyleRoundedRect;  
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.placeholder = @"请输入";
	[self addSubview:self.textField];
    _displayLabel = [[VTUILabel alloc] initAlignRightLabelWithFrame:CGRectZero];
    [self addSubview:_displayLabel];
    _displayLabel.hidden = YES;
	self.accessoryType = UITableViewCellAccessoryNone;
	
	self.textField.delegate = self;
    
    //set the text color
    self.textField.textColor = [UIColor colorWithRed:FC_VALUE_R green:FC_VALUE_G blue:FC_VALUE_B alpha:1];
    _displayLabel.textColor = [UIColor colorWithRed:FC_VALUE_R green:FC_VALUE_G blue:FC_VALUE_B alpha:1];
    //set the text font size
    self.textField.font = [UIFont systemFontOfSize:FS_BODY_CONTENT];
    _displayLabel.font = [UIFont systemFontOfSize:FS_BODY_CONTENT];

    
    //set the placeholder color
    [self.textField setValue:[UIColor colorWithRed:FC_VALUE_R green:FC_VALUE_G blue:FC_VALUE_B alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    //set the placeholder font size
    [self.textField setValue:[UIFont systemFontOfSize:FS_BODY_CONTENT] forKeyPath:@"_placeholderLabel.font"];    

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		[self initalizeInputView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
		[self initalizeInputView];
    }
    return self;
}

-(void)setCellStyle:(VitTablecellMode)cellModeTo
{
    switch (cellModeTo) {
        case VitTablecellModeView:
        {
            self.textField.placeholder = nil;
            [self.textField setUserInteractionEnabled:NO];
            [self setUserInteractionEnabled:NO];
        }
            break;
            
        default:
            break;
    }
    
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	if (selected) {
        textField.hidden = NO;
        _displayLabel.hidden = YES;
        double delayInSeconds = .1 ;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           [self.textField becomeFirstResponder];
                       });
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	if (selected) {
        textField.hidden = NO;
        _displayLabel.hidden = YES;
        double delayInSeconds = .1 ;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                       {
                           [self.textField becomeFirstResponder];
                       });
	}
}

- (void)setStringValue:(NSString *)value {
	self.textField.text = value;
}

- (NSString *)stringValue {
	return self.textField.text;
}


//if(![custInfo.rsAssets isEqualToNumber:[NSDecimalNumber notANumber]] &&[custInfo.rsAssets doubleValue] > 0) {
//    scell.textField.text = [NSString stringWithFormat:@"%.2f",[custInfo.rsAssets doubleValue]];
//}
//cell.textField.text = [NSString stringWithFormat:@"%.2f",[wRequest.rqCarOriVal doubleValue]];

// override super method
- (void)done:(id)sender {
	[self.textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self.textField resignFirstResponder];
	return YES;
}

- (BOOL)resignFirstResponder
{
    [self.textField resignFirstResponder];
    return [super resignFirstResponder];
}

- (void)setModeObject:(NSMutableDictionary *)theModeObject
{
    [super setModeObject:theModeObject];
    textField.text = [theModeObject objectForKey:@"CK_Value"];
    inputType = [[theModeObject objectForKey:KK_INPUTTYPE] integerValue];
    if ([theModeObject objectForKey:KK_INPUTTYPE]) {
        switch (inputType) {
                //Integer
            case 1:
                textField.keyboardType = UIKeyboardTypeNumberPad;
                break;
                //Decimal
            case 2:
                textField.keyboardType = UIKeyboardTypeDecimalPad;
                break;
                //Phone
            case 3:
                textField.keyboardType = UIKeyboardTypePhonePad;
                break;
            default:
                textField.keyboardType = UIKeyboardTypeDefault;
                break;
        }
    }
    self.maxLength = [theModeObject objectForKey:KK_INPUTMAXLONG];
}

- (void)textFieldDidEndEditing:(UITextField *)theTextField {
    debug_NSLog(@"string cell.tag %d", self.tag);
    NSString *str = theTextField.text;
    if (inputType == 2 && str.length > 0) {
        str = [NSString stringWithFormat:@"%.1f",[str doubleValue]];
    }
    else if([[self.modeObject valueForKey:@"CK_uppcase"] boolValue])
    {
        theTextField.text = [str uppercaseString];
    }
    else{
        theTextField.text = str;
    }
    [self.modeObject setValue:theTextField.text forKey:@"CK_Value"];
    [self.modeObject setValue:theTextField.text forKey:KK_VALUE];
    if (self.vitDelegate && [self.vitDelegate respondsToSelector:@selector(tableViewCell:didEndEditingWithString:)]) {
        [self.vitDelegate tableViewCell:self didEndEditingWithString:str];
    }
    
    UITableView *tv= (UITableView*)self.superview;
    if ([tv indexPathForCell:self]) {
            [tv reloadRowsAtIndexPaths:[NSArray arrayWithObject:[tv indexPathForCell:self]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)atextField
{
    atextField.hidden = NO;
    _displayLabel.hidden = YES;
    return YES;
}


- (BOOL)textField:(UITextField *)tTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (maxLength && [maxLength intValue] > 0) {
        // if is decimal, (8,2)
        NSString *input = tTextField.text;
        int length = [tTextField.text length] ;
        if (inputType == 2) {
            NSRange iStart = [input rangeOfString:@"."];
            if (iStart.length > 0) {
                if ([string isEqualToString:@"."]) {
                    return NO;
                }
                
                NSString *subStr1 = [input substringToIndex:iStart.location];
                NSString *subStr2 = [input substringFromIndex:iStart.location + 1];
                debug_NSLog(@"input is  %@ - %@",subStr1,subStr2);
                if (subStr1.length >= [maxLength intValue] && range.location < length - 2&& ![string isEqualToString:@""]) {
                    subStr1 = [subStr1 substringToIndex:[maxLength intValue]];
                    textField.text = [NSString stringWithFormat:@"%@.%@", subStr1 , subStr2];
                    return NO;
                }
                else if (subStr2.length >= 1 && range.location > length - 1&& ![string isEqualToString:@""]) {
                    subStr2 = [subStr2 substringToIndex:1];
                    textField.text = [NSString stringWithFormat:@"%@.%@", subStr1 , subStr2];
                    return NO;
                }
            }
            else if (length >= [maxLength intValue] && ![string isEqualToString:@""] && ![string isEqualToString:@"."]) {
                textField.text = [textField.text substringToIndex:[maxLength intValue]];
                return NO;
            }
        }
        else if (range.location >= [maxLength intValue] && ![string isEqualToString:@""]) {
            textField.text = [textField.text substringToIndex:[maxLength intValue]];
            return NO;
        }
    }
    return YES;
}



- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.textField.text.length == 0) {
        _displayLabel.hidden = YES;
        self.textField.hidden = NO;
    }
    else{
        _displayLabel.hidden = NO;
        self.textField.hidden = YES;
        _displayLabel.text = self.textField.text;
        _displayLabel.frame = CGRectMake(110, 7, 165, self.bounds.size.height - 14);
    }
}

- (void)layoutSubviews1 {
	[super layoutSubviews];
	CGRect editFrame = CGRectInset(self.contentView.frame, 10, 10);
	
	if (self.textLabel.text && [self.textLabel.text length] != 0) {
		CGSize textSize = [self.textLabel sizeThatFits:CGSizeZero];
		editFrame.origin.x += textSize.width + 10;
		editFrame.size.width -= textSize.width + 10;
        if (editFrame.origin.x > CELL_TEXTFIELD_ORIGIN_X) {
//            self.textField.frame = editFrame;
        }
//		self.textField.textAlignment = UITextAlignmentLeft;
	} else {
//		self.textField.textAlignment = UITextAlignmentLeft;
	}
	
	
}


@end
