//
//  GMMaxCoinsTableViewCell.m
//  GrocerMax
//
//  Created by Rahul on 7/6/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import "GMMaxCoinsTableViewCell.h"
#import "GMMaxCoinBaseModal.h"

@interface GMMaxCoinsTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *lbl_dateTime;
@property (weak, nonatomic) IBOutlet UILabel *lbl_comment;
@property (weak, nonatomic) IBOutlet UILabel *lbl_couponCode;
@property (weak, nonatomic) IBOutlet UILabel *lbl_couponCodeValue;
@property (weak, nonatomic) IBOutlet UILabel *lbl_redeemPoint;
@property (weak, nonatomic) IBOutlet UILabel *lbl_expiryDate;

@end

@implementation GMMaxCoinsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - 

-(void)configerUI:(id)modal {
    
    GMMaxCoinModal *mdl = modal;
    
    _lbl_dateTime.text = mdl.created_date;
    _lbl_comment.text = mdl.comment;
    
    
    
//    _lbl_couponCode.text = @"Coupon Imported :";
    [self couponCodeText:[mdl.type_action intValue]];
    _lbl_couponCodeValue.text = mdl.coupon_code;
    _lbl_redeemPoint.text = mdl.redeem_point;
    
    if([mdl.coupon_exp_date isEqualToString:@"0000-00-00"]){
        
        _lbl_expiryDate.text = [NSString stringWithFormat:@"Valid Till : N/A"];
        
    }else {
    _lbl_expiryDate.text = [NSString stringWithFormat:@"Valid Till : %@",mdl.coupon_exp_date];
    }
}


-(void)couponCodeText:(int)actionType {
    
    NSString * coupoCodeTitle = @"";
    switch (actionType) {
            
        case 0:
            coupoCodeTitle = @"Coupon Modified :";
            break;
        case 1:
            coupoCodeTitle = @"Coupon Used :";
            break;
        case 2:
            coupoCodeTitle = @"Coupon Refunded :";
            break;
        case 3:
            coupoCodeTitle = @"Coupon Modified :";
            break;
        case 4:
            coupoCodeTitle = @"Coupon Canceled :";
            break;
        case 5:
            coupoCodeTitle = @"Coupon Modified by Credit Product :";
            break;
        case 6:
            coupoCodeTitle = @"Coupon Added :";
            break;
        case 7:
            coupoCodeTitle = @"Coupon Decreased :";
            break;
        case 8:
            coupoCodeTitle = @"Coupon Imported :";
            break;
        case 9:
            coupoCodeTitle = @"Coupon Expired :";
            break;
        case 10:
            coupoCodeTitle = @"Coupon API :";
            break;
        case 11:
            coupoCodeTitle = @"Coupon";
            break;
            
            
        default:
            coupoCodeTitle = @"Coupon Imported :";
            break;
    }
    
    _lbl_couponCode.text = coupoCodeTitle;
}



@end
