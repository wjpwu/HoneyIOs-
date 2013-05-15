//
//  VTPopCityListView.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LeveyPopListView.h"

@interface VTPopCityListView : LeveyPopListView
{
    NSDictionary *cities;  
    NSArray *keys;
}
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSDictionary *cities;  
@property (nonatomic, retain) NSArray *keys;

+ (VTPopCityListView*) getInstance;

@end

@protocol VTPopCityListViewProtocol
- (void) citySelectionUpdate:(NSString*)selectedCity;
- (NSString*) getDefaultCity;
@end