//
//  GMAddressCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 19/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMAddressCell.h"

@implementation GMAddressCell

#pragma mark - GETTER/SETTER Methods

- (void)setCellBgView:(UIView *)cellBgView {
    
    _cellBgView = cellBgView;
    _cellBgView.layer.cornerRadius = 5.0;
    _cellBgView.layer.masksToBounds = YES;
    _cellBgView.layer.borderWidth = 0.8;
    _cellBgView.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
}

- (void)setEditAddressBtn:(GMButton *)editAddressBtn {
    
    _editAddressBtn = editAddressBtn;
    [_editAddressBtn setExclusiveTouch:YES];
}

- (void)setSelectUnSelectBtn:(GMButton *)selectUnSelectBtn {
    
    _selectUnSelectBtn = selectUnSelectBtn;
    [_selectUnSelectBtn setExclusiveTouch:YES];
}

- (void)configerViewWithData:(id)modal {
    
    GMAddressModalData *addressModalData = (GMAddressModalData *)modal;
    self.selectUnSelectBtn.addressModal = addressModalData;
    self.editAddressBtn.addressModal = addressModalData;
    
    NSString *mainStrign= @"";
    NSString *str1 = @"";
    
    self.addressLbl.numberOfLines = 3;
    mainStrign = [NSString stringWithFormat:@"%@",str1];
    
    if(NSSTRING_HAS_DATA(addressModalData.street)) {
        
        NSString *str2 = addressModalData.street;
        self.addressLbl.text = str2;
    }
    else
         self.addressLbl.text = @"";
    
//        mainStrign = [NSString stringWithFormat:@"%@\n%@",mainStrign,str2];
//   
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:mainStrign];
//    
//    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor darkGrayColor]} range:[mainStrign rangeOfString:str2]];
//    
//    
//    
//    [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} range:[mainStrign rangeOfString:str2]];
//    
//    
//    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} range:[mainStrign rangeOfString:str1]];
//    
//    [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} range:[mainStrign rangeOfString:str1]];
    
    
    
}

+ (CGFloat)cellHeight {
    
    return 116.0f;
}
@end
