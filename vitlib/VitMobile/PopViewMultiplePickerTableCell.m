//
//  PopViewMultiplePickerTableCell.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-9-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PopViewMultiplePickerTableCell.h"

@implementation PopViewMultiplePickerTableCell

// override 
- (void) formatterResponse:(id)respose
{    
    if ([respose isKindOfClass:[NSMutableArray class]]) {
        NSMutableString *tmp = [[NSMutableString alloc] init];
        for (NSDictionary *info in respose) {
            [tmp appendString:[info objectForKey:@"text"]];
            [tmp appendString:@"\n"];
        }
        self._displayLabel.text = tmp; 
    }else if([respose isKindOfClass:[NSDictionary class]])
    {
        self._displayLabel.text = [respose objectForKey:@"text"];
    }else{
        self._displayLabel.text = @"";
    }
    [self.modeObject setObject:self._displayLabel.text forKey:@"CK_Value"];
}

- (void)setModeObject:(NSMutableDictionary *)theModeObject
{
    modeObject = theModeObject;
    if ([theModeObject objectForKey:@"CK_Value"]) {
        self._displayLabel.text = [theModeObject objectForKey:@"CK_Value"];
    }
}

@end
