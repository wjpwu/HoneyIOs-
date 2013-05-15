//
//  VTPopPickTextField.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-11-1.
//
//

#import "VTPopPickTextField.h"
#import "VTPopRadioListViewCell.h"
#import "VTPopOptions.h"

@implementation VTUILabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	self.textAlignment = UITextAlignmentLeft;
//	self.autoresizingMask = UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    self.backgroundColor = [UIColor clearColor];
    self.lineBreakMode = UILineBreakModeWordWrap;
    self.numberOfLines = 0;
    self.font = [UIFont fontWithName:@"Helvetica" size:12];
    return self;
}


- (id)initAlignRightLabelWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
	self.textAlignment = UITextAlignmentRight;
    self.backgroundColor = [UIColor clearColor];
    self.lineBreakMode = UILineBreakModeWordWrap;
//    self.autoresizingMask = UIViewAutoresizingNone;
    self.numberOfLines = 0;
    self.font = [UIFont fontWithName:@"Helvetica" size:12];
    return self;
}

- (id)initHeadLabelWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame];
    self.textColor = [UIColor blueColor];
    return self;
}

@end

@implementation VTUITextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.autocorrectionType = UITextAutocorrectionTypeDefault;
	self.autocapitalizationType = UITextAutocapitalizationTypeWords;
	self.textAlignment = UITextAlignmentLeft;
	self.clearButtonMode = UITextFieldViewModeNever;
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.backgroundColor = [UIColor clearColor];
    self.font = [UIFont fontWithName:@"Helvetica" size:12];
    self.placeholder = @"请输入";
    return self;
}


- (UIView *)inputAccessoryView {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return nil;
	} else {
		if (!inputAccessoryView) {
			inputAccessoryView = [[UIToolbar alloc] init];
			inputAccessoryView.barStyle = UIBarStyleBlackTranslucent;
			inputAccessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
			[inputAccessoryView sizeToFit];
			CGRect frame = inputAccessoryView.frame;
			frame.size.height = 44.0f;
			inputAccessoryView.frame = frame;
			
			UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
            
            UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            NSArray *array = [NSArray arrayWithObjects:flex, doneBtn, nil];
			[inputAccessoryView setItems:array];
		}
		return inputAccessoryView;
	}
}


- (void)done:(id)sender {
	[self resignFirstResponder];
}

@end


@interface VTPopPickTextField ()
{
    NSInteger selection;
}
@end

@implementation VTPopPickTextField
@synthesize textField = _textField;
@synthesize vPopOptionArray = _vPopOptionArray;
@synthesize popPotionDictoryKey = _popPotionDictoryKey;
@synthesize delegate = _delegate;
@synthesize popTitle = _popTitle;

- (id)initWithPopTitle:(NSString*) pTitle textDelegate:(id) pDelegate
{
    self = [super init];
    _popTitle = pTitle;
    self.delegate = pDelegate;
    self.textField = [[VTUITextField alloc] initWithFrame:CGRectMake(110, 7, 185, 30)];
	self.textField.delegate = self;
    self.textField.placeholder = @"请选择";
    return self;
}


- (void)setPopPotionDictoryKey:(NSString *)tpopPotionDictoryKey
{
    if(tpopPotionDictoryKey)
    {
        _popPotionDictoryKey = tpopPotionDictoryKey;
        _vPopOptionArray = [VTPopOptions getPopList:_popPotionDictoryKey];
    }
}

- (void)showSBalert {
    
    SBTableAlert *alert	= [[SBTableAlert alloc] initWithTitle:_popTitle cancelButtonTitle:NSLocalizedString(@"取消",@"") messageFormat:nil];
    [alert setDelegate:self];
	[alert setDataSource:self];
	alert.maximumVisibleRows = 7;
    alert.rowHeight = 44.0f;
	[alert show];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self showSBalert];
    return NO;
}

- (NSString*) cellDisplaywithInfo:(id)info
{
    if ([info isKindOfClass:[NSString class]]) {
        return info;
    }
    return [info objectForKey:@"text"];
}

- (CGFloat)tableAlert:(SBTableAlert *)tableAlert heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize constraint = CGSizeMake(200.0f, CGFLOAT_MAX);
    CGSize size = [[self cellDisplaywithInfo:[self.vPopOptionArray objectAtIndex:indexPath.row]] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15.] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    CGFloat height = MAX(size.height + 20, 44.);
    return height;
}


- (UITableViewCell *)tableAlert:(SBTableAlert *)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentity = @"VTPopRadioListViewCell";
    VTPopRadioListViewCell *cell = [tableAlert.tableView dequeueReusableCellWithIdentifier:cellIdentity];
    if (cell ==  nil) {
        cell = [[VTPopRadioListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.textLabel.text = [self cellDisplaywithInfo:[self.vPopOptionArray objectAtIndex:indexPath.row]];
    if ([cell.textLabel.text isEqualToString:self.textField.text])
    {
        [cell switchRadio:YES];
        selection = indexPath.row;
    }
    else {
        [cell switchRadio:NO];
    }
    return cell;
}

- (NSInteger)tableAlert:(SBTableAlert *)tableAlert numberOfRowsInSection:(NSInteger)section {
    return self.vPopOptionArray.count;
}


#pragma mark - SBTableAlertDelegate
//TODO need deal problem :wait_fences: failed to receive reply: 10004003 when anim
- (void)tableAlert:(SBTableAlert *)tableAlert didDismissWithButtonIndex:(NSInteger)buttonIndex {
	debug_NSLog(@"Dismissed: %i", buttonIndex);
}


- (void)tableAlert:(SBTableAlert *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableAlert.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (selection != indexPath.row) {
        selection = indexPath.row;
        [tableAlert.tableView reloadData];
    }
    selection = indexPath.row;
    [self sendSelectInfo];
}

- (void) sendSelectInfo
{
    if ([[self.vPopOptionArray objectAtIndex:selection] isKindOfClass:[NSString class]]) {
        _textField.text = [_vPopOptionArray objectAtIndex:selection];
    }
    else {
        _textField.text = [[_vPopOptionArray objectAtIndex:selection] objectForKey:@"text"];
    }
    if(_delegate && [_delegate respondsToSelector:@selector(popPick:doFinishTextEditWithPickValue:)])
    {
        [_delegate popPick:self doFinishTextEditWithPickValue:[_vPopOptionArray objectAtIndex:selection]];
    }
}

@end
