//
//  VitNews.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-30.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTNewsDict.h"

@implementation VTNewsDict

- (id)initWithNewsContent:(NSString *)newsContent AndNewsAuDate:(NSString *)newsAndDate :(BOOL)newIconFlag
{
    NSArray *objs = [NSArray arrayWithObjects:newsContent,newsAndDate,[NSNumber numberWithBool:newIconFlag],nil];
    self = [NSDictionary dictionaryWithObjects:objs forKeys:self.vitNewsDictkeys];
    return self;
}


- (NSArray*) vitNewsDictkeys
{
    if (!vitNewsDictkeys) {
        vitNewsDictkeys = [NSArray arrayWithObjects:VITNEWSDICTKEY_NEWSCONTENT,VITNEWSDICTKEY_NEWSDATE,VITNEWSDICTKEY_NEWSICON, nil];
    } 
    return vitNewsDictkeys;
}

-(void)removeIconFlag
{
    [self setValue:[NSNumber numberWithBool:NO] forKey:VITNEWSDICTKEY_NEWSICON];
}

@end
