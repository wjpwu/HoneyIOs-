//
//  VitNewsListDict.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define VITNEWSDICTKEY_NEWS_ARRAY @"VITNEWSARRAY"
#define VITNEWSDICTKEY_SECTION_TITLE @"VITNEWSSECTION"

#import <Foundation/Foundation.h>
#import "VTNewsDict.h"

@interface VTNewsListDict : NSMutableArray
{
    NSArray *vitNewsListDictkeys;
}

- (id) initWithSingleSectionNewsList : (NSArray*) newslist;
- (id) initWithMultipleSectionNewsList : (NSArray*) newsArraylist andSections : (NSArray*) sectionTitlesArray;


@end
