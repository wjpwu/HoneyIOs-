//
//  VTPopPickTextField.h
//  VitMobile
//
//  Created by Aaron.Wu on 12-11-1.
//
//

#import <Foundation/Foundation.h>
#import "SBTableAlert.h"



@interface VTUILabel  : UILabel

- (id)initHeadLabelWithFrame:(CGRect)frame;
- (id)initAlignRightLabelWithFrame:(CGRect)frame;

@end

@interface VTUITextField : UITextField
{
    UIToolbar *inputAccessoryView;
}
@end



@class VTPopPickTextField;
@protocol VTPopPickTextFieldDelegate <NSObject>

- (void) popPick:(VTPopPickTextField*) pop doFinishTextEditWithPickValue: (id) theValue;

@end

@interface VTPopPickTextField : NSObject <SBTableAlertDelegate, SBTableAlertDataSource, UITextFieldDelegate>

@property (nonatomic, assign) NSString *popPotionDictoryKey;
@property (nonatomic, assign) NSArray *vPopOptionArray;
@property (nonatomic, assign) id<VTPopPickTextFieldDelegate> delegate;
@property (nonatomic, retain) VTUITextField *textField;
@property (nonatomic, assign) NSString *popTitle;

- (id)initWithPopTitle:(NSString*) pTitle textDelegate:(id) pDelegate;
- (void)showSBalert;

@end
