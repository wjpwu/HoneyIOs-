//
//  VTRotateMenuView.m
//
//  Created by Aaron.Wu on 12-8-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


@interface VTRotationGestureRecognizer : UIGestureRecognizer 
{
    
}

/**
 The rotation of the gesture in radians since its last change.
 */
@property (nonatomic, assign) CGFloat rotation;
@property (nonatomic, assign) CGPoint center;


@end

//
//  KTOneFingerRotationGestureRecognizer.m


#import <UIKit/UIGestureRecognizerSubclass.h>


@implementation VTRotationGestureRecognizer

@synthesize rotation = rotation_;
@synthesize center = _center;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Fail when more than 1 finger detected.
    if ([[event touchesForGestureRecognizer:self] count] > 1) {
        [self setState:UIGestureRecognizerStateFailed];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([self state] == UIGestureRecognizerStatePossible) {
        [self setState:UIGestureRecognizerStateBegan];
    } else {
        [self setState:UIGestureRecognizerStateChanged];
    }
    
    // We can look at any touch object since we know we 
    // have only 1. If there were more than 1 then 
    // touchesBegan:withEvent: would have failed the recognizer.
    UITouch *touch = [touches anyObject];
    
    // To rotate with one finger, we simulate a second finger.
    // The second figure is on the opposite side of the virtual
    // circle that represents the rotation gesture.
    
    UIView *view = [self view];
    CGPoint center = _center;
//    CGPointMake(CGRectGetMidX([view bounds]), CGRectGetMidY([view bounds]));
    CGPoint currentTouchPoint = [touch locationInView:view];
    CGPoint previousTouchPoint = [touch previousLocationInView:view];
    
    CGFloat angleInRadians = atan2f(currentTouchPoint.y - center.y, currentTouchPoint.x - center.x) - atan2f(previousTouchPoint.y - center.y, previousTouchPoint.x - center.x);
    
    [self setRotation:angleInRadians];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Perform final check to make sure a tap was not misinterpreted.
    if ([self state] == UIGestureRecognizerStateChanged) {
        [self setState:UIGestureRecognizerStateEnded];
    } else {
        [self setState:UIGestureRecognizerStateFailed];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setState:UIGestureRecognizerStateFailed];
}

@end


#import "VTRotateMenuView.h"

@implementation VTRotateMenuView
@synthesize menus,selectedMenu,_rotDelegate;

