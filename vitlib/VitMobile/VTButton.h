//
//  VTButton.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VTButton : UIButton
{
    CGPoint beginPoint;
}

@property (nonatomic) BOOL dragEnable;
@end
