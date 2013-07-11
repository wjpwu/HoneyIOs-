//
//  LoginUI.h
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-6-5.
//  Copyright (c) 2013年 aaron. All rights reserved.
//


//Login response info

@protocol PTModLoginDelegate <NSObject>

- (void) didFinishLogin;
- (void) didCancelLogin;

@end

#import <UIKit/UIKit.h>
#import "PTUI.h"

@interface LoginUI : PTUI
{
    BOOL storeInfoFlag;

}
@property (nonatomic, assign) id<PTModLoginDelegate> delegate;

@property (weak, nonatomic) IBOutlet VTUITextField *loginId;
@property (weak, nonatomic) IBOutlet VTUITextField *loginPd;
@property (weak, nonatomic) IBOutlet VTUITextField *captCode;
@property (weak, nonatomic) IBOutlet UIButton *captImgBtn;
@property (weak, nonatomic) IBOutlet UIButton *btnStoreFlag;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

- (id)initForMo;

- (IBAction)doLogin:(id)sender;
- (IBAction)doReset:(id)sender;
- (IBAction)doGetCapt:(id)sender;
- (IBAction)doStoreUser:(id)sender;

@end