- (id) initWithFrame:(CGRect)frame Radius: (float) anRadius
{
    self = [super initWithFrame:frame]; 
    if (self){
        _rotateRadius = anRadius;
        _centerX = self.center.x;
        _centerY = self.center.y;
        _menuCenter = self.center;
        VTRotationGestureRecognizer *rotation = [[VTRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotating:)];
        [self addGestureRecognizer:rotation];
        rotation.center = CGPointMake(_centerX, _centerY);
    }
    return self;
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// scale between : 0.5 ~ 1
- (float) getScalenumberWithAngel : (float)endAngle
{
    return (cos(endAngle) + 1) * 0.5 / 2 + 0.5;
}

- (void)setMenus:(NSArray *)array {
    if (menus != array) {
        for (VTRotateMenu *menu in menus) {
            [menu removeFromSuperview];
        }        
        menus = array;        
        int index = 0;
        for (VTRotateMenu *menu in menus) {
            [self addSubview:menu];
            menu._rotDelegate = self;
            menu._locationAngle = 2.0 * M_PI * index/menus.count;
            menu._locationPosition = index;
            float Scalenumber = [self getScalenumberWithAngel:menu._locationAngle];
            ++index;
            menu.frame = CGRectMake(0.0, 0.0,120,140);
            float menuX =	_centerX - _rotateRadius*sin(menu._locationAngle);
            float menuY =  _centerY + _rotateRadius*cos(menu._locationAngle);
            menu.center = CGPointMake(menuX, menuY);
            
            CATransform3D rotationTransform = CATransform3DIdentity;
            rotationTransform = CATransform3DScale (rotationTransform, Scalenumber*VTROTATER_SCALENUMBER,Scalenumber*VTROTATER_SCALENUMBER, 1);	
            menu._scale = Scalenumber*VTROTATER_SCALENUMBER;
            menu.layer.transform=rotationTransform;
        }
        selectedMenu = [menus objectAtIndex:0];
        [self setNeedsLayout];        
    }
}

- (void) didDoubleClickMenuItem:(id)_rotateMenu
{
    VTRotateMenu *click = (VTRotateMenu*)_rotateMenu;
    if (_rotDelegate && [_rotDelegate respondsToSelector:@selector(didDoubleClickMenuItem:)]) {
        [_rotDelegate didDoubleClickMenuItem:click];
    }
}

- (void)didClickMenuItem:(id)_rotateMenu
{
    VTRotateMenu *click = (VTRotateMenu*)_rotateMenu;
    if (click.center.y == _centerY + _rotateRadius) {
        if (_rotDelegate && [_rotDelegate respondsToSelector:@selector(didClickMenuItem:)]) {
            [_rotDelegate didClickMenuItem:click];
        }
    }    
    // rotate the menu
    else
    {
        if (_rotDelegate && [_rotDelegate respondsToSelector:@selector(doStartRotate)]) {
            [_rotDelegate doStartRotate];
        }
        selectedMenu = click;
        [self menuAnimation];
    }    
}


- (void)rotating:(VTRotationGestureRecognizer *)recognizer
{
    CGFloat degrees = [recognizer rotation];
    [self menuRecognizMoveAnimAngel:degrees];
    // reset all menus to normal location
    if (recognizer.state == UIGestureRecognizerStateEnded) { 
        // find the most restenly menu
        float maxScale = 0;
        for (VTRotateMenu *menu in menus)
        {
            if (menu._scale > maxScale) {
                maxScale = menu._scale;
                selectedMenu = menu;
            }
        }
        [self menuAnimation];          
    }
}

/*****
 *
 * menu animation with UIGesture move
 *
 ****/
- (void) menuRecognizMoveAnimAngel:(CGFloat) angel
{
    if (_rotDelegate && [_rotDelegate respondsToSelector:@selector(doStartRotate)]) {
        [_rotDelegate doStartRotate];
    }
    for (VTRotateMenu *menu in menus) {
        float endAngle = menu._locationAngle + angel;
        float tmpx =  _centerX - _rotateRadius*sin(endAngle);
        float tmpy =  _centerY + _rotateRadius*cos(endAngle);
        menu.center = CGPointMake(tmpx,tmpy);
        menu._locationAngle += angel;        
        float Scalenumber = [self getScalenumberWithAngel:menu._locationAngle];
        menu._scale = Scalenumber*VTROTATER_SCALENUMBER;
        CATransform3D rotationTransform = CATransform3DIdentity;
        rotationTransform = CATransform3DScale (rotationTransform, Scalenumber*VTROTATER_SCALENUMBER,Scalenumber*VTROTATER_SCALENUMBER, 1);
        [menu.layer removeAllAnimations];
        [menu.layer setTransform:rotationTransform];
    }
}

/*****
 *
 * menu animation ,calculate selectmenu.center with  CGPointMake(_centerX, _centerY + _rotateRadius)
 *
 ****/
- (void) menuAnimation
{
    // no interaction when anim
    [self setUserInteractionEnabled:NO];    
    // calculate the move angle
    CGPoint moveTopoint = CGPointMake(_centerX, _centerY + _rotateRadius);
    CGPoint currentPoint = selectedMenu.center;    
    CGFloat moveAngle = atan2f(moveTopoint.y - _menuCenter.y, moveTopoint.x - _menuCenter.x) - atan2f(currentPoint.y - _menuCenter.y, currentPoint.x - _menuCenter.x);
    float duration = ((fabsf(moveAngle) <= M_PI) ? fabsf(moveAngle) : (2*M_PI - fabsf(moveAngle)) ) / M_PI * .3;
    for (VTRotateMenu *menu in menus) {
        //postion animation
        CAKeyframeAnimation* animation = [CAKeyframeAnimation animation];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL,menu.layer.position.x,menu.layer.position.y);
        float startAngle = menu._locationAngle;
        float endAngle = menu._locationAngle + moveAngle;
        float tmpx =  _centerX - _rotateRadius*sin(endAngle);
        float tmpy =  _centerY + _rotateRadius*cos(endAngle);
        menu.center = CGPointMake(tmpx,tmpy);
        menu._locationAngle += moveAngle;
        CGPathAddArc(path,nil,_centerX, _centerY,_rotateRadius,startAngle+ M_PI/2 , endAngle+ M_PI/2,
                     (moveAngle < 0 ? moveAngle < 0 : moveAngle > M_PI + 0.01) ? YES : NO );
        
        
        animation.path = path;
        CGPathRelease(path);
        animation.duration = duration;
        animation.repeatCount = 1;
        animation.calculationMode = @"paced";
        [menu.layer addAnimation:animation forKey:@"position"];
        
        // scale animation
        CABasicAnimation* scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
        scaleAnim.duration = duration;
        scaleAnim.repeatCount = 1;
        CATransform3D rotationTransform = CATransform3DIdentity;
        float scalenumberNew = [self getScalenumberWithAngel:menu._locationAngle];
        scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(rotationTransform,menu._scale*VTROTATER_SCALENUMBER, menu._scale*VTROTATER_SCALENUMBER, 1)];
        scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(rotationTransform,scalenumberNew*VTROTATER_SCALENUMBER, scalenumberNew*VTROTATER_SCALENUMBER, 1) ];
        scaleAnim.autoreverses = NO;	
        scaleAnim.removedOnCompletion = NO;
        scaleAnim.fillMode = kCAFillModeForwards;
        menu._scale = scalenumberNew*VTROTATER_SCALENUMBER;
        [menu.layer addAnimation:scaleAnim forKey:@"transform"];
    }
    
    // call finifsh @selector
    double delayInSeconds = duration ;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
                   {
                       [self setUserInteractionEnabled:YES];
                       if (_rotDelegate && [_rotDelegate respondsToSelector:@selector(didFinishRotateWithClickMenu:)]) {
                           [_rotDelegate didFinishRotateWithClickMenu:selectedMenu];
                       }
                   });
}


@end
