//
//  GMPaymentCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 26/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMPaymentCell.h"

@implementation GMPaymentCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) cellHeight {
    return 45.0;
}
- (void)configerViewData:(GMPaymentWayModal *)paymentModal {
    self.bottomHorizentalSepretorLbl.hidden = TRUE;
    self.checkBoxBtn.hidden = FALSE;
    self.checkBoxBtn.paymentWayModal = paymentModal;
    [self.checkBoxBtn setExclusiveTouch:YES];
//    Arvind : PayU
//    if([paymentModal.paymentMethodNameCode isEqualToString:@"paytm_cc"]) {
//        self.paymentImage.hidden = FALSE;
//        self.paymentLbl.hidden = TRUE;
//        [self.paymentImage setImage:[UIImage imageNamed:@"payU"]];
//    } else if([paymentModal.paymentMethodNameCode isEqualToString:@"mobikwik"]) {
//        self.paymentImage.hidden = FALSE;
//        self.paymentLbl.hidden = TRUE;
//        [self.paymentImage setImage:[UIImage imageNamed:@"mobikit"]];
//        
//    }
    if([paymentModal.paymentMethodNameCode isEqualToString:@"wallet"]) {
        self.paymentImage.hidden = TRUE;
        self.paymentLbl.hidden = FALSE;
        
        GMUserModal *userModal = [GMUserModal loggedInUser];
        float balence = 0.00;
        if(NSSTRING_HAS_DATA(userModal.balenceInWallet) && [userModal.balenceInWallet floatValue]>0.01) {
            balence = [userModal.balenceInWallet floatValue];
        } else {
            self.checkBoxBtn.hidden = TRUE;
        }
        NSString *displayName = @"";
        if(NSSTRING_HAS_DATA(paymentModal.paymentMethodDisplayName)) {
            if(NSSTRING_HAS_DATA(paymentModal.paymentMethodDefaultName)) {
                displayName = [NSString stringWithFormat:@"%@ (%@)", paymentModal.paymentMethodDefaultName,paymentModal.paymentMethodDisplayName];
            } else {
                displayName = paymentModal.paymentMethodDisplayName;
            }
        } else {
            if(NSSTRING_HAS_DATA(paymentModal.paymentMethodDefaultName)) {
                displayName = paymentModal.paymentMethodDefaultName;
            }
        }
        NSString *balenceStr = [NSString stringWithFormat:@"%@ (₹%.2f)",displayName,balence];
        self.paymentLbl.text = balenceStr;
        
        
    } else {
        self.paymentImage.hidden = TRUE;
        self.paymentLbl.hidden = FALSE;
        
        NSString *displayName = @"";
//        if(NSSTRING_HAS_DATA(paymentModal.paymentMethodDisplayName)) {
//            displayName = paymentModal.paymentMethodDisplayName;
//        } else {
//            if(NSSTRING_HAS_DATA(paymentModal.paymentMethodDefaultName)) {
//                displayName = paymentModal.paymentMethodDefaultName;
//            }
//        }
        
        if(NSSTRING_HAS_DATA(paymentModal.paymentMethodDisplayName)) {
            if(NSSTRING_HAS_DATA(paymentModal.paymentMethodDefaultName)) {
                displayName = [NSString stringWithFormat:@"%@ (%@)", paymentModal.paymentMethodDefaultName,paymentModal.paymentMethodDisplayName];
            } else {
                displayName = paymentModal.paymentMethodDisplayName;
            }
        } else {
            if(NSSTRING_HAS_DATA(paymentModal.paymentMethodDefaultName)) {
                displayName = paymentModal.paymentMethodDefaultName;
            }
        }
        
            self.paymentLbl.text = displayName;
        
    }
    
    self.checkBoxBtn.tag = [paymentModal.paymentMethodId intValue];
   
}
@end
