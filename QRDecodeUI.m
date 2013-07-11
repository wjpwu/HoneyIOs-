//
//  QRDecodeUI.m
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-6-21.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import "QRDecodeUI.h" 
#import "PTSession.h"
#import "ASIFormDataRequest.h"

@interface QRDecodeUI () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation QRDecodeUI

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *choose= [[UIBarButtonItem alloc] initWithTitle:@"选取" style:UIBarButtonItemStyleBordered target:self action:@selector(chooseImage:)];
    self.navigationItem.rightBarButtonItem = choose;
}


- (void)viewDidUnload {
    [self setQrImgv:nil];
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [defaultNotifCenter addObserver:self selector:@selector(didDecode:) name:@"NNDecodeQR" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [defaultNotifCenter removeObserver:self];
    [super viewDidDisappear:animated];
}


#pragma mark - actionsheet delegate
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        
        NSUInteger sourceType = 0;
        
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            switch (buttonIndex) {
                case 0:
                    // 取消
                    return;
                case 1:
                    // 相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                    
                case 2:
                    // 相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            }
        }
        // 跳转到相机或相册页面
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        [self presentViewController:imagePickerController animated:YES completion:^{}];        
    }
}


#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.qrImgv setImage:image];    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}


- (void)chooseImage:(id)sender {
    
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    }
    else {
        
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    sheet.delegate = self;
    sheet.tag = 255;
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}


- (IBAction)decode:(id)sender {
    if (!self.qrImgv.image) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"message:@"请选择二维码原图"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:wwhostwithfunc(@"qrdecode")]];
        [request setRequestMethod:@"POST"];
        [request setUseCookiePersistence:NO];
        [request setData:UIImagePNGRepresentation(self.qrImgv.image) withFileName:@"qrcode.png" andContentType:@"image/png" forKey:@"file"];
        [request setUserInfo:[NSDictionary dictionaryWithObject:@"NNDecodeQR" forKey:@"ns"]];
        [[PTSession shareInstance] doPostASIRequest:request];
    }
}

- (void) didDecode :(NSNotification*) sender
{
    NSString *qrDecodeStr = [[NSString alloc] initWithData: [sender.object valueForKey:@"data"]encoding: NSUTF8StringEncoding];
    debug_NSLog(@"%@",qrDecodeStr);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCode"message:qrDecodeStr
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
