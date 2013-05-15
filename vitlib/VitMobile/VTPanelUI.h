//
//  VitPanelUI.h
//  VitMobileTest
//
//  Created by Aaron.Wu on 12-7-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SVSegmentedControl.h"
#import "PanelView.h"
#import "PanelsViewController.h"

@protocol VTPanelUIDelegate <NSObject>
- (NSArray*)pageControlViewTitleArrayOfScrollView :(UIScrollView*) scrollView;
@end

@interface VTPanelUI : PanelsViewController <VTPanelUIDelegate> {
	NSMutableArray *panelsArray;
    SVSegmentedControl *pageControl;
    NSArray *pageControlTitleArray;
    IBOutlet UIView *pageControlView;

}

@property (nonatomic, assign) id<VTPanelUIDelegate> vitUIdelegate;
@property (nonatomic, retain) NSMutableArray *panelsArray;
@property (nonatomic, retain) SVSegmentedControl *pageControl;



#define SGCONTROL_HEIGHT 40
- (void)addPageControlUI;

#pragma mark for override by subclass
- (NSArray *)pageControlViewTitleArrayOfScrollView:(UIScrollView *)scrollView;
- (NSInteger)numberOfPanels;
- (NSInteger)panelView:(id)panelView numberOfSectionsInPage:(NSInteger)pageNumber;
- (NSInteger)panelView:(id)panelView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section;
- (NSString *)panelView:(id)panelView titleForHeaderInPage:(NSInteger)pageNumber section:(NSInteger)section;
- (UITableViewCell *)panelView:(id)panelView cellForRowAtIndexPath:(PanelIndexPath *)indexPath;
- (void)panelView:(id)panelView didSelectRowAtIndexPath:(PanelIndexPath *)indexPath;
- (CGFloat)panelView:(id)panelView heightForRowAtIndexPath:(PanelIndexPath *)indexPath;
- (PanelView *)panelViewAtPage:(NSInteger)page;

- (void) setSelectPage :(int) anPage;
@end