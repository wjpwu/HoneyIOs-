//
//  TextViewInputTableViewCell.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-9-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//


static const CGFloat kTextViewWidth = 260;

#define kFontSize ([UIFont systemFontSize])

static const CGFloat kTextViewInset = 31;
static const CGFloat kTextViewVerticalPadding = 15;
static const CGFloat kTopPadding = 6;
static const CGFloat kBottomPadding = 6;

static UIFont *textViewFont;
static UITextView *dummyTextView;


#import "TextViewInputTableViewCell.h"
#import "JFTextViewNoInset.h"

@implementation TextViewInputTableViewCell

@synthesize textView;
@synthesize text;

+ (UITextView *)createTextView {
    UITextView *newTextView = [[JFTextViewNoInset alloc] initWithFrame:CGRectZero];
    newTextView.font = textViewFont;
    newTextView.backgroundColor = [UIColor whiteColor];
    newTextView.opaque = YES;
    newTextView.scrollEnabled = NO;
    newTextView.showsVerticalScrollIndicator = NO;
    newTextView.showsHorizontalScrollIndicator = NO;
    newTextView.contentInset = UIEdgeInsetsZero;
    return newTextView;
}

+ (UITextView *)dummyTextView {
    return dummyTextView;
}


+ (CGFloat)heightForText:(NSString *)text {
    if (text == nil || text.length == 0) {
        text = @"Xy";
    }
    
    dummyTextView.text = text;
    
    CGSize textSize = dummyTextView.contentSize;
    
    return textSize.height + kBottomPadding + kTopPadding - 1 + 35;
}


+ (void)initialize {
    textViewFont = [UIFont systemFontOfSize:kFontSize];
    dummyTextView = [TextViewInputTableViewCell createTextView];
    dummyTextView.alpha = 0.0;
    dummyTextView.frame = CGRectMake(0, 0, kTextViewWidth, 500);
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        textView = [TextViewInputTableViewCell createTextView];
        textView.delegate = self;
        textView.backgroundColor = [UIColor orangeColor];
        self.textLabel.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:textView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(self.textLabel.frame.origin.x, 0, 260, 35);
    
    CGRect contentRect = self.contentView.bounds;
    contentRect.origin.y += kTopPadding + 35;
    contentRect.size.height -= kTopPadding + kBottomPadding;
    
    textView.frame = contentRect;
    textView.contentOffset = CGPointZero;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


- (void)setText:(NSMutableString *)newText {
    if (newText != text) {
        text = newText;
        textView.text = newText;
        debug_NSLog(@"New height: %f", textView.contentSize.height);
    }
}


#pragma mark -
#pragma mark UITextView delegate


//- (void) textViewDidBeginEditing:(UITextView *)theTextView {
//    if ([delegate respondsToSelector:@selector(editableTableViewCellDidBeginEditing:)]) {
//        [delegate editableTableViewCellDidBeginEditing:self];
//    }
//}
//
//
//- (void)textViewDidEndEditing:(UITextView *)theTextView {
//    [text setString:theTextView.text];
//    
//    if ([delegate respondsToSelector:@selector(editableTableViewCellDidEndEditing:)]) {
//        [delegate editableTableViewCellDidEndEditing:self];
//    }
//}


- (void)textViewDidChange:(UITextView *)theTextView {
    CGFloat suggested = [self suggestedHeight];
    CGFloat oldh = [[self.modeObject objectForKey:@"CK_Height"] floatValue];
    if (fabs(suggested - oldh) > 0.01) {
        debug_NSLog(@"Difference requires change,%f,%f",suggested,oldh);
        UITableView *tableView = (UITableView *)self.superview;
        // Calling beginUpdates/endUpdates causes the table view to reload cell geometries
        [tableView beginUpdates];
        [tableView endUpdates];
    }
    [self.modeObject setValue:[NSNumber numberWithFloat:suggested ] forKey:@"CK_Height"];
}


- (CGFloat)suggestedHeight {
    return 35 + textView.contentSize.height + kTopPadding + kBottomPadding - 1;
}


- (void)setModeObject:(NSMutableDictionary *)theModeObject
{
    modeObject = theModeObject;
//    if ([self.modeObject objectForKey:@"CK_Height"]) 
//    {
//        CGFloat height = [[self.modeObject objectForKey:@"CK_Height"] floatValue];
//    }
//    else {
//        [self.modeObject setValue:[NSNumber numberWithFloat:[self suggestedHeight]] forKey:@"CK_Height"];
//    }
    [modeObject setValue:[NSNumber numberWithFloat:[self suggestedHeight]] forKey:@"CK_Height"];
    self.textView.text = [self.modeObject objectForKey:@"CK_Text"];
    self.textLabel.text = [self.modeObject objectForKey:@"CK_Value"];
}


@end
