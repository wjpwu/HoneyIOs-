//
//  LeveyPopListView.m
//  LeveyPopListViewDemo
//
//  Created by Levey on 2/21/12.
//  Copyright (c) 2012 Levey. All rights reserved.
//

#import "LeveyPopListView.h"
#import "LeveyPopListViewCell.h"



@interface LeveyPopListView ()

@end

@implementation LeveyPopListView
@synthesize delegate;

#pragma mark - initialization & cleaning up
- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions
{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    if (self = [super initWithFrame:rect])
    {
        self.backgroundColor = [UIColor clearColor];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textAlignment = UITextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.];
        _titleLabel.text = aTitle;
        [self addSubview:_titleLabel];

        _options = [aOptions copy];        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableView.separatorColor = [UIColor colorWithWhite:0 alpha:.2];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
        [self initUI];
        
    }
    [self setBackgroundColor:[UIColor colorWithRed:0.4 green:0.449 blue:0.461 alpha:0.6]];
    return self;    
}

#pragma mark - initialization tableview frame and title label frame
- (void) initUI
{
    float start_y = [self popListFrame].origin.y;
    CGRect labelFrame = CGRectMake(POPLISTVIEW_SCREENINSET+10,
                                   start_y+10 ,
                                   POPLISTVIEW_TITLE_WIDTH,
                                   30);
    CGRect tvFrame = CGRectMake(POPLISTVIEW_SCREENINSET, 
                                start_y + POPLISTVIEW_HEADER_HEIGHT, 
                                POPLISTVIEW_WIDTH,
                                [self tvHeight]);
    
    _titleLabel.frame = labelFrame;
    _tableView.frame = tvFrame;
}



- (CGRect) popListFrame
{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    
    float popHeight = [self tvHeight] + POPLISTVIEW_HEADER_HEIGHT + POPLISTRADIUS *2;
    float popWidth = POPLISTVIEW_WIDTH;
    float start_x = (rect.size.width - popWidth) /2;
    float start_y = (rect.size.height - popHeight)/2;
    return CGRectMake(start_x, start_y, popWidth, popHeight);    
}

- (float) tvHeight
{
    CGRect rect = [[UIScreen mainScreen] applicationFrame];
    float maxHeight =  rect.size.height - 2 * POPLISTVIEW_SCREENINSET - POPLISTVIEW_HEADER_HEIGHT - POPLISTRADIUS; 
    // table cell height (44.0f) * number of rows
    return (maxHeight > [_options count] * 44.) ? [_options count] * 44. : maxHeight;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self initUI];
}

//#pragma mark - Private Methods
- (void)fadeIn
{
    self.transform = CGAffineTransformMakeScale(1.3, 1.3);
    self.alpha = 0;
    [UIView animateWithDuration:.35 animations:^{
        self.alpha = 1;
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];

}
- (void)fadeOut
{
    [UIView animateWithDuration:.35 animations:^{
        self.transform = CGAffineTransformMakeScale(1.3, 1.3);
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - Instance Methods
- (void)showInView:(UIView *)aView animated:(BOOL)animated
{
    [aView addSubview:self];
    if (animated) {
        [self fadeIn];
    }
}

- (void)showInMainWindowWithAnimated:(BOOL)animated
{
    [self showInView:[UIApplication sharedApplication].keyWindow animated:animated];
}


#pragma mark - Tableview datasource & delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"PopListViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell ==  nil) {
        cell = [[LeveyPopListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity] ;
    }
//    int row = [indexPath row];
//    cell.imageView.image = [[_options objectAtIndex:row] objectForKey:@"img"];
    cell.textLabel.text = [[_options objectAtIndex:indexPath.row] objectForKey:@"text"];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // tell the delegate the selection
    if (self.delegate && [self.delegate respondsToSelector:@selector(leveyPopListView:didSelectedIndex:)]) {
        [self.delegate leveyPopListView:self didSelectedIndex:[indexPath row]];
    }
    
    // dismiss self
    [self fadeOut];
}
#pragma mark - TouchTouchTouch
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // tell the delegate the cancellation
    if (self.delegate && [self.delegate respondsToSelector:@selector(leveyPopListViewDidCancel)]) {
        [self.delegate leveyPopListViewDidCancel];
    }
    
    // dismiss self
    [self fadeOut];
}

#pragma mark - DrawDrawDraw
- (void)drawRect:(CGRect)rect
{
    [self initUI];
    CGRect bgRect = [self popListFrame];

    CGRect separatorRect = CGRectMake(POPLISTVIEW_SCREENINSET, bgRect.origin.y + POPLISTVIEW_HEADER_HEIGHT - 2,
                                      rect.size.width - 2 * POPLISTVIEW_SCREENINSET, 2);    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Draw the background with shadow
    CGContextSetShadowWithColor(ctx, CGSizeZero, 6., [UIColor colorWithWhite:0 alpha:.75].CGColor);
    [[UIColor colorWithWhite:0 alpha:.75] setFill];
    
    
    float x = bgRect.origin.x;
    float y = bgRect.origin.y;
    float width = bgRect.size.width;
    float height = bgRect.size.height;
    CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, x, y + POPLISTRADIUS);
	CGPathAddArcToPoint(path, NULL, x, y, x + POPLISTRADIUS, y, POPLISTRADIUS);
	CGPathAddArcToPoint(path, NULL, x + width, y, x + width, y + POPLISTRADIUS, POPLISTRADIUS);
	CGPathAddArcToPoint(path, NULL, x + width, y + height, x + width - POPLISTRADIUS, y + height, POPLISTRADIUS);
	CGPathAddArcToPoint(path, NULL, x, y + height, x, y + height - POPLISTRADIUS, POPLISTRADIUS);
	CGPathCloseSubpath(path);
	CGContextAddPath(ctx, path);
    CGContextFillPath(ctx);
    CGPathRelease(path);
    
    // Draw the title and the separator with shadow
    CGContextSetShadowWithColor(ctx, CGSizeMake(0, 1), 0.5f, [UIColor blackColor].CGColor);
    [[UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.] setFill];
    CGContextFillRect(ctx, separatorRect);
}
@end
