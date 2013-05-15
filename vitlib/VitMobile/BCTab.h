
typedef enum {
    LogoutTabType,
    BackTabType,
    PlainTabType,
} BCTabType;



@interface BCTab : UIButton
{
	UIImage *background;
	UIImage *rightBorder;
//    UILabel *bcTitleLabel;
    UINavigationController *_naver;
}

@property (nonatomic, retain) NSString* bcTitle;
@property (nonatomic, retain) UILabel *bcTitleLabel;

- (id)initWithIconImageName:(NSString *)imageName;
- (id)initWithTitle:(NSString *)atitle;
- (id)initWithController:(UINavigationController *)anNavController;


- (void)positionAnimated ;

@end
