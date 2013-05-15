//
//  PopListDataMultiplePickerTableCell.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-8-1.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PopListDataMultiplePickerTableCell.h"

@implementation PopListDataMultiplePickerTableCell
@synthesize _vPopOptionDictionary;


- (void) initalizeInput
{
    _vSelection = 0;
}


- (id)initWithWithReuseIdentifier:(NSString *)reuseIdentifier popOptions: (NSString *) anPopOptions;
{
    return [self initWithWithReuseIdentifier:reuseIdentifier popOptions:anPopOptions :NO];
}

- (id) initWithWithReuseIdentifier:(NSString *)reuseIdentifier popOptions: (NSString *) anPopOptions : (Boolean) supportSelectAllFlag{
    self = [super initDefaultStyleWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initalizeInput];
        _popPotionDictoryKey = anPopOptions;
        _vPopOptionDictionary = [VTPopOptions getPopList:_popPotionDictoryKey];
        _supportSelectAllFlag = supportSelectAllFlag;
        
        if (_supportSelectAllFlag && [self._vPopOptionDictionary count] <= 2) {
            if (self._vPopOptionDictionary == nil || [self._vPopOptionDictionary count] <= 0){
                @throw [NSException exceptionWithName: @"PopViewException"
                                               reason: @"select all check box list size should more than 2!"
                                             userInfo: nil];
            }
        }
        else if ([self._vPopOptionDictionary count] <= 0){
            @throw [NSException exceptionWithName: @"PopViewException"
                                           reason: @"check box list size should more than 0!"
                                         userInfo: nil];
        }
    }
    return self;
}


- (VTPopListView*) _vPopList
{
    if (!_vPopList) {
        
        _vPopList = [[VTPopListView alloc] initWithTitle:self.textLabel.text options:self._vPopOptionDictionary :VTCheckboxListSection selection:_vSelection];
        _vPopList.delegate = self;
        _vPopList.checkListSelectAllFlag = _supportSelectAllFlag;
    }
    return _vPopList;
}

-(void)setPopListSelection:(NSInteger)anSelection
{
    _vSelection = anSelection;
    [self._vPopList reloadPopListWithSelection:_vSelection];
}


- (BOOL)becomeFirstResponder {
	[self._vPopList showInMainWindowWithAnimated:YES];
	return [super becomeFirstResponder];
}


#pragma mark vitpop view delaget
-(void)leveyPopListView:(LeveyPopListView *)popListView didFinishSelectedCheckBox:(NSUInteger)anSelection
{
    _vSelection = anSelection;
    NSMutableArray *dictAry = [NSMutableArray array];
    NSMutableString *pickValus = [[NSMutableString alloc] init];
    //if it's select all, return only first row
    if (_supportSelectAllFlag && (_vSelection & (1 << 0))) {
        
        [dictAry addObject: [self._vPopOptionDictionary objectAtIndex:0]];
        [pickValus appendString: [[self._vPopOptionDictionary objectAtIndex:0] objectForKey:@"text"]];

    }
    else {
        for (int i = 0; i < [self._vPopOptionDictionary count]; i++) {
            int flag = (1 << i);
            if (_vSelection & flag)
            {
                [dictAry addObject:[self._vPopOptionDictionary objectAtIndex:i]];
                [pickValus appendString:[[self._vPopOptionDictionary objectAtIndex:i] objectAtIndex:i]];
            }
        }
    }
    self._displayLabel.text = pickValus;
    [self.modeObject setObject:self._displayLabel.text forKey:@"CK_Value"];
    if (self.vitDelegate && [self.vitDelegate respondsToSelector:@selector(tableViewCell:didEndEditingWithMultiplePickedValues:)]) {
        [self.vitDelegate tableViewCell:self didEndEditingWithMultiplePickedValues:dictAry];
    }
}

- (void)setModeObject:(NSMutableDictionary *)theModeObject
{
    modeObject = theModeObject;
    if ([theModeObject objectForKey:@"CK_Value"]) {
        self._displayLabel.text = [theModeObject objectForKey:@"CK_Value"];
    }
}
@end
