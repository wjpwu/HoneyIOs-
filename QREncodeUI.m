//
//  QREncodeUI.m
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-6-8.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import "QREncodeUI.h"
#import "PTSession.h"

@interface QREncodeUI ()
@end

@implementation QREncodeUI

- (id)init
{
    self = [super initWithNibName:@"QREncodeUI" bundle:nil];
    if(self){
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem *savImg= [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveQrcode)];
    self.navigationItem.rightBarButtonItem = savImg;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [self setInputText:nil];
    [self setOutImgv:nil];
    [super viewDidUnload];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [defaultNotifCenter addObserver:self selector:@selector(didGetQRcode:) name:NNDidGetQRCode object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [defaultNotifCenter removeObserver:self];
    [super viewDidDisappear:animated];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)getQRcode:(id)sender {
    [self.inputText resignFirstResponder];
    [[PTSession shareInstance] doGetQRCodeWithText:[self encodeToPercentEscapeString :self.inputText.text ]];
}

- (void) didGetQRcode :(NSNotification*) sender
{
    if ([[[sender object] valueForKey:@"status"] boolValue]) {
        UIImage *qrcode = [UIImage imageWithData:[[sender object] valueForKey:@"data"]];
        [self.outImgv setImage:qrcode];
    }
}

- (void) saveQrcode
{
    if (!self.outImgv.image) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"message:@"未获取到二维码原图"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else{
        UIImageWriteToSavedPhotosAlbum(self.outImgv.image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
   NSString *msg = nil ;
  if(error != NULL){
     msg = @"保存图片失败" ;
  }else{
    msg = @"图片成功保存至相册" ;
  }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
     	    [alert show];
}

- (NSString *)encodeToPercentEscapeString: (NSString *) input
{
    // Encode all the reserved characters, per RFC 3986
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    NSString *outputStr = (__bridge NSString *)
    CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            (CFStringRef)input,
                                            NULL,
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            kCFStringEncodingUTF8);
    return outputStr;
}

- (NSString *)decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//将所下载的图片保存到本地
-(void) saveImage:(UIImage *)image withFileName:(NSString *)imageName ofType:(NSString *)extension inDirectory:(NSString *)directoryPath {
    if ([[extension lowercaseString] isEqualToString:@"png"]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"png"]] options:NSAtomicWrite error:nil];
    } else if ([[extension lowercaseString] isEqualToString:@"jpg"] || [[extension lowercaseString] isEqualToString:@"jpeg"]) {
        [UIImageJPEGRepresentation(image, 1.0) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", imageName, @"jpg"]] options:NSAtomicWrite error:nil];
    } else {
        //ALog(@"Image Save Failed\nExtension: (%@) is not recognized, use (PNG/JPG)", extension);
        NSLog(@"文件后缀不认识");
    }
}

@end
