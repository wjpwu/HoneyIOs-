//
//  MBConstant.h
//  MBDemoIOS4
//
//  Created by Bill Yang on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VTConstant : NSObject
//the radius for the rounded rectangle
#define RADIUS 6.0

//the duration for the activity indicator showing time
#define DURATION 1.0

//for the bg color in RGB format
#define BG_RED 0xab
#define BG_GREEN 0xca
#define BG_BLUE 0xf5

//for the seleted item (button/cell) bg color in RGB format
#define BG_RED_SELECTED 0xE8
#define BG_GREEN_SELECTED 0xF3
#define BG_BLUE_SELECTED 0xFF

//for funds transfer type
#define kCustomButtonHeight	30.0
#define INTER_TRANSFER @"行内"
#define INTRA_TRANSFER @"跨行"

//for the public info inquiry full URL
#define TAIPING_PROFILE @"http://www.cntaiping.com/Home/CN/830/846/863/1822/2330/index.shtml"
#define TAIPING_NEWS @"http://www.cntaiping.com/Home/CN/830/846/863/1886/2950/index.shtml"

//the default cell height
#define DEFAULT_CELL_HEIGHT 44

//for common tools
#define WEATHER_FORECAST @"http://weather.news.sina.com.cn/"
#define CALCULATOR @""

//for the login username
#define MAX_LENGTH_USRNAME 10

//for the view style, 0 for list view, 1 for icon view
#define LIST_VIEW 0
#define ICON_VIEW 1

//first time logon flag, YES to present the change password and capture email and mobile information. NO to skip those process.
#define FISRT_LOGON NO


//define for skipping the progressing indicator
#define SKIP_PROCESSING YES


//for the default cell bg color in RGB format
#define BG_RED_CELL 0xff
#define BG_GREEN_CELL 0xff
#define BG_BLUE_CELL 0xff



//for identity table cell row height
//#define FONT_SIZE 13.0f
#define CELL_CONTENT_WIDTH 250.0f
#define CELL_CONTENT_DEFAULT_HEIGHT 44.0f
#define CELL_CONTENT_MARGIN 2.0f
#define CELL_CONTENT_MARGIN_LEFT 10.0f
//#define SUBLABEL_FONT_SIZE 11.0f
#define SUBLABEL_HEIGHT 20.0f


//for the font colors
//for label text color
#define FC_LABEL_R 0x15/255.0
#define FC_LABEL_G 0x42/255.0
#define FC_LABEL_B 0x8b/255.0

//for textfield placeholder color
#define FC_VALUE_R 0x93/255.0
#define FC_VALUE_G 0x99/255.0
#define FC_VALUE_B 0xa2/255.0

//for sub content font color
#define FC_SUB_VALUE grayColor

//for page title text color
#define FC_NAV_T_R 0xff/255.0
#define FC_NAV_T_G 0xff/255.0
#define FC_NAV_T_B 0xff/255.0

//define the common font size for all elements for all app
//page title in navigation bar
#define FS_NAV_TITLE 17

//define the font size for cell menu
#define FS_CELL_MENU 15

//for button text in navigation bar
#define FS_NAV_BUTTON 13

//font size for content label
#define FS_BODY_CONTENT 14

//for sub label text font size
#define FS_SUB_CONTENT 11

//the bg image name
#define BG_IMG @"bgnew2"

@end
