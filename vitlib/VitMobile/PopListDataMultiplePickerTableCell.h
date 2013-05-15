//
//  PopListDataMultiplePickerTableCell.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PopListBaseTableCell.h"
#import "VTPopListView.h"
#import "VTPopOptions.h"

@interface PopListDataMultiplePickerTableCell : PopListBaseTableCell <LeveyPopListViewDelegate>
{
    VTPopListView *_vPopList;
    NSString *_popPotionDictoryKey;
    NSArray *_vPopOptionDictionary;
    NSUInteger _vSelection;
    Boolean _supportSelectAllFlag;
}

@property (nonatomic,retain) NSArray *_vPopOptionDictionary;


- (id) initWithWithReuseIdentifier:(NSString *)reuseIdentifier popOptions: (NSString *) anPopOptions;
- (id) initWithWithReuseIdentifier:(NSString *)reuseIdentifier popOptions: (NSString *) anPopOptions : (Boolean) supportSelectAllFlag;
- (void) setPopListSelection:(NSInteger) anSelection;

@end
