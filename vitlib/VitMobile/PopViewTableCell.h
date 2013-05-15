//
//  PopViewTableCell.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PopListBaseTableCell.h"
#import "VTUI.h"

@interface PopViewTableCell : PopListBaseTableCell <PopViewDelegate>
{
    VTUI *pop;
}

@property (nonatomic, retain) VTUI *pop;
@property (nonatomic, retain) UIView *popV;
@property (nonatomic, retain) UIView *popParView;

- (void) formatterResponse :(id)respose;

@end
