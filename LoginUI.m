//
//  LoginUI.m
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-6-5.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import "LoginUI.h"
#import "PTSession.h"
#import "PTNavigate.h"
#import "CXMLDocument.h"
#import "CXMLElement.h"

@interface LoginUI ()<PTSessionDelegate>
{
    BOOL ifFromMo;
}
@end

@implementation LoginUI
@synthesize delegate,loginId,loginPd,btnStoreFlag,captCode,captImgBtn;

- (id)initForMo
{
    ifFromMo = YES;
    self = [super initWithNibName:@"LoginUI" bundle:nil];
    if (self) {
        storeInfoFlag = YES;
    }
    return self;
}

- (id)init
{
    ifFromMo = NO;
    self = [super initWithNibName:@"LoginUI" bundle:nil];
    if (self) {
        storeInfoFlag = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    loginId.text = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID];
    
#ifdef DEBUG
    loginPd.text = [[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_PWD];
#endif
    
    storeInfoFlag = [[[NSUserDefaults standardUserDefaults] objectForKey:USER_STORE_USER_ID_Flag] boolValue];
    [btnStoreFlag setBackgroundImage:[UIImage imageNamed : storeInfoFlag ? @"checkbox_select.png":@"checkbox_unselect.png"] forState:UIControlStateNormal];
    
    if(ifFromMo)
    {
        UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelLogin:)];
        self.navigationItem.rightBarButtonItem = cancel;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [defaultNotifCenter addObserver:self selector:@selector(didGetCaptcode:) name:NNDidGetPact object:nil];
    [defaultNotifCenter addObserver:self selector:@selector(didGetLoginResponse:) name:NNDidLogin object:nil];
    [[PTSession shareInstance] setPtDelegate:self];
    [[PTSession shareInstance] doGetCaptcode];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [defaultNotifCenter removeObserver:self];
    [[PTSession shareInstance] setPtDelegate:nil];
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [self setLoginId:nil];
    [self setLoginPd:nil];
    [self setCaptImgBtn:nil];
    [self setCaptCode:nil];
    [self setBtnStoreFlag:nil];
    [self setNavBar:nil];
    [super viewDidUnload];
}

#pragma mark textfield delegate

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 130; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void) resignResponder
{
    [self resignFirstResponder];
    [loginId resignFirstResponder];
    [loginPd resignFirstResponder];
    [captCode resignFirstResponder];
}

- (void)onRequestStart:(id)userInfo
{
    if ([[userInfo valueForKey:@"ns"] isEqualToString:NNDidLogin]) {
//        [SVProgressHUD showWithStatus:@"通讯中..." maskType:SVProgressHUDMaskTypeClear];
        debug_NSLog(@"loading start");
    }
}


- (void)onRequestFinish:(id)data
{
    debug_NSLog(@"loading finish");
    if ([[data valueForKey:@"ns"] isEqualToString:NNDidLogin]) {
//        [SVProgressHUD dismiss];
        
        NSError* error;
        CXMLDocument *document = [[CXMLDocument alloc] initWithData:[data valueForKey:@"data"] options:0 error:&error];
        NSString *status = [[[document rootElement] attributeForName:@"status"] stringValue];
        if(![@"0" isEqualToString:status])
        {
            [self doGetCapt:captImgBtn];
            NSString *msg = [[document rootElement] debugDescription];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            NSString *token = [[[document rootElement] attributeForName:@"token"] stringValue];
            if(token)
            {
                NSDictionary *d = [NSDictionary dictionaryWithObjectsAndKeys:
                                   token,@"token",
                                   loginId.text,@"lid",
                                   nil];
                [[PTSession shareInstance] storeSessionWithUserInfo:d];
                [[PTNavigate shareInstance] updateTabsAfterLogin];
                if (ifFromMo && delegate && [delegate respondsToSelector:@selector(didFinishLogin)]) {
                    [delegate didFinishLogin];
                }
            }
        }
    }
    else if([[data valueForKey:@"ns"] isEqualToString:NNDidGetPact])
    {
        UIImage *image = [UIImage imageWithData:[data valueForKey:@"data"]];
        if (image) {
            [captImgBtn setImage:image forState:UIControlStateNormal];
        }else
            [captImgBtn setImage:[UIImage imageNamed:@"err.png"] forState:UIControlStateNormal];
    }
}


- (void)onRequestFail:(id)data
{
    if ([[data valueForKey:@"ns"] isEqualToString:NNDidLogin]) {
        NSString *msg = @"Login fail, please retry";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([[data valueForKey:@"ns"] isEqualToString:NNDidGetPact])
    {
        [captImgBtn setImage:[UIImage imageNamed:@"err.png"] forState:UIControlStateNormal];
    }
    
}

//- (void)didGetCaptcode:(NSNotification*) sender
//{
//    if([[[sender object] valueForKey:@"status"] boolValue])
//    {
//        UIImage *image = [UIImage imageWithData:[[sender object] valueForKey:@"data"]];
//        if (image) {
//            [captImgBtn setImage:image forState:UIControlStateNormal];
//        }else
//            [captImgBtn setImage:[UIImage imageNamed:@"err.png"] forState:UIControlStateNormal];
//    } else
//        [captImgBtn setImage:[UIImage imageNamed:@"err.png"] forState:UIControlStateNormal];
//}
//
//- (void)didGetLoginResponse:(NSNotification*) sender
//{
//    if([[[sender object] valueForKey:@"status"] boolValue])
//    {
//        NSError* error;
//        CXMLDocument *document = [[CXMLDocument alloc] initWithData:[[sender object] valueForKey:@"data"] options:0 error:&error];
//        NSString *status = [[[document rootElement] attributeForName:@"status"] stringValue];
//        if(![@"0" isEqualToString:status])
//        {
//            NSString *msg = [[document rootElement] debugDescription];
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//        else{
//            [[PTNavigate shareInstance] updateTabsAfterLogin];
//            if (ifFromMo && delegate && [delegate respondsToSelector:@selector(didFinishLogin)]) {
//                [delegate didFinishLogin];
//            }
//        }
//    }
//    else{
//        NSString *msg = @"Login fail, please retry";
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }
//}

- (IBAction)doLogin:(id)sender {
    [self resignFirstResponder];
    NSMutableString *msg = [[NSMutableString alloc] init];
    if (loginId.text == nil || loginId.text.length == 0) {
        [msg appendString:@"请输入用户名\r"];
    }
    if (loginPd.text == nil|| loginPd.text.length == 0) {
        [msg appendString:@"请输入登录密码\r"];
    }
    if (captCode.text == nil|| captCode.text.length == 0) {
        [msg appendString:@"请输入验证码\r"];
    }
    if(msg.length >0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [[PTSession shareInstance] postLoginWithUserId:loginId.text password:loginPd.text ptCode:captCode.text];
    }
}

- (IBAction)doReset:(id)sender {
}

- (IBAction)doGetCapt:(id)sender {
    [[PTSession shareInstance] doGetCaptcode];
}

- (IBAction)doStoreUser:(id)sender {
    storeInfoFlag = !storeInfoFlag;
    [((UIButton*) sender) setBackgroundImage:[UIImage imageNamed : storeInfoFlag ? @"checkbox_select.png":@"checkbox_unselect.png"] forState:UIControlStateNormal];
}


#pragma login navigate control
- (void) cancelLogin : (id) sender
{
    if (delegate && [delegate respondsToSelector:@selector(didCancelLogin)]) {
        [delegate didCancelLogin];
    }
}


@end
