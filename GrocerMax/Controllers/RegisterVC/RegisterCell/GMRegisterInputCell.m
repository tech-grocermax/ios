//
//  GMRegisterInputCell.m
//  GrocerMax
//
//  Created by Deepak Soni on 16/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMRegisterInputCell.h"

@implementation GMRegisterInputCell

- (void)setInputTextField:(UITextField *)inputTextField {
    
    _inputTextField = inputTextField;
    _inputTextField.rightViewMode = UITextFieldViewModeUnlessEditing;
    [_inputTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
}

- (void)setStatusType:(StatusType)statusType{
   
    _statusType = statusType;
    if (_statusType == kInvalid || _statusType == kBlank)
        _inputTextField.textColor = [UIColor inputTextFieldWarningColor];
    else
        _inputTextField.textColor = [UIColor inputTextFieldColor];
    
    _inputTextField.rightView = [self imageView];
}

- (UIImageView*)imageView {
    
    UIImage* image ;
    switch (_statusType) {
        case kValid:
            image =  [UIImage validInputFieldImage];
            break;
        case kInvalid:
        case kBlank:
            image =  [UIImage inValidInputFieldImage];
            break;
        case kNone:
            break;
        default:
            break;
    }
    return  [[UIImageView alloc] initWithImage:image];
}

+ (CGFloat)cellHeight {
    
    return 57.0f;
}

@end
