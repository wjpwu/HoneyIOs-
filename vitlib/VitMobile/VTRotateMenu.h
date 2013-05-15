//
//  VTRotateMenu.h
//  BCTabBarController
//
//  Created by Aaron.Wu on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#define VTROTATER_SCALENUMBER 1.


@protocol VTRotateMenuDelegate ;


#import <UIKit/UIKit.h>
#import <QuartzCore/CoreAnimation.h>

@interface VTRotateMenu : UIImageView <UIGestureRecognizerDelegate>
{
    UIImageView *imagview;
    UILabel     *label;
}
@property (nonatomic, retain) id<VTRotateMenuDelegate> _rotDelegate;
@property float _locationAngle;
@property float _scale;
@property NSInteger _locationPosition;
@property (nonatomic, retain) NSString* _mtitle;
@property (nonatomic, assign) BOOL enable;


- (id)initWithImage:(UIImage *)image text:(NSString *)text;

@end

@protocol VTRotateMenuDelegate <NSObject>

@optional
- (void) didDoubleClickMenuItem:(id) _rotateMenu;
- (void) didClickMenuItem:(id) _rotateMenu;
- (void) didDoubleClickMenuItem:(id) _rotateMenu;
- (void) didFinishRotateWithClickMenu:(id) _rotateMenu;
- (void) doStartRotate;


@end