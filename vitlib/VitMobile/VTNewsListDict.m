//
//  VitNewsListDict.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTNewsListDict.h"

@implementation VTNewsListDict


- (id)initWithSingleSectionNewsList:(NSArray *)newslist
{
    NSArray *objs = [NSArray arrayWithObjects:@"",newslist, nil];
    NSDictionary *dic = [NSDictionary dictionaryWithObjects:objs forKeys:self.vitNewsListDictkeys];
    self = [NSMutableArray arrayWithObject:dic];
    return self;
}

- (id)initWithMultipleSectionNewsList:(NSArray *)newsArraylist andSections:(NSArray *)sectionTitlesArray
{
    self = [NSMutableArray arrayWithCapacity:[newsArraylist count]];
    for (int i = 0; i < [newsArraylist count]; i++) {
        NSArray *newAry = [newsArraylist objectAtIndex:i];
        NSString *secTitle = [sectionTitlesArray objectAtIndex:i];
        NSArray *objs = [NSArray arrayWithObjects:secTitle,newAry, nil];
        NSDictionary *dic = [NSDictionary dictionaryWithObjects:objs forKeys:self.vitNewsListDictkeys];
        [self addObject:dic];
    }
    return self;
}

- (NSArray*) vitNewsListDictkeys
{
    if (!vitNewsListDictkeys) {
        vitNewsListDictkeys = [NSArray arrayWithObjects:VITNEWSDICTKEY_SECTION_TITLE,VITNEWSDICTKEY_NEWS_ARRAY, nil];
    }
    return vitNewsListDictkeys;
}
@end
