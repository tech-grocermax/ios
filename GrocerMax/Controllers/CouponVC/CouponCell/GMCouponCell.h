//
//  GMCouponCell.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 02/07/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMCouponModal.h"

@interface GMCouponCell : UITableViewCell

@property (strong, nonatomic) IBOutlet GMButton *couponCodeBtn;
@property (strong, nonatomic) IBOutlet UILabel *couponNameLbl;
@property (strong, nonatomic) IBOutlet GMButton *viewTermsAndConditionBtn;
@property (strong, nonatomic) IBOutlet UILabel *couponDescriptionLbl;
@property (strong, nonatomic) IBOutlet UILabel *couponValidDateLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *termAndConditionBtnHeightlayoutConstraints;

-(void)configerUI:(GMCouponModal *)couponModal;

+ (CGFloat)cellHeightFor:(GMCouponModal *)couponModal;

@end
