//
//  ThemeManager.m
//  CNTMobile
//
//  Created by Aaron.Wu on 12-10-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ThemeManager.h"
#import "BCTabBarController.h"



NSString *const kThemeDidChangeNotification = @"kThemeDidChangeNotification";

@implementation ThemeManager
@synthesize currentThemeIndex;
@synthesize themeDictionary;
@synthesize currentTheme;

#define CNTThemeStyle  @"ThemeStyle"
-(id)init
{
    self = [super init];
    if(self)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"themes" ofType:@"plist"];
        themeDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
        self.currentThemeIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:CNTThemeStyle] integerValue];
        self.currentTheme = @"默认主题"; //default theme
    }
    return self;
}

+ (ThemeManager*)sharedThemeManager
{   
    static ThemeManager *instance = nil;
    if (!instance) 
    {
        instance = [[ThemeManager alloc] init];
    }
    return instance;
}


//send notification
- (void) updateStyleWithIndex:(int) index
{
    self.currentThemeIndex = index;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:self.currentThemeIndex] forKey:CNTThemeStyle];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification 
                                                        object:nil 
                                                      userInfo:nil];

}

- (void) setThemeBackgroundForController:(UIViewController*) controller
{
    NSString *selectName = [[themeDictionary allKeys] objectAtIndex:self.currentThemeIndex];
    NSString *themePathTmp = [themeDictionary objectForKey:selectName];
    NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    
    // change viewcontroller bacground
    if(themePath)
        controller.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithContentsOfFile:[themePath stringByAppendingPathComponent:@"bg.png"]]];
    
    // change tab style
    if ([controller isKindOfClass:[BCTabBarController class]]) {
        BCTabBarController *tab = (BCTabBarController*)controller;
        [tab.tabBar layoutSubviews];
    }
}

// set theme button image
- (void) setThemeBarButton:(UIButton*) btn withName:(NSString*) imgName
{
    [btn setImage:[self themeImageWithName:imgName] forState:UIControlStateNormal];
}

// get theme image name
- (UIImage*) themeImageWithName:(NSString*) imgName
{
    NSString *selectName = [[themeDictionary allKeys] objectAtIndex:self.currentThemeIndex];
    NSString *themePathTmp = [themeDictionary objectForKey:selectName];
//    NSString *themePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:themePathTmp];
    if(themePathTmp && imgName){
        return [UIImage imageNamed:[themePathTmp stringByAppendingPathComponent:imgName]];
    }
    return [UIImage imageNamed:imgName];
}

@end
