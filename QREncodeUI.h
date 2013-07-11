//
//  QREncodeUI.h
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-6-8.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import "PTUI.h"

@interface QREncodeUI : PTUI

@property (weak, nonatomic) IBOutlet UITextView *inputText;
@property (weak, nonatomic) IBOutlet UIImageView *outImgv;
- (IBAction)getQRcode:(id)sender;
@end
