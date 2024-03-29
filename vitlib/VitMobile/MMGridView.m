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


#define K_DEFAULT_NUMBEROFROWS      4
#define K_DEFAULT_NUMBEROFCOLUMNS   4
#define K_DEFAULT_VIEWMARGIN_X      2
#define K_DEFAULT_PAGEINDEX         0
#define K_DEFAULT_LAYOUTSTYLE HorizontalLayout


#import "MMGridView.h"


@interface MMGridView()

@property (nonatomic) UIScrollView *scrollView;
@property (nonatomic) NSUInteger currentPageIndex;
@property (nonatomic) NSUInteger numberOfPages;
@property (nonatomic) NSUInteger numberOfTatalRows;

- (void)createSubviews;
- (void)cellWasSelected:(MMGridViewCell *)cell;
- (void)cellWasLongPressed:(MMGridViewCell *)cell;
- (void)updateCurrentPageIndex;
@end


@implementation MMGridView

@synthesize scrollView;
@synthesize dataSource;
@synthesize delegate;
@synthesize numberOfRows;
@synthesize numberOfColumns;
@synthesize viewMargin_X;
@synthesize currentPageIndex;
@synthesize numberOfPages;
@synthesize numberOfTatalRows;
@synthesize layoutStyle;
@synthesize longPressSupport;




- (id)initWithFrame:(CGRect)frame 
{
    if ((self = [super initWithFrame:frame])) {
        [self createSubviews];
    }
    
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self createSubviews];
    }
    
    return self;
}


- (void)createSubviews
{
    viewMargin_X = K_DEFAULT_VIEWMARGIN_X;
    numberOfRows = K_DEFAULT_NUMBEROFROWS;
    numberOfColumns = K_DEFAULT_NUMBEROFCOLUMNS;
    currentPageIndex = K_DEFAULT_PAGEINDEX;
    layoutStyle = K_DEFAULT_LAYOUTSTYLE;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; 
    self.contentMode = UIViewContentModeRedraw;
    self.backgroundColor = [UIColor clearColor];
    CGRect f = self.bounds;
    CGRect f1 = CGRectInset(f, 0, self.viewMargin_X);
    self.scrollView = [[UIScrollView alloc] initWithFrame:f1];
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = self.backgroundColor;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.scrollView.alwaysBounceHorizontal = NO;
    self.scrollView.alwaysBounceVertical = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;

    if (layoutStyle == HorizontalLayout) {
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsVerticalScrollIndicator = NO;
        self.scrollView.alwaysBounceVertical = NO;
    } else {
        self.scrollView.pagingEnabled = NO;
        self.scrollView.showsVerticalScrollIndicator = YES;
        self.scrollView.alwaysBounceVertical = YES;
    }
    
    [self addSubview:self.scrollView];
    [self reloadData];
}


