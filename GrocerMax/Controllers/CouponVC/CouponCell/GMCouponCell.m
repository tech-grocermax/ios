//
//  GMCouponCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 02/07/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import "GMCouponCell.h"

@implementation GMCouponCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.couponCodeBtn.layer.cornerRadius = 5.0;
    self.couponCodeBtn.layer.masksToBounds = YES;
//    self.couponCodeBtn.layer.borderWidth = 0.8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    // Configure the view for the selected state
}


-(void)configerUI:(GMCouponModal *)couponModal {
    
    self.couponCodeBtn.couponModal = couponModal;
    self.viewTermsAndConditionBtn.couponModal = couponModal;
    
    self.couponCodeBtn.backgroundColor = [UIColor colorFromHexString:@"479947"];
    
    if(NSSTRING_HAS_DATA(couponModal.couponCode)){
        if(couponModal.isApply) {
            
            self.couponCodeBtn.backgroundColor = [UIColor blackColor];
            [self.couponCodeBtn setTitle:[NSString stringWithFormat:@"%@ - CANCEL",couponModal.couponCode] forState:UIControlStateNormal];
            
        }else {
            [self.couponCodeBtn setTitle:[NSString stringWithFormat:@"%@ - APPLY",couponModal.couponCode] forState:UIControlStateNormal];
        }
    }else{
        [self.couponCodeBtn setTitle:@"" forState:UIControlStateNormal];
    }
    
    if(NSSTRING_HAS_DATA(couponModal.couponName)){
        self.couponNameLbl.text = couponModal.couponName;
    }else{
        self.couponNameLbl.text = @"";
    }
    
    if(NSSTRING_HAS_DATA(couponModal.couponDescription)){
        
        self.termAndConditionBtnHeightlayoutConstraints.constant = 20;// show
        if(couponModal.isViewTermAndCondition){
            self.couponDescriptionLbl.text = couponModal.couponDescription;

        }else {
            self.couponDescriptionLbl.text = @"";
        }
    }else{
        self.couponDescriptionLbl.text = @"";
        self.termAndConditionBtnHeightlayoutConstraints.constant = 0;// hide
    }
    
    if(NSSTRING_HAS_DATA(couponModal.couponValidDate)){
        self.couponValidDateLbl.text = couponModal.couponValidDate;
    }else{
        self.couponValidDateLbl.text = @"";
    }
    
}

+ (CGFloat)cellHeightFor:(GMCouponModal *)couponModal {
    
    CGFloat height = 0;
    height += 8;// top space
    height += 30;// coupon button
    height += 1;// top ofcoupon name lbl
    
    // coupon name lbl height
    if(NSSTRING_HAS_DATA(couponModal.couponName)){
        height += [couponModal.couponName  boundingRectWithSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: FONT_LIGHT(15)} context:nil].size.height;
    }
    
    if(NSSTRING_HAS_DATA(couponModal.couponDescription)){
        
        // T&C btn height
        height += 20;// show
        
        if(couponModal.isViewTermAndCondition){
        
            //description lbl height
            height += [couponModal.couponDescription  boundingRectWithSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: FONT_LIGHT(15)} context:nil].size.height;
        }
    }
    
    
    // coupon valid date lbl height
    if(NSSTRING_HAS_DATA(couponModal.couponValidDate)){
        height += [couponModal.couponValidDate  boundingRectWithSize:CGSizeMake(kScreenWidth - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: FONT_LIGHT(15)} context:nil].size.height;
    }
    
    height += 8;// Bottom space

    
    return height;
}
@end
