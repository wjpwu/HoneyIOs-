//
//  PopSBTableAlertTableCell.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-9-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PopSBTableAlertTableCell.h"
#import "VTPopRadioListViewCell.h"
#import "VTPopCheckListViewCell.h"
#import "VTPopOptions.h"
#import "VTConstant.h"

@implementation PopSBTableAlertTableCell
@synthesize pick;




- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.pick = [[VTPopPickTextField alloc] initWithPopTitle:@"" textDelegate:self];
    self.pick.textField.frame = CGRectMake(110, 7, 165, 30);
    _displayLabel = [[VTUILabel alloc] initAlignRightLabelWithFrame:CGRectZero];
    [self addSubview:_displayLabel];
    _displayLabel.hidden = YES;
    self.pick.textField.textAlignment = UITextAlignmentRight;
    self.pick.textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    self.pick.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.pick.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _displayLabel.textColor = [UIColor colorWithRed:FC_VALUE_R green:FC_VALUE_G blue:FC_VALUE_B alpha:1];
    self.pick.textField.textColor = [UIColor colorWithRed:FC_VALUE_R green:FC_VALUE_G blue:FC_VALUE_B alpha:1];
    //set the text font size
    _displayLabel.font = [UIFont systemFontOfSize:FS_BODY_CONTENT];
    self.pick.textField.font = [UIFont systemFontOfSize:FS_BODY_CONTENT];
    //set the placeholder color
    [self.pick.textField setValue:[UIColor colorWithRed:FC_VALUE_R green:FC_VALUE_G blue:FC_VALUE_B alpha:1] forKeyPath:@"_placeholderLabel.textColor"];    
    //set the placeholder font size
    [self.pick.textField setValue:[UIFont systemFontOfSize:FS_BODY_CONTENT] forKeyPath:@"_placeholderLabel.font"];
//    self.pick.textField.backgroundColor = [UIColor orangeColor];
    [self.pick.textField setUserInteractionEnabled:NO];
    [self addSubview:self.pick.textField];
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.pick.textField.text.length == 0) {
        _displayLabel.hidden = YES;
        self.pick.textField.hidden = NO;
        self.pick.textField.frame = CGRectInset(self.bounds, 22, 0);
    }
    else{
        _displayLabel.hidden = NO;
        self.pick.textField.hidden = YES;
        _displayLabel.text = self.pick.textField.text;
        _displayLabel.frame = CGRectMake(110, 7, 165, self.bounds.size.height - 14);
    }
}


