//
//  PTSession.h
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-5-15.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#define wwamzhost       @"http://pacific-sands-3422.herokuapp.com/root/"
//#define wwamzhost       @"http://192.168.0.123:9000/root/"


#define wwhost          [NSString stringWithFormat:@"%@%@",wwamzhost,@""]
#define wwhostuuid      [NSString stringWithFormat:@"%@%@",wwamzhost,@"mobileuuid"]
#define wwhostlogin     [NSString stringWithFormat:@"%@%@",wwamzhost,@"mobilelogin"]
#define wwhostcapt      [NSString stringWithFormat:@"%@%@",wwamzhost,@"mobilecaptcha/"]
#define wwhostmenu      [NSString stringWithFormat:@"%@%@",wwamzhost,@"mobilemenu/"]
#define wwhostfile      [NSString stringWithFormat:@"%@%@",wwamzhost,@"mobileitem?client=IOS&file="]
#define wwhostfilemd5   [NSString stringWithFormat:@"%@%@",wwamzhost,@"mobileitemmd5?client=IOS&file="]
#define wwhosticon      [NSString stringWithFormat:@"%@%@",wwamzhost,@"mobileicon/"]
#define wwhostqrencode  [NSString stringWithFormat:@"%@%@",wwamzhost,@"QREncode?text="]
#define wwhostwithfunc(func)   [NSString stringWithFormat:@"%@%@",wwamzhost,func]

//http://chart.apis.google.com/chart?chs=120x120&chl=wifi:helloworld110&choe=UTF-8&cht=qr
#import <Foundation/Foundation.h>

@protocol PTSessionDelegate <NSObject>

@optional
- (void) onRequestStart:(id) userInfo;
- (void) onRequestFinish:(id) data;
- (void) onRequestFail:(id) data;

@end


@interface PTSession : NSObject

@property (assign, nonatomic) id<PTSessionDelegate> ptDelegate;

+ (PTSession*)shareInstance;
- (void) startSession;
- (void) storeSessionWithUserInfo:(id) userInfo;
- (void) storeSessionValueWithKey:(NSString*) key
                           value :(id)value;
- (void) removeFromSessionWithKey:(NSString*) key;
- (id) sessionValueWithKey:(NSString*) key;


- (id) fileFromCacheWithName:(NSString*) icon;
- (void) doGetMenu;
- (void) doGetFileMD5WithName:(NSString*) fileName;
- (void) doGetFileMD5WithName:(NSString*) fileName
                  storeToFile:(BOOL) flag;
- (void) doGetIconWithName:(NSString*)icon;
- (void) doGetUUID;
- (void) doGetCaptcode;
- (void) doGetQRCodeWithText:(NSString*) text;
- (void) postLoginWithUserId:(NSString*) useId
                    password:(NSString*) password
                      ptCode:(NSString*) ptCode;

- (void) doPostASIRequest:(id)request;

- (BOOL)isRunning;
- (void)start;
- (void)pause;
- (void)resume;
- (void)cancel;
@end
