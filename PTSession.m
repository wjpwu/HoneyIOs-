//
//  MenuNavigate.m
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-5-15.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import "PTSession.h"
#import "PTFiles.h"
#import "PTMenus.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"

#define  MaxBufferSize   30

@interface PTSession ()

@property (nonatomic, strong) NSString          *session;
@property (nonatomic, strong) NSString          *clientToken;
@property (nonatomic, retain) ASINetworkQueue   *requestQueue;
@property (nonatomic, retain) NSMutableDictionary *sessionDic;
@property (nonatomic, retain) NSMutableDictionary *cacheDic;
@property (nonatomic, retain) NSMutableArray    *cacheArray;
@end

@implementation PTSession
@synthesize sessionDic,session,clientToken;
@synthesize ptDelegate;
@synthesize requestQueue;
@synthesize cacheDic;
@synthesize cacheArray;


static PTSession *ptHttp;

+ (PTSession*)shareInstance
{
    @synchronized(self) {
        if (ptHttp==nil) {
           ptHttp = [[PTSession alloc] init];
        }
    }
    return ptHttp;
}

- (id)init
{
    self = [super init];
    if(self){
        sessionDic = [[NSMutableDictionary alloc] init];
        cacheDic = [[NSMutableDictionary alloc] init];
        cacheArray = [[NSMutableArray alloc] init];
        requestQueue = [[ASINetworkQueue alloc] init];
        [requestQueue setDelegate:self];
        [requestQueue setRequestDidStartSelector:@selector(requestStarted:)];
        [requestQueue setRequestDidFailSelector:@selector(requestFailed:)];
        [requestQueue setRequestDidFinishSelector:@selector(requestFinished:)];
        [requestQueue setRequestWillRedirectSelector:@selector(request:willRedirectToURL:)];
		[requestQueue setShouldCancelAllRequestsOnFailure:NO];
        [requestQueue setShowAccurateProgress:YES];
    }
    return self;
}

-(void) freeMemory{
    @synchronized(self) {
        [cacheDic removeAllObjects];
        [cacheArray removeAllObjects];
    }
}

- (void) addToCacheWithName:(NSString*)name value:(id)data
{
    @synchronized(self) {
        [cacheArray insertObject:name atIndex:0];
        [cacheDic setValue:data forKey:name];
        if ([cacheArray count] > MaxBufferSize) {
            //remove last
            NSString * str=[cacheArray lastObject];
            [cacheDic removeObjectForKey:str];
            [cacheArray removeLastObject];
        }
    }
}

- (id) fileFromCacheWithName:(NSString*) icon
{
    return [cacheDic valueForKey:icon];
}

- (void) startSession
{
    [self start];
    [self doGetUUID];
}

#pragma mark session cache
- (void) storeSessionWithUserInfo:(id) userInfo
{
    [sessionDic setValuesForKeysWithDictionary:userInfo];
}

- (void) storeSessionValueWithKey:(NSString*) key value :(id)value
{
    [sessionDic setValue:value forKey:key];
}

- (void) removeFromSessionWithKey:(NSString*) key
{
    if (key) {
        [sessionDic removeObjectForKey:key];
    }
}

- (id) sessionValueWithKey:(NSString*) key
{
    return [sessionDic valueForKey:key];
}

#pragma mark http call
- (void) doGetWithUserInfo:(NSDictionary*) info
{
    NSString *url = [info valueForKey:@"url"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setRequestMethod:@"GET"];
    [request setUseCookiePersistence:YES];
    [request setTimeOutSeconds:10];
    [request setDefaultResponseEncoding:NSUTF8StringEncoding];
    [request setValidatesSecureCertificate:NO];
    request.shouldAttemptPersistentConnection = NO;
    [request setUserInfo:info];
//    [request setNumberOfTimesToRetryOnTimeout:0];
    [requestQueue addOperation:request];
}

-(void) sendNotificationWithKey:(NSString *) url Data:(NSData *) data index:(NSNumber*)index{
    NSDictionary * post=[[NSDictionary alloc] initWithObjectsAndKeys:
                         url,   @"url",
                         data,  @"data",
                         index, @"index",nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PTSession" object:post];
}

-(void) sendNotificationWithName:(NSString*) nsName object:(id)object {
    [[NSNotificationCenter defaultCenter] postNotificationName:nsName object:object];
}

- (void) doGetUUID
{
    debug_NSLog(@"doGetUUID");
    [self doGetWithUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                             wwhostuuid,@"url",@"uuid",@"type",NNDidGetUUID,@"ns",nil]];
}

