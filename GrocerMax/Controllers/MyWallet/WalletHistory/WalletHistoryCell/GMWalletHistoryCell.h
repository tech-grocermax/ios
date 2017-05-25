//
//  GMWalletHistoryCell.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 15/12/15.
//  Copyright © 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GMWalletOrderModal;
@class GMWalletOrderHistoryModal;

@interface GMWalletHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateTimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *commentLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderIdLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;


-(void)configerViewWithData:(GMWalletOrderHistoryModal *)walletOrderModal;

@end
