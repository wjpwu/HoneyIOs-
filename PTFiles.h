//
//  PTFiles.h
//  PacteraMBanking
//
//  Created by Aaron Wu on 13-6-5.
//  Copyright (c) 2013年 aaron. All rights reserved.
//


#define menuname            @"CommonMenu.xml"
#define menuhashname        @"CommonMenuHash.xml"
#define NNFinishStoreFile   @"NNFinishStoreFile"

#import <Foundation/Foundation.h>

@protocol PTFilesDelegate <NSObject>


@end

@interface PTFiles : NSObject

+ (PTFiles*)shareInstance;
- (NSData*) fileDataFromDocumentWithName:(NSString*) fileName;
- (void) storeFileToDocumentWithName:(NSString*) fileName
                         fileContent:(id) file;

@end
