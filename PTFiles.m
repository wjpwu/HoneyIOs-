//
//  PTFiles.m
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-6-5.
//  Copyright (c) 2013年 aaron. All rights reserved.
//

#import "PTFiles.h"

@implementation PTFiles

static PTFiles *ptFiles;

+ (PTFiles*)shareInstance
{
    @synchronized(self) {
        if (ptFiles==nil) {
            ptFiles = [[PTFiles alloc] init];
        }
    }
    return ptFiles;
}


- (NSData*) fileDataFromDocumentWithName:(NSString*) fileName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *strPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName];
    //判断文件是否存在
    if ([fileManager fileExistsAtPath:strPath])
    {
        NSData *fileData = [NSData dataWithContentsOfFile:strPath];
        return fileData;
    }
    else{
        return nil;
    }

}


- (void) storeFileToDocumentWithName:(NSString*) fileName fileContent:(id) file
{
    NSString *strPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName];
    [file writeToFile:strPath atomically:YES];
}

@end
