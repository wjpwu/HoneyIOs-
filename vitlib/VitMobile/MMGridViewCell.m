//
// Copyright (c) 2010-2011 René Sprotte, Provideal GmbH
//
// Permission is hereby granted, free of charge, to any person obtaining
// a copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restriction, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
// CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "MMGridViewCell.h"
#import "MMGridView.h"


@interface MMGridViewCell()
@property (nonatomic, assign) MMGridView *gridView;
@end


@implementation MMGridViewCell

@synthesize gridView;
@synthesize index;
@synthesize isInEditingMode = _isInEditingMode, isRemovable = _isRemovable;

- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) {
    }
    
    return self;
}


- (void) addSubview:(UIView *)v
{
	[super addSubview:v];
	v.exclusiveTouch = NO;
	v.userInteractionEnabled = NO;
}

- (void)setIndex:(NSNumber *)theIndex
{
    index = [theIndex intValue];
}

// ----------------------------------------------------------------------------------

#pragma - Touch event handling

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *aTouch = [touches anyObject];
//    if (aTouch.tapCount == 2) {
//        [NSObject cancelPreviousPerformRequestsWithTarget:gridView];
//    }
//
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    SEL singleTapSelector = @selector(cellWasSelected:);
//    
//    if (gridView && [gridView respondsToSelector:singleTapSelector]) {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//        [gridView performSelector:singleTapSelector withObject:self];
//#pragma clang diagnostic pop
//    }
//}

@end
