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

#import <UIKit/UIKit.h>
#import "MMGridViewCell.h"

typedef enum {
    VerticalLayout,
    HorizontalLayout
} GridLayoutStyle;

@class MMGridView;

// ----------------------------------------------------------------------------------

#pragma - MMGridViewDataSource

@protocol MMGridViewDataSource<NSObject>
- (NSInteger)numberOfCellsInGridView:(MMGridView *)gridView;
- (MMGridViewCell *)gridView:(MMGridView *)gridView cellAtIndex:(NSUInteger)index;
@end

// ----------------------------------------------------------------------------------

#pragma - MMGridViewDelegate

@protocol MMGridViewDelegate<NSObject>
@optional
- (void)gridView:(MMGridView *)gridView didSelectCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index;
- (void)gridView:(MMGridView *)gridView didLongPressCell:(MMGridViewCell *)cell atIndex:(NSUInteger)index;
- (void)gridView:(MMGridView *)gridView changedPageToIndex:(NSUInteger)index;
@end

// ----------------------------------------------------------------------------------

#pragma - MMGridView

@interface MMGridView : UIView<UIScrollViewDelegate> 
{
    @private
    UIScrollView *scrollView;
    id<MMGridViewDataSource>  dataSource;
    id<MMGridViewDelegate>  delegate;
    NSUInteger numberOfRows;
    NSUInteger numberOfColumns;
    NSUInteger viewMargin_X;
    GridLayoutStyle layoutStyle;
    BOOL longPressSupport;
}

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet id<MMGridViewDataSource> dataSource;
@property (nonatomic, strong) IBOutlet id<MMGridViewDelegate> delegate;
@property (nonatomic) NSUInteger numberOfRows;
@property (nonatomic) NSUInteger numberOfColumns;
@property (nonatomic) NSUInteger viewMargin_X;
@property (nonatomic, readonly) NSUInteger currentPageIndex;
@property (nonatomic, readonly) NSUInteger numberOfPages;
@property (nonatomic, readonly) NSUInteger numberOfTatalRows;
@property (nonatomic) GridLayoutStyle layoutStyle;
@property (nonatomic) BOOL longPressSupport;

- (void)reloadData;

@end
