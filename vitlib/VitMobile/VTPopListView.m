//
//  VitPopListView.m
//  LeveyPopListViewDemo
//
//  Created by Aaron.Wu on 12-7-31.
//  Copyright (c) 2012年 Levey. All rights reserved.
//

#import "VTPopListView.h"
#import "VTPopCheckListViewCell.h"
#import "VTPopRadioListViewCell.h"

static VTPopListView *radioInstance = nil;

@implementation VTPopListView
@synthesize checkListSelectAllFlag;

+ (VTPopListView*) getRadioPopList
{
     @synchronized(self)
    
    {
    if (radioInstance == nil) {
            radioInstance = [[VTPopListView alloc] initWithTitle:nil options:nil];
        radioInstance->_listType = VTRadioListSection;
        }        
    }
    return radioInstance;
}

+ (VTPopListView*) getRadioPopListwithtitle:(NSString *)aTitle options:(NSArray *)aOptions: (NSUInteger)index
{
    [VTPopListView getRadioPopList]->_titleLabel.text = aTitle;
    [VTPopListView getRadioPopList]->_options = aOptions;
    [VTPopListView getRadioPopList]->_selection = index;
    [[VTPopListView getRadioPopList]->_tableView reloadData];
    [[VTPopListView getRadioPopList] setNeedsDisplay];
    return [VTPopListView getRadioPopList];
}

- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions :(PopListTypeEnum)aListType
{
    if (aListType == VTCheckboxListSection && [aOptions count] > 32) {
        assert("the checkbox table length is limited to remembering only 32 rows!");
    }
    self = [super initWithTitle:aTitle options:aOptions];
    if (self) {
        _listType = aListType;
        _selection = -1;
        if (_listType == VTCheckboxListSection) {
            float start_y = [self popListFrame].origin.y;
            _done =[UIButton buttonWithType:UIButtonTypeRoundedRect];
             _done.frame = CGRectMake(POPLISTVIEW_SCREENINSET + 10 + POPLISTVIEW_TITLE_WIDTH,start_y + 10 ,60, 30);
            [_done.titleLabel setFont:[UIFont systemFontOfSize:14.]];
            [_done setTitle:@"完成" forState:UIControlStateNormal];    
            _done.titleLabel.textColor = [UIColor colorWithRed:0.020 green:0.549 blue:0.961 alpha:1.];
            [_done addTarget:self action:@selector(didFinishCheckBoxSelection:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:_done];
            _selection = 0;
        }
    }
    return self;
}

- (id)initWithTitle:(NSString *)aTitle options:(NSArray *)aOptions :(PopListTypeEnum)aListType selection:(NSInteger)anSelection
{
    self = [self initWithTitle:aTitle options:aOptions :aListType];
    if (self) {
        _selection = anSelection;
    }
    return self;
}

- (void) reloadPopListWithSelection: (NSInteger) anSelection
{
     _selection = anSelection;
    [_tableView reloadData];
}

- (NSString*) cellDisplaywithInfo:(id)info
{
    if ([info isKindOfClass:[NSString class]]) {
        return info;
    }
    return [info objectForKey:@"text"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *popCell;
    switch (_listType) {
        case VTNormalListSection:
        {
            static NSString *cellIdentity = @"popDefault";
            popCell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
            if (popCell == nil) {
                popCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
                popCell.backgroundColor = [UIColor clearColor];
                popCell.textLabel.textColor = [UIColor blackColor];
                [popCell setSelectionStyle:UITableViewCellSelectionStyleNone];
                popCell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15.];
                popCell.accessoryType = UITableViewCellAccessoryNone;
            }
            [popCell setUserInteractionEnabled:YES];
            popCell.textLabel.text = [self cellDisplaywithInfo:[_options objectAtIndex:indexPath.row]];
            break;
        }
            
        case VTRadioListSection:
        {
            static NSString *cellIdentity = @"PopRadioListViewCell";
            VTPopRadioListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
            if (cell ==  nil) {
                cell = [[VTPopRadioListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            cell.textLabel.text = [self cellDisplaywithInfo:[_options objectAtIndex:indexPath.row]];
            if (indexPath.row == _selection) 
            {
                [cell switchRadio:YES];
            }
            else {
                 [cell switchRadio:NO];
            }
            popCell = cell;
            break;
        }
        case VTCheckboxListSection:
        {
            static NSString *cellIdentity = @"PopCheckListViewCell";
            VTPopCheckListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentity];
            if (cell ==  nil) {
                cell = [[VTPopCheckListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentity];
            }
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = [self cellDisplaywithInfo:[_options objectAtIndex:indexPath.row]];
            // get the indexPath.row'th bit from accumulative integer
            int flag = (1 << indexPath.row);
            // update row's accessory if it's "turned on"
            if (_selection & flag) 
            {
                [cell switchCheck:YES];
            }
            else {
                [cell switchCheck:NO];
            }
            popCell = cell;
            break;  
        }
        default:
            break;
    }
    return popCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (_listType) {
        case VTNormalListSection:
        {
            // tell the delegate the selection
            if (self.delegate && [self.delegate respondsToSelector:@selector(leveyPopListView:didSelectedIndex:)]) {
                [self.delegate leveyPopListView:self didSelectedIndex:indexPath.row];
            }
            // dismiss self
            [self fadeOut];
            break;
        }
        case VTRadioListSection:
        {
            if (_selection != indexPath.row) {
                _selection = indexPath.row;
                [_tableView reloadData];
            }
            // tell the delegate the selection
            if (self.delegate && [self.delegate respondsToSelector:@selector(leveyPopListView:didSelectedIndex:)]) {
                [self.delegate leveyPopListView:self didSelectedIndex:_selection];
            }
            // dismiss self
            [self fadeOut];
            break;
        }
        case VTCheckboxListSection:
        {
            // if supprot select all
            if (checkListSelectAllFlag) {
                // if selected is first row 
                if (indexPath.row == 0) {
                    //find if it's from checked to be nonchecked,remove all checks
                    if (_selection & (1<<0)) {
                        for (int i = 0; i < [_options count]; i ++) {
                            if (_selection & (1<<i)) {
                                _selection ^= (1<<i);
                            }
                        }
                    }
                    // if it's from noncheck to be checked, add all checks
                    else {
                        for (int i = 0; i < [_options count]; i ++) {
                            if (!(_selection & (1<<i))) {
                                _selection ^= (1<<i);
                            }
                        }
                    }
                }
                // if selected is not frist row
                if (indexPath.row != 0) {
                    //check if first row is check or not
                    //if check fist row
                    if (_selection & (1<<0))
                    {
                        //if selected is from check to be non check,remove first row 
                        if (_selection & (1<<indexPath.row)) {
                            _selection ^= (1<<0);
                        }
                        _selection ^= (1<<indexPath.row);
                    }
                    // if non check first row
                    else {
                        //if selected is from uncheck to be check,check if all row are checked or not,
                        // if checked, first row should be check to
                        if (!(_selection & (1<<indexPath.row))) {
                            Boolean flag = NO;
                            for (int i = 1; i < [_options count]; i ++) {
                                if (i != indexPath.row) {
                                    flag = _selection & (1<<i);
                                    if (!flag) {
                                        break;
                                    }
                                }
                            }
                            // check first row
                            if (flag) {
                                if (!(_selection & (1<<0))) {
                                    _selection ^= (1<<0);
                                }
                            }
                        }
                        _selection ^= (1<<indexPath.row);
                    }
                }
            }
            else {
                _selection ^= (1 << indexPath.row);
            }
            [_tableView reloadData];
            break;  
        }
        default:
            break;
    }
}


// finish check box selection
-(void) didFinishCheckBoxSelection : (id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(leveyPopListView:didFinishSelectedCheckBox:)]) {
        [self.delegate leveyPopListView:self didFinishSelectedCheckBox:_selection];
    }
    // dismiss self
    [self fadeOut];
}

@end
