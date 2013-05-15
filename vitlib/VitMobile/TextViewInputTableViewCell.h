//
//  TextViewInputTableViewCell.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTTableViewCell.h"

@interface TextViewInputTableViewCell : VTTableViewCell <UITextViewDelegate>
{
   
}

@property(nonatomic, readonly) UITextView *textView;
@property(nonatomic, retain) NSMutableString *text;

+ (UITextView *)dummyTextView;
+ (CGFloat)heightForText:(NSString *)text;

- (CGFloat)suggestedHeight;

@end

