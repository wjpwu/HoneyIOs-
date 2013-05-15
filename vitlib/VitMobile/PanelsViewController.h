/**
 * Copyright (c) 2009 Muh Hon Cheng
 * Created by honcheng on 11/27/10.
 * 
 * Permission is hereby granted, free of charge, to any person obtaining 
 * a copy of this software and associated documentation files (the 
 * "Software"), to deal in the Software without restriction, including 
 * without limitation the rights to use, copy, modify, merge, publish, 
 * distribute, sublicense, and/or sell copies of the Software, and to 
 * permit persons to whom the Software is furnished to do so, subject 
 * to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be 
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT 
 * WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 * INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR 
 * PURPOSE AND NONINFRINGEMENT. IN NO EVENT 
 * SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
 * LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR 
 * IN CONNECTION WITH THE SOFTWARE OR 
 * THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 * 
 * @author 		Muh Hon Cheng <honcheng@gmail.com>
 * @copyright	2010	Muh Hon Cheng
 * @version
 * 
 */

#import <UIKit/UIKit.h>
#import "PanelIndexPath.h"
#import "PanelView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "VTUI.h"

@interface UIScrollViewExt : UIScrollView
{
	BOOL isEditing;
}
@property (nonatomic, assign) BOOL isEditing;
@end


@interface PanelsViewController :VTUI <UIScrollViewDelegate, PanelViewDelegate>
{
    UIScrollViewExt *scrollView;
	NSMutableSet *recycledPages;
	NSMutableSet *visiblePages;
	int currentPage;
	int lastDisplayedPage;
	BOOL _isEditing;
    BOOL _navigationBar;
}

@property (nonatomic, retain) UIScrollViewExt *scrollView;
@property (nonatomic, retain) NSMutableSet *recycledPages, *visiblePages;

#define GAP 5
#define TAG_PAGE 11000

- (PanelView*)dequeueReusablePageWithIdentifier:(NSString*)identifier;
- (PanelView *)panelViewAtPage:(NSInteger)page;

#pragma mark editing
- (void)setEditing:(BOOL)isEditing;
- (void)shouldWiggle:(BOOL)wiggle;

#pragma mark frame and sizes
- (CGRect)scrollViewFrame;
- (CGSize)panelViewSize;
- (int)numberOfVisiblePanels;

#pragma mark adding and removing page
- (void)addPage;
- (void)removeCurrentPage;
- (void)removeContentOfPage:(int)page;
- (void)pushNextPage;
- (void)jumpToPreviousPage;


- (NSInteger)numberOfPanels;

@end
