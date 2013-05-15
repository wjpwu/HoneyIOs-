//
//  PopListBaseTableView.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PopListBaseTableCell.h"
#import "VTConstant.h"
#import "VTPopPickTextField.h"

@implementation PopListBaseTableCell 

@synthesize _displayLabel;

- (void)initalizeInputView {
	// Initialization code
//    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(110, 7, 185, 30)];
//	self.textField.autocorrectionType = UITextAutocorrectionTypeDefault;
//	self.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
//	self.textField.textAlignment = UITextAlignmentRight;
//	//self.textField.textColor = [UIColor blueColor];
//	//self.textField.font = [UIFont systemFontOfSize:cellInputFont];
//	self.textField.clearButtonMode = UITextFieldViewModeNever;
//	self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
//    //    self.textField.borderStyle = UITextBorderStyleRoundedRect;  
//    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    self.textField.placeholder = @"请输入";
    
	self._displayLabel = [[UITextField alloc] initWithFrame:CGRectMake(110, 7, 185, 30)];
	self._displayLabel.textAlignment = UITextAlignmentRight;
	self._displayLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[self addSubview:self._displayLabel];
	self.accessoryType = UITableViewCellAccessoryNone;
    [self._displayLabel setFont:[UIFont systemFontOfSize:FS_BODY_CONTENT]];
    self._displayLabel.delegate = self;
    self._displayLabel.placeholder = @"请选择";
    [self._displayLabel setUserInteractionEnabled:NO];
    self._displayLabel.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self._displayLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self._displayLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    //set the placeholder font size
    //set the text color
    self._displayLabel.textColor = [UIColor colorWithRed:FC_VALUE_R green:FC_VALUE_G blue:FC_VALUE_B alpha:1];
    
    //set the text font size
    self._displayLabel.font = [UIFont systemFontOfSize:FS_BODY_CONTENT];
    
    
    //set the placeholder color
    [self._displayLabel setValue:[UIColor colorWithRed:FC_VALUE_R green:FC_VALUE_G blue:FC_VALUE_B alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    
    //set the placeholder font size
    [self._displayLabel setValue:[UIFont systemFontOfSize:FS_BODY_CONTENT] forKeyPath:@"_placeholderLabel.font"];     
  
    _ckdisplayLabel = [[VTUILabel alloc] initAlignRightLabelWithFrame:CGRectZero];
    [self addSubview:_ckdisplayLabel];
    _ckdisplayLabel.hidden = YES;

    _ckdisplayLabel.textColor = [UIColor colorWithRed:FC_VALUE_R green:FC_VALUE_G blue:FC_VALUE_B alpha:1];
    _ckdisplayLabel.font = [UIFont systemFontOfSize:FS_BODY_CONTENT];
}


- (id) initDefaultStyleWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initalizeInputView];
    }
    return self;
}

// to be override
- (void) setDisplay : (NSString*) hostcode
{
    
}


- (void)done:(id)sender {
	[self resignFirstResponder];
}

- (BOOL)becomeFirstResponder {
	return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
	UITableView *tableView = (UITableView *)self.superview;
	[tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
	return [super resignFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	if (selected) {
		[self becomeFirstResponder];
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
//            self._displayLabel.frame = editFrame;
        }
	} 
	
	
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self._displayLabel.text.length == 0) {
        _ckdisplayLabel.hidden = YES;
        self._displayLabel.hidden = NO;
    }
    else{
        _ckdisplayLabel.hidden = NO;
        self._displayLabel.hidden = YES;
        _ckdisplayLabel.text = self._displayLabel.text;
        _ckdisplayLabel.frame = CGRectMake(110, 7, 165, self.bounds.size.height - 14);
    }
}


@end
