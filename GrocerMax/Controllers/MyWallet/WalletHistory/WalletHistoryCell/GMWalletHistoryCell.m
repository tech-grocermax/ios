//
//  GMWalletHistoryCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 15/12/15.
//  Copyright © 2015 Deepak Soni. All rights reserved.
//

#import "GMWalletHistoryCell.h"
#import "GMWalletOrderModal.h"

@implementation GMWalletHistoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)configerViewWithData:(GMWalletOrderHistoryModal *)walletOrderHistoryModal {
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(NSSTRING_HAS_DATA(walletOrderHistoryModal.walletDate)) {
        self.dateTimeLbl.text = walletOrderHistoryModal.walletDate;
    } else {
        self.dateTimeLbl.text = @"";
    }
    if(NSSTRING_HAS_DATA(walletOrderHistoryModal.walletComment)) {
        self.commentLbl.text = walletOrderHistoryModal.walletComment;
    } else {
        self.commentLbl.text = @"";
    }
    if(NSSTRING_HAS_DATA(walletOrderHistoryModal.walletOrderId)) {
        self.orderIdLbl.text = [NSString stringWithFormat:@"Order id %@",walletOrderHistoryModal.walletOrderId]; ;
    } else {
        self.orderIdLbl.text = @"";
    }
    
    if(NSSTRING_HAS_DATA(walletOrderHistoryModal.walletAmount)) {
        self.priceLbl.text = walletOrderHistoryModal.walletAmount;
    } else {
        self.priceLbl.text = @"";
    }
        
        
    
    
}
@end
