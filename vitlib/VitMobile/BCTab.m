#import "BCTab.h"
#import "ThemeManager.h"

@interface BCTab ()
@property (nonatomic, retain) UIImage *rightBorder;
@property (nonatomic, retain) UIImage *background;
@end

@implementation BCTab
@synthesize bcTitleLabel,bcTitle,rightBorder, background;

- (id)initWithIconImageName:(NSString *)imageName {
	if (self = [super init]) {
		self.adjustsImageWhenHighlighted = NO;
//		self.background = [UIImage imageNamed:@"bar_bg32_0.png"];
//		self.rightBorder = [UIImage imageNamed:@"BCTabBarController.bundle/tab-right-border.png"];
		self.backgroundColor = [UIColor whiteColor];
		
//		NSString *selectedName = [NSString stringWithFormat:@"%@-selected.%@",
//								   [imageName stringByDeletingPathExtension],
//								   [imageName pathExtension]];
//		
//		[self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//		[self setImage:[UIImage imageNamed:selectedName] forState:UIControlStateSelected];
	}
	return self;
}

- (id)initWithTitle:(NSString *)atitle{
    if (self = [super init]) {
		self.adjustsImageWhenHighlighted = NO;
		self.backgroundColor = [UIColor clearColor];
		bcTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        bcTitleLabel.textAlignment = UITextAlignmentCenter;
        bcTitleLabel.font = [UIFont boldSystemFontOfSize :BCTABBAR_TEXTFONT];
        bcTitleLabel.numberOfLines = 0;
        bcTitleLabel.text = atitle;
        bcTitle = atitle;
        [bcTitleLabel setBackgroundColor:[UIColor clearColor]];
        bcTitleLabel.textColor = [UIColor whiteColor];
        [self addSubview:bcTitleLabel];
	}
	return self;
}

- (void) updateTabTheme
{
    [self setImage:[[ThemeManager sharedThemeManager] themeImageWithName:@"unselected"] forState:UIControlStateNormal];
    [self setImage:[[ThemeManager sharedThemeManager] themeImageWithName:@"selected"] forState:UIControlStateSelected];
}


- (void)setHighlighted:(BOOL)aBool {
	// no highlight state
}

- (id)initWithController:(UINavigationController *)anNavController
{
    if (self = [super init])
    {
        _naver = anNavController;
        self.adjustsImageWhenHighlighted = NO;
		self.backgroundColor = [UIColor clearColor];
		bcTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        bcTitleLabel.textAlignment = UITextAlignmentCenter;
        bcTitleLabel.font = [UIFont fontWithName:@"Helvetica" size:BCTABBAR_TEXTFONT];
        bcTitleLabel.text = _naver.title;
        bcTitle = _naver.title;
        [bcTitleLabel setBackgroundColor:[UIColor clearColor]];
        bcTitleLabel.textColor = [UIColor whiteColor];
        [self addSubview:bcTitleLabel];

    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGRect bounds = self.bounds;
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (self.isSelected) {
        CGContextDrawImage(context,
                           bounds,
                           [[ThemeManager sharedThemeManager] themeImageWithName:@"selected"].CGImage
                          );
    }
    else
    {
        CGContextDrawImage(context,
                           bounds,
                           [[ThemeManager sharedThemeManager] themeImageWithName:@"unselected"].CGImage);
    }
}

- (void)setFrame:(CGRect)aFrame {
	[super setFrame:aFrame];
	[self setNeedsDisplay];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
//	UIEdgeInsets imageInsets = UIEdgeInsetsMake(floor((self.bounds.size.height / 2) -
//												(self.imageView.image.size.height / 2)),
//												floor((self.bounds.size.width / 2) -
//												(self.imageView.image.size.width / 2)),
//												floor((self.bounds.size.height / 2) -
//												(self.imageView.image.size.height / 2)),
//												floor((self.bounds.size.width / 2) -
//												(self.imageView.image.size.width / 2)));
//	self.imageEdgeInsets = imageInsets;
    CGRect f = [self bounds];
    bcTitleLabel.frame = CGRectMake(f.origin.x + 8, f.origin.y, f.size.width - 10, f.size.height);
}


// -> <-
- (void)positionAnimated {
    if (self.selected) {
        bcTitleLabel.textColor = [UIColor blackColor];
        self.center = CGPointMake (BCTABBAR_WIDTH / 2,self.center.y);
    }
    else {
    self.center = CGPointMake (BCTABBAR_WIDTH / 2 - 5,self.center.y);
        bcTitleLabel.textColor = [UIColor whiteColor];
    }
}

@end
