//
//  VTRotateMenu.m
//  BCTabBarController
//
//  Created by Aaron.Wu on 12-8-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import "VTRotateMenu.h"

@interface VTRoateTapGestureRecognizer : UITapGestureRecognizer

@end

@implementation VTRoateTapGestureRecognizer



@end



@implementation VTRotateMenu
@synthesize _rotDelegate,_locationAngle,_locationPosition,_scale,_mtitle;
@synthesize enable = _enable;

- (id)initWithImage:(UIImage *)image text:(NSString *)text
{
    self = [super init];
    if (self) 
    {
        imagview= [[UIImageView alloc]initWithImage:image];
        imagview.frame = CGRectMake(0,0,100,100);
        [self addSubview:imagview];
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(-20,100,140,20)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:18];
        label.tag = 2;
        _mtitle = text;
        label.text = _mtitle;
        label.textColor = [UIColor blackColor];
        label.textAlignment = UITextAlignmentCenter;
        [self addSubview:label];
        [self setUserInteractionEnabled:YES];
        VTRoateTapGestureRecognizer *singleTap = [[VTRoateTapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
        singleTap.delegate = self;
        VTRoateTapGestureRecognizer *doubleTap = [[VTRoateTapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
        doubleTap.delegate = self;
        
        singleTap.numberOfTapsRequired = 1;
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [self addGestureRecognizer:singleTap];        

        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
    }
    return self;
}

- (void)setEnable:(BOOL)enable
{
    _enable = enable;
    if (!_enable) {
        label.textColor = [UIColor darkGrayColor];
    }
    else
    {
        label.textColor = [UIColor blackColor];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}


- (void)handleSingleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        double delayInSeconds = 0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){            
            if (_rotDelegate && [_rotDelegate respondsToSelector:@selector(didClickMenuItem:)]) {
                [_rotDelegate didClickMenuItem:self];
            }
        });
    }
}

- (void)handleDoubleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {

        double delayInSeconds = 0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            if (_rotDelegate && [_rotDelegate respondsToSelector:@selector(didDoubleClickMenuItem:)]) {
                [_rotDelegate didDoubleClickMenuItem:self];
            }
        });
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CABasicAnimation* scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.duration = 0.15;
    scaleAnim.repeatCount =1;
    CATransform3D rotationTransform = CATransform3DIdentity;
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(rotationTransform,_scale, _scale, 1)];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(rotationTransform,1.5*_scale, 1.5*_scale, 1) ];
    scaleAnim.autoreverses = NO;	
    scaleAnim.removedOnCompletion = NO;
    scaleAnim.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:scaleAnim forKey:@"transform"];
    
    CABasicAnimation* scaleAnim2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim2.duration = 0.15;
    scaleAnim2.repeatCount =1;
    CATransform3D rotationTransform2 = CATransform3DIdentity;
    scaleAnim2.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(rotationTransform2,1.5*_scale, 1.5*_scale, 1)];
    scaleAnim2.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(rotationTransform2,1*_scale, 1*_scale, 1) ];
    scaleAnim2.autoreverses = NO;	
    scaleAnim2.removedOnCompletion = NO;
    scaleAnim2.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:scaleAnim2 forKey:@"transform"]; 
}


@end
