//
//  PopListDataPickerTableCell.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


#import "PopListBaseTableCell.h"
#import "VTPopListView.h"
#import "VTPopOptions.h"

@interface PopListDataPickerTableCell : PopListBaseTableCell <LeveyPopListViewDelegate>
{
    VTPopListView *_vPopList;
    NSString *_popPotionDictoryKey;
    NSArray *_vPopOptionArray;
    NSUInteger _vSelection;
}

@property (nonatomic,retain) NSString *_popPotionDictoryKey;
@property (nonatomic,retain) NSArray *_vPopOptionArray;

- (id)initWithWithReuseIdentifier:(NSString *)reuseIdentifier;
- (id)initWithWithReuseIdentifier:(NSString *)reuseIdentifier popOption: (NSString*) anPopOptions;
- (void) setPopListSelection:(NSInteger) anSelection;
- (void) reloadPopList;
@end
