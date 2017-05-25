//
//  GMPaymentCell.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 26/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMPaymentWayModal.h"
@interface GMPaymentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *paymentLbl;

@property (weak, nonatomic) IBOutlet GMButton *checkBoxBtn;
@property (weak, nonatomic) IBOutlet UIImageView *paymentImage;
@property (weak, nonatomic) IBOutlet UILabel *topHorizentalSepretorLbl;

@property (weak, nonatomic) IBOutlet UILabel *bottomHorizentalSepretorLbl;

+ (CGFloat) cellHeight;
- (void)configerViewData:(GMPaymentWayModal *)paymentName;

@end
