//
//  PopListBaseTableView.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTTableViewCell.h"

@interface PopListBaseTableCell : VTTableViewCell <UITextFieldDelegate>
{
    UILabel *_ckdisplayLabel;
}
@property (nonatomic, retain) UITextField *_displayLabel;

- (id) initDefaultStyleWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void) setDisplay : (NSString*) hostcode;


@end