- (void) doGetFileWithName:(NSString*) fileName
{
    NSString *url = [NSString stringWithFormat:@"%@%@",wwhostfile,fileName];
    id request = [NSDictionary dictionaryWithObjectsAndKeys:
                  url,@"url",@"file",@"type",fileName,@"filename",NNDidGetFile,@"ns",nil];
    [self doGetWithUserInfo:request];
}

- (void) doGetFileMD5WithName:(NSString*) fileName
{
    [self doGetFileMD5WithName:fileName storeToFile:NO];
}

- (void) doGetFileMD5WithName:(NSString*) fileName storeToFile:(BOOL) flag
{
    debug_NSLog(@"doGetFileMD5WithName");
    NSString *url = [[NSString alloc] initWithFormat:@"%@%@",wwhostfilemd5,fileName];
    id request = [NSDictionary dictionaryWithObjectsAndKeys:
                  url,@"url",@"MD5",@"type",fileName,@"filename",[NSNumber numberWithBool:flag],@"store",NNDidGetMenuMD5,@"ns",nil];
    [self doGetWithUserInfo:request];
}

- (void) doGetMenu
{
    debug_NSLog(@"doGetMenu");
    NSString *url = [NSString stringWithFormat:@"%@%@",wwhostfile,menuname];
    id request = [NSDictionary dictionaryWithObjectsAndKeys:url,@"url",@"menu",@"type",menuname,@"filename",NNDidGetMenu,@"ns",nil];
    [self doGetWithUserInfo:request];
}

- (void) doGetIconWithName:(NSString *)icon
{
    debug_NSLog(@"doGetIconWithName:%@",icon);
    NSString *url = [NSString stringWithFormat:@"%@%@",wwhostfile,icon];
    id request = [NSDictionary dictionaryWithObjectsAndKeys:url,@"url",@"icon",@"type",icon,@"filename",NNDidGetIcon,@"ns",nil];
    [self doGetWithUserInfo:request];
}

- (void) doGetCaptcode
{
    debug_NSLog(@"doGetCaptcode");
    NSString *url = [NSString stringWithFormat:@"%@%@",wwhostcapt,session];
    id request = [NSDictionary dictionaryWithObjectsAndKeys:url,@"url",@"capt",@"type",NNDidGetPact,@"ns",nil];
    [self doGetWithUserInfo:request];
}

- (void) doGetQRCodeWithText:(NSString*) text
{
    debug_NSLog(@"doGetQRCodeWithText");
    NSString *url = [NSString stringWithFormat:@"%@%@",wwhostqrencode,text];
    id request = [NSDictionary dictionaryWithObjectsAndKeys:url,@"url",@"qrcode",@"type",NNDidGetQRCode,@"ns",nil];
    [self doGetWithUserInfo:request];
}

- (void) doPostASIRequest:(ASIHTTPRequest*)request
{
    if (request) {
        [requestQueue addOperation:request];
    }
}


- (void)postLoginWithUserId:(NSString *)useId password:(NSString *)password ptCode:(NSString *)ptCode
{
    debug_NSLog(@"postLoginWithUserId");
    ASIFormDataRequest *loginRq = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:wwhostlogin]];
    [loginRq setRequestMethod:@"POST"];
    [loginRq setUseCookiePersistence:YES];
    [loginRq setPostValue:useId forKey:@"mobileNo"];
    [loginRq setPostValue:password forKey:@"passWord"];
    [loginRq setPostValue:session forKey:@"uuid"];
    [loginRq setPostValue:ptCode forKey:@"captCode"];
    [loginRq setUserInfo:[NSDictionary dictionaryWithObject:NNDidLogin forKey:@"ns"]];
    [requestQueue addOperation:loginRq];
}



#pragma mark ASIHTTPRequest http delegate
- (void)requestStarted:(ASIHTTPRequest *)request
{
    if (ptDelegate && [ptDelegate respondsToSelector:@selector(onRequestStart:)]) {
        [ptDelegate onRequestStart:[request userInfo]];
    }
}

- (void)authenticationNeededForRequest:(ASIHTTPRequest *)request
{
//    [request setUsername:soapService.username];
//    [request setPassword:soapService.password];
    [request retryUsingSuppliedCredentials];
}

