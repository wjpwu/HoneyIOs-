//
//  DateInputTableViewCell.m
//  ShootStudio
//
//  Created by Tom Fewster on 18/10/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DateInputTableViewCell.h"

@implementation DateInputTableViewCell

@synthesize dateValue;
@synthesize dateFormatter;
@synthesize datePicker;

- (void)initalizeInputView {
	dateValue = [NSDate date];
	
// Initialization code
	self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
	[datePicker setDatePickerMode:UIDatePickerModeDate];
	datePicker.date = self.dateValue;
	[datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		UIViewController *popoverContent = [[UIViewController alloc] init];
		popoverContent.view = self.datePicker;
		popoverController = [[UIPopoverController alloc] initWithContentViewController:popoverContent];
		popoverController.delegate = self;
	} else {
		CGRect frame = self.inputView.frame;
		frame.size = [self.datePicker sizeThatFits:CGSizeZero];
		self.inputView.frame = frame;
		self.datePicker.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	}
	
	self.dateFormatter = [[NSDateFormatter alloc] init];
	self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
	self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
	
	self.detailTextLabel.text = [self.dateFormatter stringFromDate:self.dateValue];
    self.accessoryType = UITableViewCellAccessoryNone;

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


- (UIView *)inputView {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return nil;
	} else {
		return self.datePicker;
	}
}

//- (UIView *)nextPreviousControl{
//    if(!nextPreviousControl)
//    {
//        UISegmentedControl *control = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:
//                                                                                 NSLocalizedString(@"Previous",@"Previous form field"),
//                                                                                 NSLocalizedString(@"Next",@"Next form field"),
//                                                                                 nil]];
//        control.segmentedControlStyle = UISegmentedControlStyleBar;
//        control.tintColor = [UIColor darkGrayColor];
//        control.momentary = YES;
//        [control addTarget:self action:@selector(nextPrevious:) forControlEvents:UIControlEventValueChanged];			    
//        return control;
//    }
//    return nextPreviousControl;
//}
//
//- (UIView *)inputAccessoryView {
//	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//		return nil;
//	} else {
//		if (!inputAccessoryView) {
//			inputAccessoryView = [[UIToolbar alloc] init];
//			inputAccessoryView.barStyle = UIBarStyleBlackTranslucent;
//			inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//			[inputAccessoryView sizeToFit];
//			CGRect frame = inputAccessoryView.frame;
//			frame.size.height = 44.0f;
//			inputAccessoryView.frame = frame;
//			
//			UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
//            UIBarButtonItem *controlItem = [[UIBarButtonItem alloc] initWithCustomView:self.nextPreviousControl];
//            UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//			NSArray *array = [NSArray arrayWithObjects:controlItem,flex, doneBtn, nil];
//			[inputAccessoryView setItems:array];
//		}
//		return inputAccessoryView;
//	}
//}
//
//- (void)nextPrevious:(id)sender{
//    switch([(UISegmentedControl *)sender selectedSegmentIndex]) {
//		case 0:
//        {
//            UITableView *tableView = (UITableView *)self.superview;
//            [tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
//            [self resignFirstResponder];
//            NSIndexPath *currentPath = [tableView indexPathForCell:self];
//            NSIndexPath *pre = [NSIndexPath indexPathForRow:[currentPath row] -1 inSection:[currentPath section]];
//            [tableView selectRowAtIndexPath:pre animated:YES scrollPosition:UITableViewScrollPositionNone];
//            UITableViewCell *preCell = [tableView cellForRowAtIndexPath:pre];
//            if ([preCell conformsToProtocol:@protocol(UIPopoverControllerDelegate)]) {
//                [preCell becomeFirstResponder];
//            }
//            break;
//        }
//
//
//		case 1:
//        {
//            UITableView *tableView = (UITableView *)self.superview;
//            [tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
//            [self resignFirstResponder];
//            NSIndexPath *currentPath = [tableView indexPathForCell:self];
//            NSIndexPath *pre = [NSIndexPath indexPathForRow:[currentPath row] inSection:[currentPath section] +1];
//            [tableView selectRowAtIndexPath:pre animated:YES scrollPosition:UITableViewScrollPositionNone];
//            UITableViewCell *preCell = [tableView cellForRowAtIndexPath:pre];
//            if ([preCell conformsToProtocol:@protocol(UIPopoverControllerDelegate)]) {
//                [preCell becomeFirstResponder];
//            }
//            break;
//        }
//	}	
//}
//
//- (void)done:(id)sender {
//	[self resignFirstResponder];
//}

- (BOOL)becomeFirstResponder {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		CGSize pickerSize = [self.datePicker sizeThatFits:CGSizeZero];
		CGRect frame = self.datePicker.frame;
		frame.size = pickerSize;
		self.datePicker.frame = frame;
		popoverController.popoverContentSize = pickerSize;
		[popoverController presentPopoverFromRect:self.detailTextLabel.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceDidRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
	} else {
		// nothing to do
	}
	return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
	} else {
		// Nothing to do
	}
	UITableView *tableView = (UITableView *)self.superview;
	[tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
	return [super resignFirstResponder];
}

- (void)prepareForReuse {
	self.dateFormatter.timeStyle = NSDateFormatterNoStyle;
	self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
	self.datePicker.datePickerMode = UIDatePickerModeDate;
	self.datePicker.maximumDate = nil;
	self.datePicker.minimumDate = nil;
}

- (void)setDateValue:(NSDate *)value {
	dateValue = value;
	self.detailTextLabel.text = [self.dateFormatter stringFromDate:self.dateValue];
}

- (void)setDatePickerMode:(UIDatePickerMode)mode {
	self.datePicker.datePickerMode = mode;
	self.dateFormatter.dateStyle = (mode==UIDatePickerModeDate||mode==UIDatePickerModeDateAndTime)?NSDateFormatterMediumStyle:NSDateFormatterNoStyle;
	self.dateFormatter.timeStyle = (mode==UIDatePickerModeTime||mode==UIDatePickerModeDateAndTime)?NSDateFormatterShortStyle:NSDateFormatterNoStyle;
	self.detailTextLabel.text = [self.dateFormatter stringFromDate:self.dateValue];
}

- (UIDatePickerMode)datePickerMode {
	return self.datePicker.datePickerMode;
}

- (void)setMaxDate:(NSDate *)max {
	self.datePicker.maximumDate = max;
}

- (void)setMinDate:(NSDate *)min {
	self.datePicker.minimumDate = min;
}

- (void)setMinuteInterval:(NSUInteger)value {
#pragma warning "Check with Apple why this causes a crash"
	//	[self.datePicker setMinuteInterval:value];
}

- (void)dateChanged:(id)sender {
	self.dateValue = ((UIDatePicker *)sender).date;
    debug_NSLog(@"date cell.tag %d", self.tag);

	if (self.vitDelegate && self.dateValue && [self.vitDelegate respondsToSelector:@selector(tableViewCell:didEndEditingWithDate:)]) {
		[self.vitDelegate tableViewCell:self didEndEditingWithDate:self.dateValue];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

	if (selected) {
		[self becomeFirstResponder];
	}
}

- (void)deviceDidRotate:(NSNotification*)notification {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		// we should only get this call if the popover is visible
		[popoverController presentPopoverFromRect:self.detailTextLabel.frame inView:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	}
}

#pragma mark -
#pragma mark Respond to touch and become first responder.

- (BOOL)canBecomeFirstResponder {
	return YES;
}

#pragma mark -
#pragma mark UIPopoverControllerDelegate Protocol Methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		UITableView *tableView = (UITableView *)self.superview;
		[tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
		[self resignFirstResponder];
	}
}

@end
