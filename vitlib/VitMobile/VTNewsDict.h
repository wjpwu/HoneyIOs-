//
//  VitNews.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//



#define VITNEWSDICTKEY_NEWSCONTENT @"VITNEWSCONTENT"
#define VITNEWSDICTKEY_NEWSDATE @"VITNEWSAUTHDATE"
#define VITNEWSDICTKEY_NEWSICON @"VITNEWSICON"

#import <Foundation/Foundation.h>

@interface VTNewsDict : NSDictionary
{
    NSArray *vitNewsDictkeys;
//    NSString* newsContent;
//    NSString* newsAndDate;
//    BOOL newIconFlag;
} 
- (id) initWithNewsContent : (NSString*) newsContent AndNewsAuDate : (NSString*) newsAndDate : (BOOL) newIconFlag;
- (void) removeIconFlag;
@end