//TODO
- (void)requestFailed:(ASIHTTPRequest *)request
{
    if ([request retryCount] > 0) {
        debug_NSLog(@"ASIHTTPRequest fail but retry :%d",[request retryCount]);
    }
    debug_NSLog(@"ASIHTTPRequest fail but retry :%d",[request retryCount]);
    debug_NSLog(@"ASIHTTPRequest fail: :%@",request.error);
    if (ptDelegate && [ptDelegate respondsToSelector:@selector(onRequestFail:)]) {
        id ns = [[request userInfo] valueForKey:@"ns"];
        if (!ns) {
            ns = @"";
        }
        id object = [NSDictionary dictionaryWithObjectsAndKeys:ns,@"ns",request.error,@"data",nil];
        [ptDelegate onRequestFail:object];
    }
    else{
        [self sendNotificationWithName:NNDidGetFail object:[NSDictionary dictionaryWithObjectsAndKeys:
                                                            @"0",@"status",
                                                            request.error,@"error",nil]];
    }
//    NSString *ns = [[request userInfo] valueForKey:@"ns"];

}


- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSString *requestType = [[request userInfo] valueForKey:@"type"];
    debug_NSLog(@"ASIHTTPRequest requestFinished: :%@   ns:%@",requestType,[[request userInfo] valueForKey:@"ns"]);
    if([@"uuid" isEqualToString:requestType]){
        session = [[NSString alloc] initWithData: request.responseData encoding: NSUTF8StringEncoding];
        NSLog(@"get uuid %@",session);
        id object = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"status",session,@"data",nil];
        [self sendNotificationWithName:NNDidGetUUID object:object];
    }
//    else if([@"capt" isEqualToString:requestType]){
//        id object = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"status",request.rawResponseData,@"data",nil];
//        [self sendNotificationWithName:NNDidGetPact object:object];
//    }
    else if([@"menu" isEqualToString:requestType]){
        // store files
        [[PTFiles shareInstance] storeFileToDocumentWithName:[[request userInfo] valueForKey:@"filename"] fileContent:request.rawResponseData];
        // send notification
        [self addToCacheWithName:[[request userInfo] valueForKey:@"filename"] value:request.rawResponseData];
        id object = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"status",request.rawResponseData,@"data",nil];
        [self sendNotificationWithName:NNDidGetMenu object:object];
        [self doGetFileMD5WithName:[[request userInfo] valueForKey:@"filename"] storeToFile:YES];
    }
    else if([@"icon" isEqualToString:requestType]){
        // store files
        [[PTFiles shareInstance] storeFileToDocumentWithName:[[request userInfo] valueForKey:@"filename"] fileContent:request.rawResponseData];
        // send notification
        [self addToCacheWithName:[[request userInfo] valueForKey:@"filename"] value:request.rawResponseData];
        id object = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"status",request.rawResponseData,@"data",nil];
        NSString *ns = [NSString stringWithFormat:@"%@%@",NNDidGetIcon,[[request userInfo] valueForKey:@"filename"] ];
        [self sendNotificationWithName:ns object:object];
    }
    else if([@"MD5" isEqualToString:requestType]){
        if ([[[request userInfo] valueForKey:@"store"] boolValue]) {
            NSString *md5File = [NSString stringWithFormat:@"%@%@",[[request userInfo] valueForKey:@"filename"], @"MD5"];
            [[PTFiles shareInstance] storeFileToDocumentWithName:md5File fileContent:request.responseData];
        } else{
            id object = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"status",request.responseData,@"data",nil];
            [self sendNotificationWithName:NNDidGetMenuMD5 object:object];
        }
    }
    else if (ptDelegate && [ptDelegate respondsToSelector:@selector(onRequestFinish:)]) {
        id ns = [[request userInfo] valueForKey:@"ns"];
        if (!ns) {
            ns = @"";
        }
        id object = [NSDictionary dictionaryWithObjectsAndKeys:ns,@"ns",request.responseData,@"data",nil];
        [ptDelegate onRequestFinish:object];
    }
    else if([[request userInfo] valueForKey:@"ns"]){
        id object = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"status",request.responseData,@"data",nil];
        [self sendNotificationWithName:[[request userInfo] valueForKey:@"ns"] object:object];
    }
}


#pragma mark - Operate queue
- (BOOL)isRunning
{
	return ![requestQueue isSuspended];
}

- (void)start
{
	if( [requestQueue isSuspended] )
		[requestQueue go];
}

- (void)pause
{
	[requestQueue setSuspended:YES];
}

- (void)resume
{
	[requestQueue setSuspended:NO];
}

- (void)cancel
{
	[requestQueue cancelAllOperations];
}
@end
