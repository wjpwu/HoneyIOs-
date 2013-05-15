//
//  VitTableViewCell.m
//  PickerCellDemo
//
//  Created by Aaron.Wu on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTTableViewCell.h"
#import "VTUtils.h"
#import "VTConstant.h"

@interface VTTableViewCell()
@end

@implementation VTTableViewCell
@synthesize isFirstVitCell,isLastVitCell,accessoryDelegate;
@synthesize modeObject,vitDelegate,inputAccessoryView,cellMode;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        self.detailTextLabel.frame = CGRectMake(130, 1, 50, 27);
        self.detailTextLabel.font = [UIFont systemFontOfSize:14];
        //self.detailTextLabel.textColor = [UIColor blueColor];
        
        //set the value color
        self.detailTextLabel.textColor = [UIColor colorWithRed:FC_VALUE_R green:FC_VALUE_G blue:FC_VALUE_B alpha:1];

        self.detailTextLabel.textAlignment = UITextAlignmentLeft;
        self.backgroundColor = [UIColor whiteColor];
        self.textLabel.textColor = [UIColor colorWithRed:FC_LABEL_R green:FC_LABEL_G blue:FC_LABEL_B alpha:1];
        self.textLabel.font = [UIFont boldSystemFontOfSize:FS_BODY_CONTENT];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void) setCellStyle : (VitTablecellMode) cellModeTo;
{
    switch (cellModeTo) {
        case VitTablecellModeView:
        {
            [self setUserInteractionEnabled:NO];
        }
            break;
            
        default:
            break;
    }
}

- (void) setModeObject:(NSMutableDictionary *)tmodeObject
{
    modeObject = tmodeObject;
    if (modeObject) {
        if ([modeObject objectForKey:@"VK_EDITABLE"]) {
            [self setUserInteractionEnabled:[[modeObject objectForKey:@"VK_EDITABLE"] boolValue]];
            //disable
            if (![[modeObject objectForKey:@"VK_EDITABLE"] boolValue]) {
                self.textLabel.textColor = [UIColor darkGrayColor];
            }
        }
    }
    
}

-(BOOL)becomeFirstResponder{

    return [super becomeFirstResponder];
}

- (UIView *)nextPreviousControl{
    if(!nextPreviousControl)
    {
        nextPreviousControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:
                                                                                 NSLocalizedString(@"前一项",@"Previous form field"),
                                                                                 NSLocalizedString(@"后一项",@"Next form field"),
                                                                                 nil]];
        nextPreviousControl.segmentedControlStyle = UISegmentedControlStyleBar;
        nextPreviousControl.tintColor = [UIColor darkGrayColor];
        nextPreviousControl.momentary = YES;
        [nextPreviousControl addTarget:self action:@selector(nextPrevious:) forControlEvents:UIControlEventValueChanged];			    
        return nextPreviousControl;
    }
    return nextPreviousControl;
}

- (UIView *)inputAccessoryView {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return nil;
	} else {
		if (!inputAccessoryView) {
			inputAccessoryView = [[UIToolbar alloc] init];
			inputAccessoryView.barStyle = UIBarStyleBlackTranslucent;
			inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
			[inputAccessoryView sizeToFit];
			CGRect frame = inputAccessoryView.frame;
			frame.size.height = 44.0f;
			inputAccessoryView.frame = frame;
			
			UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
//            UIBarButtonItem *controlItem = [[UIBarButtonItem alloc] initWithCustomView:self.nextPreviousControl];
            UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//			NSArray *array = [NSArray arrayWithObjects:controlItem,flex, doneBtn, nil];
            NSArray *array = [NSArray arrayWithObjects:flex, doneBtn, nil];
			[inputAccessoryView setItems:array];
		}
//        if(accessoryDelegate)
//        {
//            if ([accessoryDelegate isFirstVitCell]) {
//                [nextPreviousControl setEnabled:NO forSegmentAtIndex:0];
//            }
//            if ([accessoryDelegate isLastVitCell]) {
//                [nextPreviousControl setEnabled:NO forSegmentAtIndex:1];
//            }
//        }        
		return inputAccessoryView;
	}
}

