//
//  PopSBTableAlertTableCell.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-9-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


typedef enum {
    SBNormalListSection,
    SBRadioListSection,
    SBCheckboxListSection
} SBTableAlertTableType;

#import "SBTableAlert.h"
#import "PopListBaseTableCell.h"
#import "VTPopPickTextField.h"

@interface PopSBTableAlertTableCell : VTTableViewCell <VTPopPickTextFieldDelegate>
{
    NSUInteger _vSelection;
    NSString *_popPotionDictoryKey;
    NSArray *_vPopOptionArray;
    SBTableAlertTableType _sbType;
    VTUILabel *_displayLabel;
}

@property (nonatomic, retain) VTPopPickTextField *pick;
- (void) setDisplay : (NSString*) hostcode;

@end