- (void)drawRect:(CGRect)rect
{

    
    if (self.dataSource && self.numberOfRows > 0 && self.numberOfColumns > 0) {
        NSInteger noOfCols = self.numberOfColumns;
        NSInteger noOfRows = self.numberOfRows;
        NSUInteger cellsPerPage = self.numberOfColumns * self.numberOfRows;
        
        BOOL isLandscape = UIInterfaceOrientationIsLandscape([[UIDevice currentDevice] orientation]);
        if (isLandscape) {
            // In landscape mode switch rows and columns
            noOfCols = self.numberOfRows;
            noOfRows = self.numberOfColumns;
        }
        
        CGRect gridBounds = self.scrollView.bounds;
        CGRect cellBounds = CGRectMake(0, 0, gridBounds.size.width / (float)noOfCols, 
                                       gridBounds.size.height / (float)noOfRows);
        
        CGSize contentSize;
        
        if (layoutStyle == HorizontalLayout) {
            contentSize = CGSizeMake(self.numberOfPages * gridBounds.size.width, gridBounds.size.height);
        } else {
            contentSize = CGSizeMake(gridBounds.size.width, self.numberOfTatalRows * cellBounds.size.height);
        }
        [self.scrollView setContentSize:contentSize];
        
        for (UIView *v in self.scrollView.subviews) {
            [v removeFromSuperview];
        }

        for (NSInteger i = 0; i < [self.dataSource numberOfCellsInGridView:self]; i++) {
            MMGridViewCell *cell = [self.dataSource gridView:self cellAtIndex:i];
            [cell performSelector:@selector(setGridView:) withObject:self];
            [cell performSelector:@selector(setIndex:) withObject:[NSNumber numberWithInt:i]];
            [cell addTarget:self action:@selector(cellWasSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            if(self.longPressSupport){
                cell.isRemovable = YES;
                UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(cellWasLongPressed:)];
                [cell addGestureRecognizer:longPress];
            }
            
            NSInteger page = (int)floor((float)i / (float)cellsPerPage);
            NSInteger row  = (int)floor((float)i / (float)noOfCols) - (page * noOfRows);
         
            CGPoint origin;
            if (layoutStyle == HorizontalLayout) {
                origin = CGPointMake((page * gridBounds.size.width) + ((i % noOfCols) * cellBounds.size.width), 
                                     (row * cellBounds.size.height));
            } else {
                origin = CGPointMake((i % noOfCols) * cellBounds.size.width, 
                                     (ceil( i / noOfCols)) * cellBounds.size.height);
            }

            CGRect f = CGRectMake(origin.x, origin.y, cellBounds.size.width, cellBounds.size.height);
            cell.frame = CGRectInset(f, self.viewMargin_X, self.viewMargin_X);
            cell.frame = f;
            [self.scrollView addSubview:cell];
        }
    }
}


- (void)setDataSource:(id<MMGridViewDataSource>)aDataSource
{
    dataSource = aDataSource;
    [self reloadData];
}


- (void)setNumberOfColumns:(NSUInteger)value
{
    numberOfColumns = value;
    [self reloadData];
}


- (void)setNumberOfRows:(NSUInteger)value
{
    numberOfRows = value;
    [self reloadData];
}


- (void)setViewMargin_X:(NSUInteger)value
{
    viewMargin_X = value;
    [self reloadData];
}


- (NSUInteger)numberOfPages
{
    if (layoutStyle == HorizontalLayout) {
        NSUInteger numberOfCells = [self.dataSource numberOfCellsInGridView:self];
        NSUInteger cellsPerPage = self.numberOfColumns * self.numberOfRows;
        return (uint)(ceil((float)numberOfCells / (float)cellsPerPage));
    } else {
        return 1;
    }
}


- (NSUInteger)numberOfTatalRows
{
    if (layoutStyle == VerticalLayout) {
        NSUInteger numberofCells = [self.dataSource numberOfCellsInGridView:self];
        if (numberofCells % numberOfColumns == 0) {
            return numberofCells / numberOfColumns;
        } else {
            return numberofCells / numberOfColumns + 1;
        }
    } else {
        return self.numberOfRows;
    }
}


- (void)reloadData
{
    [self setNeedsDisplay];
}


- (void)cellWasSelected:(MMGridViewCell *)cell
{
    if (delegate && [delegate respondsToSelector:@selector(gridView:didSelectCell:atIndex:)]) {
        [delegate gridView:self didSelectCell:cell atIndex:cell.index];
    }
}

- (void)cellWasLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{

    if (gestureRecognizer.state == UIGestureRecognizerStateRecognized)
    {
        MMGridViewCell *cell= (MMGridViewCell*)[gestureRecognizer view];
        if (delegate && [delegate respondsToSelector:@selector(gridView:didLongPressCell:atIndex:)]) {
            [delegate gridView:self didLongPressCell:cell atIndex:cell.index];
        }
        
    }
}


- (void)updateCurrentPageIndex
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSUInteger cpi = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.currentPageIndex = cpi;
    
    if (delegate && [delegate respondsToSelector:@selector(gridView:changedPageToIndex:)]) {
        [self.delegate gridView:self changedPageToIndex:self.currentPageIndex];
    }
}

// ----------------------------------------------------------------------------------

#pragma - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateCurrentPageIndex];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updateCurrentPageIndex];
}

@end
