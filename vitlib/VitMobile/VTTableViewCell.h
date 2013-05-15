//
//  VitTableViewCell.h
//  PickerCellDemo
//
//  Created by Aaron.Wu on 12-7-5.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define FONT_SIZE 13.0f
#define CELL_TEXTFIELD_ORIGIN_X 110
#define KK_VALUE    @"KK_VALUE"

#import <UIKit/UIKit.h>
#import "VTDelegate.h"

typedef enum {
    VitTablecellModeEdit,
    VitTablecellModeView,
    VitTablecellModeAdd
}VitTablecellMode;

@protocol VitInputAccessoryTableViewCellDelegate <NSObject>

// for set enable(Y/N) to UISegment in UISegmentedControl
@property Boolean isFirstVitCell;
@property Boolean isLastVitCell;

@end


@interface VTTableViewCell : UITableViewCell<VitInputAccessoryTableViewCellDelegate>
{
    UIToolbar *inputAccessoryView;
    UISegmentedControl *nextPreviousControl;
    NSMutableDictionary *modeObject;
}

@property (nonatomic, retain) NSMutableDictionary *modeObject;
@property (nonatomic, retain) UIToolbar *inputAccessoryView;
@property (unsafe_unretained) id<VitInputAccessoryTableViewCellDelegate> accessoryDelegate;
@property (unsafe_unretained) id<VTTableViewCellDelegate> vitDelegate;
@property (assign) VitTablecellMode cellMode;

// input field navtrival controller
- (id) nextPreviousTableCell: (UITableView *)tableView :(UITableViewCell*) currentCell : (int) direction;
// done button action in tollbar which above the keyboard
- (void)done:(id)sender ;
// init Input accessoryView
- inputAccessoryView;

- (void) setCellStyle : (VitTablecellMode) cellModeTo;


@end