- (void)nextPrevious:(id)sender{
    switch([(UISegmentedControl *)sender selectedSegmentIndex]) {
		case 0:
        {
            UITableView *tableView = (UITableView *)self.superview;
            [tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
            [self resignFirstResponder];
            UITableViewCell *preCell = [self nextPreviousTableCell:tableView :self :0];
            if(preCell){
                NSIndexPath *indexPath = [tableView indexPathForCell:preCell];
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
//                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop  animated:YES];
                [preCell becomeFirstResponder];
            }
            break;
        }
            
            
		case 1:
        {
            UITableView *tableView = (UITableView *)self.superview;
            [tableView deselectRowAtIndexPath:[tableView indexPathForCell:self] animated:YES];
            [self resignFirstResponder];
            UITableViewCell *nextCell = [self nextPreviousTableCell:tableView :self :1];
            if(nextCell){

                
                NSIndexPath *indexPath = [tableView indexPathForCell:nextCell];
                [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
//                [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
                [nextCell becomeFirstResponder];
            }
            break;
        }
	}	
}

- (id) nextPreviousTableCell: (UITableView *)tableView :(UITableViewCell*) currentCell : (int) direction
{
    if(currentCell){
        NSIndexPath *currentPath = [tableView indexPathForCell:currentCell];
        int currentSection = [currentPath section];
        int currentRow = [currentPath row];
        switch (direction) {
            case 0:{
                if (currentRow > 0) 
                {
                    NSIndexPath *pre = [NSIndexPath indexPathForRow:currentRow -1 inSection:currentSection];
                    UITableViewCell *preCell = [tableView cellForRowAtIndexPath:pre];
                    if ([preCell conformsToProtocol:@protocol(VitInputAccessoryTableViewCellDelegate)]) {
                        return preCell;
                    }else {
                        [self nextPreviousTableCell:tableView :preCell :direction];
                    }
                }
                else if(currentSection >0){
                    int preRowNumber = [tableView numberOfRowsInSection:currentSection -1];
                    NSIndexPath *pre = [NSIndexPath indexPathForRow:preRowNumber - 1 inSection:currentSection - 1];
                    UITableViewCell *preCell = [tableView cellForRowAtIndexPath:pre];
                    if ([preCell conformsToProtocol:@protocol(VitInputAccessoryTableViewCellDelegate)]) {
                        return preCell;
                    }else {
                        [self nextPreviousTableCell:tableView :preCell :direction];
                    }
                }
                break;
            }
                
            case 1:{
                int currentRowNumber = [tableView numberOfRowsInSection:currentSection];
                int sectionNumber = [tableView numberOfSections];
                if (currentRow < currentRowNumber - 1) 
                {
                    NSIndexPath *next = [NSIndexPath indexPathForRow:currentRow + 1 inSection:currentSection];
                    UITableViewCell *nextCell = [tableView cellForRowAtIndexPath:next];
                    
                    if ([nextCell conformsToProtocol:@protocol(VitInputAccessoryTableViewCellDelegate)]) {
                        return nextCell;
                    }else {
                        [self nextPreviousTableCell:tableView :nextCell :direction];
                    }
                }
                else if(currentSection < sectionNumber - 1){
                    NSIndexPath *next = [NSIndexPath indexPathForRow:0 inSection:currentSection + 1];
                    UITableViewCell *nextCell = [tableView cellForRowAtIndexPath:next];
                    if ([nextCell conformsToProtocol:@protocol(VitInputAccessoryTableViewCellDelegate)]) {
                        return nextCell;
                    }else {
                        [self nextPreviousTableCell:tableView :nextCell :direction];
                    }
                }
                break;
            }
            default:
                break;
        }
    }    
    return nil;
}


- (void)done:(id)sender {
	[self resignFirstResponder];
}

@end
