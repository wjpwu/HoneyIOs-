//
//  VitPopListView.h
//  LeveyPopListViewDemo
//
//  Created by Aaron.Wu on 12-7-31.
//  Copyright (c) 2012年 Levey. All rights reserved.
//

typedef enum {
VTNormalListSection,
VTRadioListSection,
VTCheckboxListSection
} PopListTypeEnum;

#import "LeveyPopListView.h"

@interface VTPopListView : LeveyPopListView
{
    PopListTypeEnum _listType;
    UIButton *_done;
}

//flag identity when select first row than the check box list should select all rows and return to delagete the first row
@property (nonatomic, assign) Boolean checkListSelectAllFlag;

+ (VTPopListView*) getRadioPopListwithtitle:(NSString *)aTitle options:(NSArray *)aOptions: (NSUInteger)index;

- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions :(PopListTypeEnum) aListType;
- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions :(PopListTypeEnum)aListType selection :(NSInteger) anSelection;
- (void) reloadPopListWithSelection: (NSInteger) anSelection;

@end