- (void)setModeObject:(NSMutableDictionary *)newModeObject
{
    [super setModeObject:newModeObject];
    if(modeObject)
    {
        if ([modeObject objectForKey:@"CK_PopListKey"]) {
            self.pick.popPotionDictoryKey = [modeObject objectForKey:@"CK_PopListKey"];
        }
        if ([modeObject objectForKey:@"CK_PopList"]) {
            self.pick.vPopOptionArray = [modeObject objectForKey:@"CK_PopList"];
        }
        if ([modeObject objectForKey:KK_VALUE]) {
            self.pick.textField.text = [[modeObject objectForKey:KK_VALUE] objectForKey:@"text"];
        }
        else if ([modeObject objectForKey:@"CK_DefaultValue"] && [modeObject objectForKey:@"CK_PopListKey"]) {
            self.pick.textField.text = [[VTPopOptions getOptionDictionaryWithHostCode:[modeObject objectForKey:@"CK_DefaultValue"] arrayKey:[modeObject objectForKey:@"CK_PopListKey"]] objectForKey:@"text"];
        }
        else if([modeObject objectForKey:@"CK_DefaultValue"] && [modeObject objectForKey:@"CK_PopList"]){
            self.pick.textField.text = [[VTPopOptions getOptionDictionaryWithHostCode:[modeObject objectForKey:@"CK_DefaultValue"] array:[modeObject objectForKey:@"CK_PopList"]]
                objectForKey:@"text"];
        }
        else if([modeObject objectForKey:@"CK_Value"]){
            self.pick.textField.text = [modeObject objectForKey:@"CK_Value"];
        }
        else{
            self.pick.textField.text = @"";
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
	if (selected) {
		[self becomeFirstResponder];
	}
}

- (BOOL)becomeFirstResponder {

    self.pick.popTitle = self.textLabel.text;
    [self.pick showSBalert];
	return [super becomeFirstResponder];
}

- (void)popPick:(VTPopPickTextField *)pop doFinishTextEditWithPickValue:(id)theValue
{
    if (theValue) {
        //if请选择
        if ([[theValue objectForKey:@"code"] length] == 0) {
            [modeObject removeObjectForKey:KK_VALUE];
            [modeObject removeObjectForKey:@"CK_Value"];
        }
        else{
            [modeObject setObject:theValue forKey:KK_VALUE];
            [modeObject setObject:[theValue objectForKey:@"text"] forKey:@"CK_Value"];
        }
        if (self.vitDelegate && [self.vitDelegate respondsToSelector:@selector(tableViewCell:didEndEditingWithPickedValue:)])
        {
            [self.vitDelegate tableViewCell:self didEndEditingWithPickedValue:theValue];
        }
        UITableView *tv= (UITableView*)self.superview;
        if([tv indexPathForCell:self])
         [tv reloadRowsAtIndexPaths:[NSArray arrayWithObject:[tv indexPathForCell:self]] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
 }

- (void) setDisplay : (NSString*) hostcode
{    
    self.pick.textField.text = [[VTPopOptions getOptionDictionaryWithHostCode:hostcode arrayKey:
                                 [modeObject objectForKey:@"CK_PopListKey"]] objectForKey:@"text"];;
}

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    if (userInteractionEnabled) {
        self.pick.textField.placeholder = @"请选择";
    }else{
        self.pick.textField.placeholder = nil;
    }
}

//- (void) sendSelectInfo
//{
//    id result = [self._vPopOptionArray objectAtIndex:_vSelection];
//    if (result) {
//        [self.modeObject setObject:result forKey:KK_VALUE];
//    }
//    if ([[self._vPopOptionArray objectAtIndex:_vSelection] isKindOfClass:[NSString class]]) {
//        self._displayLabel.text = [self._vPopOptionArray objectAtIndex:_vSelection];
//    }
//    else {
//        self._displayLabel.text = [[self._vPopOptionArray objectAtIndex:_vSelection] objectForKey:@"text"];
//    }
//    if(self._displayLabel.text)
//        [self.modeObject setObject:self._displayLabel.text forKey:@"CK_Value"];
//    if (self.vitDelegate && [self.vitDelegate respondsToSelector:@selector(tableViewCell:didEndEditingWithPickedValue:)])
//    {
//        [self.vitDelegate tableViewCell:self didEndEditingWithPickedValue:[self._vPopOptionArray objectAtIndex:_vSelection]];
//    }
//}
//
//
//
//
//
//
//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.sbType = SBNormalListSection;
//    }
//    return self;
//}
//
//
//
//- (void)set_popPotionDictoryKey:(NSString *)anpopPotionDictoryKey
//{
//    _popPotionDictoryKey = anpopPotionDictoryKey;
//}
//
//
//- (NSArray*) _vPopOptionArray
//{
//    if (_popPotionDictoryKey) {
//        _vPopOptionArray = [VTPopOptions getPopList:_popPotionDictoryKey];
//    }
//    return _vPopOptionArray;
//}
//
//- (void)set_vPopOptionArray:(NSArray *)_tvPopOptionArray
//{
//    _vPopOptionArray = _tvPopOptionArray;
//}
//
//
//
//- (void)reloadPopList
//{
//    _vSelection = -1;
//}
//
//
//
//- (BOOL)becomeFirstResponder {
//    
//    SBTableAlert *alert	= [[SBTableAlert alloc] initWithTitle:self.textLabel.text cancelButtonTitle:NSLocalizedString(@"取消",@"") messageFormat:nil];
//    [alert setDelegate:self];
//	[alert setDataSource:self];
//	alert.maximumVisibleRows = 7;
//    alert.rowHeight = 44.0f;
//    if (self.sbType == SBCheckboxListSection) {
//        [alert.view addButtonWithTitle:NSLocalizedString(@"完成",@"")];
//    }
//	[alert show];
//	return [super becomeFirstResponder];
//}
//
//- (void) setDisplay : (NSString*) hostcode
//{
//    self._displayLabel.text = [[VTPopOptions getOptionDictionaryWithHostCode:hostcode arrayKey:self._popPotionDictoryKey] objectForKey:@"text"];;
//}
//
//#pragma mark
//- (NSString*) cellDisplaywithInfo:(id)info
//{
//    if ([info isKindOfClass:[NSString class]]) {
//        return info;
//    }
//    return [info objectForKey:@"text"];
//}
//
//
//- (void)setModeObject:(NSMutableDictionary *)theModeObject
//{
//    [super setModeObject:theModeObject];
//    if ([theModeObject objectForKey:@"CK_Value"]) {
//        self._displayLabel.text = [theModeObject objectForKey:@"CK_Value"];
//    }
//}
//
//- (CGFloat)tableAlert:(SBTableAlert *)tableAlert heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGSize constraint = CGSizeMake(200.0f, CGFLOAT_MAX);
//    CGSize size = [[self cellDisplaywithInfo:[self._vPopOptionArray objectAtIndex:indexPath.row]] sizeWithFont:[UIFont fontWithName:@"Helvetica" size:15.] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
//    CGFloat height = MAX(size.height + 20, 44.);
//    return height;
//}
//
//- (UITableViewCell *)tableAlert:(SBTableAlert *)tableAlert cellForRowAtIndexPath:(NSIndexPath *)indexPath 
//{
//    UITableViewCell *popCell;
//    switch (self.sbType) {
//        case SBNormalListSection:
//        {
//            static NSString *cellIdentity = @"popDefault";
//            popCell = [tableAlert.tableView dequeueReusableCellWithIdentifier:cellIdentity];
//            if (popCell == nil) {
//                popCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
//                popCell.backgroundColor = [UIColor clearColor];
//                popCell.textLabel.textColor = [UIColor blackColor];
//                [popCell setSelectionStyle:UITableViewCellSelectionStyleNone];
//                popCell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.];
//                popCell.accessoryType = UITableViewCellAccessoryNone;
//            }
//            [popCell setUserInteractionEnabled:YES];
//            popCell.textLabel.text = [self cellDisplaywithInfo:[self._vPopOptionArray objectAtIndex:indexPath.row]];
//            break;
//        }
//            
//        case SBRadioListSection:
//        {
//            static NSString *cellIdentity = @"VTPopRadioListViewCell";
//            VTPopRadioListViewCell *cell = [tableAlert.tableView dequeueReusableCellWithIdentifier:cellIdentity];
//            if (cell ==  nil) {
//                cell = [[VTPopRadioListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
//            }
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            
//            cell.textLabel.text = [self cellDisplaywithInfo:[self._vPopOptionArray objectAtIndex:indexPath.row]];
//            if (indexPath.row == _vSelection) 
//            {
//                [cell switchRadio:YES];
//            }
//            else {
//                [cell switchRadio:NO];
//            }
//            popCell = cell;
//            break;
//        }
//        case SBCheckboxListSection:
//        {
//            static NSString *cellIdentity = @"VTPopCheckListViewCell";
//            VTPopCheckListViewCell *cell = [tableAlert.tableView dequeueReusableCellWithIdentifier:cellIdentity];
//            if (cell ==  nil) {
//                cell = [[VTPopCheckListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
//            }
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            cell.textLabel.text = [self cellDisplaywithInfo:[self._vPopOptionArray objectAtIndex:indexPath.row]];
//            // get the indexPath.row'th bit from accumulative integer
//            int flag = (1 << indexPath.row);
//            // update row's accessory if it's "turned on"
//            if (_vSelection & flag) 
//            {
//                [cell switchCheck:YES];
//            }
//            else {
//                [cell switchCheck:NO];
//            }
//            popCell = cell;
//            break;  
//        }
//        default:
//            break;
//    }
//    return popCell;
//}
//
//- (NSInteger)tableAlert:(SBTableAlert *)tableAlert numberOfRowsInSection:(NSInteger)section {
//    return self._vPopOptionArray.count;
//}
//
//- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
//{
//    [super setUserInteractionEnabled:userInteractionEnabled];
//    if (userInteractionEnabled) {
//        self._displayLabel.placeholder = @"请选择";
//    }else{
//        self._displayLabel.placeholder = nil;
//    }
//}
//
//#pragma mark - SBTableAlertDelegate
////TODO need deal problem :wait_fences: failed to receive reply: 10004003 when anim
//- (void)tableAlert:(SBTableAlert *)tableAlert didDismissWithButtonIndex:(NSInteger)buttonIndex {
//	NSLog(@"Dismissed: %i", buttonIndex);	
//}
//
//
//
//- (void)tableAlert:(SBTableAlert *)tableAlert didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
//{
//    [tableAlert.tableView deselectRowAtIndexPath:indexPath animated:YES];
//    NSLog(@"pop radio cell.tag %d", self.tag);
//    switch (self.sbType) {
//        case SBNormalListSection:
//        {
//            _vSelection = indexPath.row;
//            [self sendSelectInfo];
//
//        }
//            break;
//        case SBRadioListSection:
//        {
//            if (_vSelection != indexPath.row) {
//                _vSelection = indexPath.row;
//                [tableAlert.tableView reloadData];
//            }            
//            _vSelection = indexPath.row;
//            [self sendSelectInfo];
//            break;
//        }
//        case SBCheckboxListSection:
//        {
//            // if supprot select all
//            if (canSelectAll) {
//                // if selected is first row 
//                if (indexPath.row == 0) {
//                    //find if it's from checked to be nonchecked,remove all checks
//                    if (_vSelection & (1<<0)) {
//                        for (int i = 0; i < [self._vPopOptionArray count]; i ++) {
//                            if (_vSelection & (1<<i)) {
//                                _vSelection ^= (1<<i);
//                            }
//                        }
//                    }
//                    // if it's from noncheck to be checked, add all checks
//                    else {
//                        for (int i = 0; i < [self._vPopOptionArray count]; i ++) {
//                            if (!(_vSelection & (1<<i))) {
//                                _vSelection ^= (1<<i);
//                            }
//                        }
//                    }
//                }
//                // if selected is not frist row
//                if (indexPath.row != 0) {
//                    //check if first row is check or not
//                    //if check fist row
//                    if (_vSelection & (1<<0))
//                    {
//                        //if selected is from check to be non check,remove first row 
//                        if (_vSelection & (1<<indexPath.row)) {
//                            _vSelection ^= (1<<0);
//                        }
//                        _vSelection ^= (1<<indexPath.row);
//                    }
//                    // if non check first row
//                    else {
//                        //if selected is from uncheck to be check,check if all row are checked or not,
//                        // if checked, first row should be check to
//                        if (!(_vSelection & (1<<indexPath.row))) {
//                            Boolean flag = NO;
//                            for (int i = 1; i < [self._vPopOptionArray count]; i ++) {
//                                if (i != indexPath.row) {
//                                    flag = _vSelection & (1<<i);
//                                    if (!flag) {
//                                        break;
//                                    }
//                                }
//                            }
//                            // check first row
//                            if (flag) {
//                                if (!(_vSelection & (1<<0))) {
//                                    _vSelection ^= (1<<0);
//                                }
//                            }
//                        }
//                        _vSelection ^= (1<<indexPath.row);
//                    }
//                }
//            }
//            else {
//                _vSelection ^= (1 << indexPath.row);
//            }
//            [tableAlert.tableView reloadData];
//            break;  
//        }
//        default:
//            break;
//    }
//}

@end
