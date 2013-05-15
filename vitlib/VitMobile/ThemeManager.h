//
//  ThemeManager.h
//  CNTMobile
//
//  Created by Aaron.Wu on 12-10-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeManager : NSObject
{
    NSDictionary *themeDictionary;
    
    NSInteger currentThemeIndex;
    NSString *currentTheme;
}
@property (assign) NSInteger currentThemeIndex;
@property(nonatomic,retain) NSDictionary *themeDictionary;
@property(nonatomic,copy) NSString *currentTheme;

+ (ThemeManager*)sharedThemeManager;


// change theme and send notification
- (void) updateStyleWithIndex:(int) index;
// change theme for controller
- (void) setThemeBackgroundForController:(UIViewController*) controller;

- (void) setThemeBarButton:(UIButton*) btn withName:(NSString*) imgName;
- (UIImage*) themeImageWithName:(NSString*) imgName;

@end
