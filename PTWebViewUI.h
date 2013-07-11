//
//  PTWebViewUI.h
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-5-16.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PTWebViewUI : UIViewController

- (id)initWithAddress:(NSString*)urlString;
- (id)initWithAddress:(NSString*)urlString hidenavBar:(BOOL) hiding;

@end
