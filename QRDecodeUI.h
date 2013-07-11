//
//  QRDecodeUI.h
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-6-21.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import "PTUI.h"

@interface QRDecodeUI : PTUI
@property (weak, nonatomic) IBOutlet UIImageView *qrImgv;
- (IBAction)decode:(id)sender;

@end
