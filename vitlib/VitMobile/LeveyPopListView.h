//
//  LeveyPopListView.h
//  LeveyPopListViewDemo
//
//  Created by Levey on 2/21/12.
//  Copyright (c) 2012 Levey. All rights reserved.
//

#define POPLISTVIEW_SCREENINSET 40.
#define POPLISTVIEW_HEADER_HEIGHT 50.
#define POPLISTRADIUS 0.
#define POPLISTVIEW_TITLE_WIDTH 160

#define POPLISTVIEW_WIDTH 240.

@protocol LeveyPopListViewDelegate;
@interface LeveyPopListView : UIView <UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    UILabel *_titleLabel;
    NSArray *_options;
    //the checkbox table length is limited to remembering only 32 rows
    NSUInteger _selection;
}

@property (nonatomic, assign) id<LeveyPopListViewDelegate> delegate;

// The options is a NSArray, contain some NSDictionaries, the NSDictionary contain 2 keys, one is "img", another is "text".
- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions;
// If animated is YES, PopListView will be appeared with FadeIn effect.
- (void)showInView:(UIView *)aView animated:(BOOL)animated;

- (void)showInMainWindowWithAnimated:(BOOL)animated;

// self frame
- (CGRect) popListFrame;

- (void)fadeIn;
- (void)fadeOut;
- (void) initUI;

@end

@protocol LeveyPopListViewDelegate <NSObject>
@optional
- (void)leveyPopListView:(LeveyPopListView *)popListView didFinishSelectedCheckBox:(NSUInteger)anSelection;
- (void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex;
- (void)leveyPopListViewDidCancel;
@end