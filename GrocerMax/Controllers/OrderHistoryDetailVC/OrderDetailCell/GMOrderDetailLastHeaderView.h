//
//  GMOrderDetailLastHeaderView.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 26/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMOrderDeatilBaseModal.h"

@interface GMOrderDetailLastHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *subTotalLbl;
@property (weak, nonatomic) IBOutlet UILabel *deliveryChargeLbl;

@property (weak, nonatomic) IBOutlet UILabel *totalCharge;
@property (weak, nonatomic) IBOutlet UILabel *couponcodeTextLbl;
@property (weak, nonatomic) IBOutlet UILabel *couponCode;

- (void) configerViewData:(GMOrderDeatilBaseModal *)orderDeatilBaseModal;

+ (CGFloat)headerHeight;


@end
