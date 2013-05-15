//
//  VitPanelUI.m
//  VitMobileTest
//
//  Created by Aaron.Wu on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "VTPanelUI.h"
#import "PrettyKit.h"

@interface VTPanelUI ()

@end

@implementation VTPanelUI

@synthesize panelsArray,vitUIdelegate,pageControl;

- (id)init
{
	if (self = [super init])
	{
		self.panelsArray = [NSMutableArray new];
		int numberOfPanels = 3;
		for (int i=0; i<numberOfPanels; i++)
		{
			NSMutableArray *rows = [NSMutableArray array];
			int numberOfRows = arc4random()%20;
			for (int j=0; j<numberOfRows; j++)
			{
				[rows addObject:@""];
			}
			[self.panelsArray addObject:rows];
		}
		
		
		[self addPageControlUI];
	}
	return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



#pragma mark add page Control view


// this method is used to add pageControl view
- (void)addPageControlUI
{
    self.vitUIdelegate = self;
    [self.view addSubview:self.pageControl];
    self.pageControl.center = [self pageControlPoint];
	
}

-(NSArray*)pageControlTitleArray{
    if (!pageControlTitleArray) {
        if (self.vitUIdelegate && 
            [self.vitUIdelegate respondsToSelector:@selector(pageControlViewTitleArrayOfScrollView:)]) {
            pageControlTitleArray = [vitUIdelegate pageControlViewTitleArrayOfScrollView:self.scrollView];
        }
    }
    return pageControlTitleArray;
}

-(CGPoint) pageControlPoint
{
    return CGPointMake(160, 20);
}

-(CGRect) pageControlViewFrame
{
    return CGRectMake(0,0,[self.view bounds].size.width,SGCONTROL_HEIGHT);
}

- (UIView*) pageControlView{
    if (!pageControlView && self.pageControl) {
        CGRect f = [self pageControlViewFrame];
        pageControlView = [[UIView alloc] initWithFrame:f];
        [pageControlView addSubview:self.pageControl];
        pageControl.center = CGPointMake(160, 20);
    }
    return pageControlView;
}

- (SVSegmentedControl*) pageControl{
    if(!pageControl && self.pageControlTitleArray){
        pageControl = [[SVSegmentedControl alloc] initWithSectionTitles:self.pageControlTitleArray];
        [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        
        pageControl.crossFadeLabelsOnDrag = YES;
        pageControl.thumb.tintColor = [UIColor colorWithWhite:1 alpha:1];
        //pageControl.thumb.tintColor = [UIColor colorWithRed:0.6 green:0.2 blue:0.2 alpha:1];
        pageControl.selectedIndex = 0;
    }
    return pageControl;
}

-(void)setSelectPage:(int)anPage
{
    if (anPage && anPage < [self numberOfPanels]) {
        self.pageControl.selectedIndex = anPage;
        [self.pageControl moveThumbToIndex:anPage animate:NO];
        [self changePage:self.pageControl];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_
{
    [super scrollViewDidEndDecelerating:scrollView_];
    [pageControl moveThumbToIndex:currentPage animate:YES];
}

- (IBAction)changePage:(id)sender
{
    int page = pageControl.selectedIndex;

    
	// update the scroll view to the appropriate page
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];
}

// override change scrollviewframe, add sgcontrol above the scrollview
-(CGRect)scrollViewFrame
{
    if (!self.pageControl) {
        return CGRectMake(0,0,[self.view bounds].size.width,[self.view bounds].size.height);
    }
    else {
        return CGRectMake(0,SGCONTROL_HEIGHT,[self.view bounds].size.width,[self.view bounds].size.height - SGCONTROL_HEIGHT);
    } 
}

#pragma mark panel views delegate/datasource

- (CGFloat)panelView:(id)panelView heightForRowAtIndexPath:(PanelIndexPath *)indexPath
{
    return 44.0f;
}
- (PanelView *)panelViewAtPage:(NSInteger)page
{
    return nil;
}

-(NSArray *)pageControlViewTitleArrayOfScrollView:(UIScrollView *)scrollView
{
    return [NSArray arrayWithObjects:@"123",@"1231",@"1231", nil];
}

- (NSString *)panelView:(id)panelView titleForHeaderInPage:(NSInteger)pageNumber section:(NSInteger)section
{
    return nil;
}
/**
 *
 * - (NSInteger)numberOfPanels
 * set number of panels
 *
 */
- (NSInteger)numberOfPanels
{
	int numberOfPanels = [self.panelsArray count];	
	return numberOfPanels;
}

-(NSInteger)panelView:(id)panelView numberOfSectionsInPage:(NSInteger)pageNumber
{
    return 1;
}
/**
 *
 * - (NSInteger)panelView:(PanelView *)panelView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section
 * set number of rows for different panel & section
 *
 */
- (NSInteger)panelView:(PanelView *)panelView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section
{
	return [[self.panelsArray objectAtIndex:page] count];
}

/**
 *
 * - (UITableViewCell *)panelView:(PanelView *)panelView cellForRowAtIndexPath:(PanelIndexPath *)indexPath
 * use this method to change table view cells for different panel, section, and row
 *
 */
- (UITableViewCell *)panelView:(PanelView *)panelView cellForRowAtIndexPath:(PanelIndexPath *)indexPath
{
	static NSString *identity = @"UITableViewCell";
	UITableViewCell *cell = (UITableViewCell*)[panelView.tableView dequeueReusableCellWithIdentifier:identity];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
	}
	[[cell textLabel] setText:[NSString stringWithFormat:@"panel %i section %i row %i", indexPath.page, indexPath.section, indexPath.row+1]];
	return cell;
}

/**
 *
 * - (void)panelView:(PanelView *)panelView didSelectRowAtIndexPath:(PanelIndexPath *)indexPath
 * similar to - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(IndexPath *)indexPath
 *
 */

/**
 *
 * - (PanelView *)panelForPage:(NSInteger)page
 * use this method to change panel types
 * SamplePanelView should subclass PanelView
 *
 */
- (PanelView *)panelForPage:(NSInteger)page
{
	static NSString *identifier = @"SamplePanelView";
	PanelView *panelView = (PanelView*)[self dequeueReusablePageWithIdentifier:identifier];
	if (panelView == nil)
	{
		panelView = [[PanelView alloc] initWithIdentifier:identifier];
	}
	return panelView;
}


@end
