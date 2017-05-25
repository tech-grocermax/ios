//
//  GMPaymentOrderSummryCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 27/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMPaymentOrderSummryCell.h"
#import "GMCartModal.h"
#import "GMCoupanCartDetail.h"

@implementation GMPaymentOrderSummryCell

- (void)awakeFromNib {
    // Initialization code
    self.cellBgView.layer.borderWidth = BORDER_WIDTH;
    self.cellBgView.layer.borderColor = BORDER_COLOR;
    self.cellBgView.layer.cornerRadius = CORNER_RADIUS;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) cellHeightWithCartDetail:(GMCartDetailModal *)cartDetailModal andCouponCartDetail:(GMCoupanCartDetail *)coupanCartDetail isWalet:(BOOL)isWalet  {
    
    CGFloat height =  107-68;
    if(isWalet) {
        height = height + 26;
    }
    
    if(coupanCartDetail) {

        if(NSSTRING_HAS_DATA(coupanCartDetail.ShippingCharge) && coupanCartDetail.ShippingCharge.doubleValue != 0) {
            height += 21;
        }
        
        if(NSSTRING_HAS_DATA(coupanCartDetail.you_save)) {
            height += 21;
        }
        
    }else{
        
        double saving = 0;
        double subtotal = 0;
        double couponDiscount = 0;
        
        for (GMProductModal *productModal in cartDetailModal.productItemsArray) {
            
            saving += productModal.productQuantity.doubleValue * (productModal.Price.doubleValue - productModal.sale_price.doubleValue);
            subtotal += productModal.productQuantity.integerValue * productModal.sale_price.doubleValue;
        }
        
        if(NSSTRING_HAS_DATA(cartDetailModal.discountAmount)) {
            saving = saving - cartDetailModal.discountAmount.doubleValue;
            couponDiscount = cartDetailModal.discountAmount.doubleValue;;
        }
        
        double grandTotal = subtotal + cartDetailModal.shippingAmount.doubleValue;
        if(couponDiscount>0.01) {
            grandTotal = grandTotal - couponDiscount;
        } else {
            grandTotal = grandTotal + couponDiscount;
        }
        
        if(NSSTRING_HAS_DATA(cartDetailModal.shippingAmount)  && cartDetailModal.shippingAmount.doubleValue != 0) {
            height += 21;
        }
        
        if(couponDiscount != 0) {
            
            if(NSSTRING_HAS_DATA(cartDetailModal.couponCode)){
                height += 21;
            }
        }
    }
    
    return height;
}

- (void) configerViewData:(GMCartDetailModal *)cartDetailModal coupanCartDetail:(GMCoupanCartDetail *)coupanCartDetail isWalet:(BOOL)isWalet {
    
//    if(cartDetailModal.productItemsArray.count>0) {
//        if(cartDetailModal.productItemsArray.count == 1) {
//            self.totalItemLbl.text = [NSString stringWithFormat:@"%lu item",(unsigned long)cartDetailModal.productItemsArray.count];
//        } else {
//            self.totalItemLbl.text = [NSString stringWithFormat:@"%lu items",(unsigned long)cartDetailModal.productItemsArray.count];
//        }
//        
//    } else {
//        self.totalItemLbl.text = @"";
//    }
    
    if(coupanCartDetail) {
        
//        if(NSSTRING_HAS_DATA(coupanCartDetail.grand_total)) {
//            [self.totalItemPriceLbl setText:[NSString stringWithFormat:@"₹%.2f",coupanCartDetail.grand_total.doubleValue]];
//        } else {
//            [self.totalItemPriceLbl setText:[NSString stringWithFormat:@"₹0.00"]];
//        }
        
        if(NSSTRING_HAS_DATA(coupanCartDetail.subtotal)) {
            self.subTotalPriceLbl.text = [NSString stringWithFormat:@"₹%.2f",coupanCartDetail.subtotal.doubleValue];
        } else {
            self.subTotalPriceLbl.text = [NSString stringWithFormat:@"₹0.00"];
        }
        
        
        if(NSSTRING_HAS_DATA(coupanCartDetail.ShippingCharge) && coupanCartDetail.ShippingCharge.doubleValue != 0) {
            self.shippingPriceLbl.text = [NSString stringWithFormat:@"₹%.2f",coupanCartDetail.ShippingCharge.doubleValue];
            self.shippingChargesLblHeight.constant = 21;
        } else {
            self.shippingPriceLbl.text = @"";
            self.shippingChargesLblHeight.constant = 0;
        }
        
        if(NSSTRING_HAS_DATA(coupanCartDetail.you_save)) {
            self.couponDiscountLbl.text = [NSString stringWithFormat:@"₹-%.2f",coupanCartDetail.you_save.doubleValue];
            self.couponDiscountLblHeight.constant = 21;

        } else {
            self.couponDiscountLbl.text = @"";
            self.couponDiscountLblHeight.constant = 0;
        }
        
    }
    else {
        
        double saving = 0;
        double subtotal = 0;
        double couponDiscount = 0;
        
        for (GMProductModal *productModal in cartDetailModal.productItemsArray) {
            
            saving += productModal.productQuantity.doubleValue * (productModal.Price.doubleValue - productModal.sale_price.doubleValue);
            subtotal += productModal.productQuantity.integerValue * productModal.sale_price.doubleValue;
        }
        if(NSSTRING_HAS_DATA(cartDetailModal.discountAmount)) {
            saving = saving - cartDetailModal.discountAmount.doubleValue;
            couponDiscount = cartDetailModal.discountAmount.doubleValue;;
        }
        
        

        double grandTotal = subtotal + cartDetailModal.shippingAmount.doubleValue;
        if(couponDiscount>0.01) {
            grandTotal = grandTotal - couponDiscount;
        } else {
            grandTotal = grandTotal + couponDiscount;
        }
        
//        [self.subTotalPriceLbl setText:[NSString stringWithFormat:@"₹%.2f", subtotal]];
//        [self.totalItemPriceLbl setText:[NSString stringWithFormat:@"₹%.2f", grandTotal]];
        
        [self.subTotalPriceLbl setText:[NSString stringWithFormat:@"₹%.2f", grandTotal]];
//        [self.totalItemPriceLbl setText:[NSString stringWithFormat:@"₹%.2f", subtotal]];
        
        
        if(NSSTRING_HAS_DATA(cartDetailModal.shippingAmount)  && cartDetailModal.shippingAmount.doubleValue != 0) {
            self.shippingPriceLbl.text = [NSString stringWithFormat:@"₹%.2f",cartDetailModal.shippingAmount.doubleValue];
            self.shippingChargesLblHeight.constant = 21;

        } else {
            self.shippingPriceLbl.text = @"";
            self.shippingChargesLblHeight.constant = 0;
        }
        
        if(couponDiscount != 0) {
            if(NSSTRING_HAS_DATA(cartDetailModal.couponCode)){
                if(couponDiscount<0){
                    couponDiscount = -1*(couponDiscount);
                }
            [self.couponDiscountLbl setText:[NSString stringWithFormat:@"₹%.2f", couponDiscount]];
            self.couponDiscountLblHeight.constant = 21;
            } else {
                [self.couponDiscountLbl setText:@""];
                self.couponDiscountLblHeight.constant = 0;
            }
        } else {
            [self.couponDiscountLbl setText:@""];
            self.couponDiscountLblHeight.constant = 0;
        }
    }
    
}

@end
