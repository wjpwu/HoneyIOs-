//
//  PopListDataPickerTableCell.m
//  VitMobile
//
//  Created by Aaron.Wu on 12-7-31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PopListDataPickerTableCell.h"

@implementation PopListDataPickerTableCell
@synthesize _vPopOptionArray,_popPotionDictoryKey;


- (void) initalizeInput
{
    _vSelection = - 1;
}
- (id)initWithWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initDefaultStyleWithReuseIdentifier:reuseIdentifier];
    if (self) {
        [self initalizeInput];
    }
    return self;
}

- (id)initWithWithReuseIdentifier:(NSString *)reuseIdentifier popOption: (NSString*) anPopOptions
{
    self = [super initDefaultStyleWithReuseIdentifier:reuseIdentifier];
    if (self) {
        _popPotionDictoryKey = anPopOptions;
        [self initalizeInput];
    }
    return self;
}

- (void)set_popPotionDictoryKey:(NSString *)anpopPotionDictoryKey
{
    _popPotionDictoryKey = anpopPotionDictoryKey;
}


- (NSArray*) _vPopOptionArray
{
    if (_popPotionDictoryKey) {
        _vPopOptionArray = [VTPopOptions getPopList:_popPotionDictoryKey];
    }
    return _vPopOptionArray;
}

- (void)set_vPopOptionArray:(NSArray *)_tvPopOptionArray
{
    _vPopOptionArray = _tvPopOptionArray;
}

- (VTPopListView*) _vPopList
{
    _vPopList = [VTPopListView getRadioPopListwithtitle:self.textLabel.text options:self._vPopOptionArray :_vSelection];
//    _vPopList = [[VTPopListView alloc] initWithTitle:self.textLabel.text options:self._vPopOptionArray :VTRadioListSection selection:_vSelection];
    _vPopList.delegate = self;
    return _vPopList;
}

//#pragma mark set pop view selection
- (void)reloadPopList
{
    _vSelection = -1;
}

- (void)setPopListSelection:(NSInteger)anSelection
{
    _vSelection = anSelection;
    [self._vPopList reloadPopListWithSelection:_vSelection];
}

- (BOOL)becomeFirstResponder {
	[self._vPopList showInMainWindowWithAnimated:YES];
	return [super becomeFirstResponder];
}


#pragma mark vitpop view delaget
-(void)leveyPopListView:(LeveyPopListView *)popListView didSelectedIndex:(NSInteger)anIndex
{
    debug_NSLog(@"pop radio cell.tag %d", self.tag);
    _vSelection = anIndex;
    if ([[self._vPopOptionArray objectAtIndex:anIndex] isKindOfClass:[NSString class]]) {
        self._displayLabel.text = [self._vPopOptionArray objectAtIndex:anIndex];
    }
    else {
        self._displayLabel.text = [[self._vPopOptionArray objectAtIndex:anIndex] objectForKey:@"text"];
    }
    [self.modeObject setObject:self._displayLabel.text forKey:@"CK_Value"];
    if (self.vitDelegate && [self.vitDelegate respondsToSelector:@selector(tableViewCell:didEndEditingWithPickedValue:)]) 
    {
        
//        NSLog(@"%@,%@",[[self._vPopOptionArray allValues] objectAtIndex:anIndex],[[self._vPopOptionArray allKeys] objectAtIndex:anIndex]);
        [self.vitDelegate tableViewCell:self didEndEditingWithPickedValue:[self._vPopOptionArray objectAtIndex:anIndex]];
    }
}

- (void)setModeObject:(NSMutableDictionary *)theModeObject
{
    modeObject = theModeObject;
    if ([theModeObject objectForKey:@"CK_Value"]) {
        self._displayLabel.text = [theModeObject objectForKey:@"CK_Value"];
    }
}

- (void) setDisplay : (NSString*) hostcode
{
    self._displayLabel.text = [[VTPopOptions getOptionDictionaryWithHostCode:hostcode arrayKey:self._popPotionDictoryKey] objectForKey:@"text"];;
}
@end
