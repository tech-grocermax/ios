//
//  GMTOfferListCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 19/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMCartCell.h"

@interface GMCartCell()

@property (nonatomic, strong) GMProductModal *productModal;

@property (nonatomic, assign) NSUInteger quantityValue;

@property (weak, nonatomic) IBOutlet UILabel *zeroPriceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewSoldout;

@property (weak, nonatomic) IBOutlet UIImageView *offerImg;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftLyaoutConstraint;

@end

NSString * const kFreePromotionString = @"Please remove item from cart to proceed.";

@implementation GMCartCell

- (void)awakeFromNib {
    // Initialization code
    
    [self setBackgroundColor:[UIColor colorWithRed:244.0/256.0 green:244.0/256.0 blue:244.0/256.0 alpha:1]];
    _savingPrice.layer.cornerRadius = 10.0;
    _savingPrice.layer.masksToBounds = YES;
    
}

- (void)setCellBgView:(UIView *)cellBgView {
    
    _cellBgView = cellBgView;
    _cellBgView.layer.masksToBounds = YES;

}

#pragma mark - GETTER/SETTER Methods

- (void)setProductListImageView:(UIImageView *)productListImageView {
    
    _productListImageView = productListImageView;
}

- (void)configureViewWithProductModal:(GMProductModal *)productModal {
    
    self.deleteButton.produtModal = productModal;
    self.productModal = productModal;
    [self.productListImageView setImageWithURL:[NSURL URLWithString:self.productModal.image] placeholderImage:[UIImage imageNamed:@"STAPLE"]];
    [self.titleLbl setText:self.productModal.p_brand.uppercaseString];
    [self.subTitleLbl setText:self.productModal.p_name];
//    [self.quantityLbl setText:self.productModal.p_pack];
    
    
    NSDictionary* style1 = @{
                             NSFontAttributeName : FONT_LIGHT(14),
                             NSForegroundColorAttributeName : [UIColor gmRedColor]
                             };
    
    NSDictionary* style2 = @{
                             NSFontAttributeName : FONT_LIGHT(14),
                             NSForegroundColorAttributeName : [UIColor gmGrayColor],
                             NSStrikethroughStyleAttributeName : @1
                             };
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ x ₹%ld | ", self.productModal.productQuantity, (long)self.productModal.sale_price.integerValue] attributes:style1];
    [attString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"₹%ld", (long)self.productModal.Price.integerValue] attributes:style2]];
    
    [self.priceWithOfferLbl setAttributedText:attString];
    
    [self.addSubstractLbl setText:self.productModal.productQuantity];
    self.quantityValue = self.productModal.productQuantity.integerValue;
    [self.promotionLabel setText:self.productModal.promotion_level];
    if(NSSTRING_HAS_DATA(self.productModal.promotion_level)){
        [self.promotionLabel setHidden:NO];
        [self.bellImageView setHidden:NO];
    }
    else {
        [self.promotionLabel setHidden:YES];
        [self.bellImageView setHidden:YES];
    }
    
    
    
    if ([self.productModal.Status isEqualToString:@"0"] && [self.productModal.noOfItemInStock intValue]<1) {
        self.imgViewSoldout.hidden = NO;
        self.addSubstractView.hidden = YES;
        [self.promotionLabel setText:kFreePromotionString];
        self.zeroPriceLabel.hidden = YES;
        [self.promotionLabel setHidden:NO];
        [self.bellImageView setHidden:NO];
        self.outOfStockLabel.hidden = YES;
    }else if ([self.productModal.Status isEqualToString:@"0"] && [self.productModal.noOfItemInStock intValue]>0){
        self.imgViewSoldout.hidden = YES;
        self.addSubstractView.hidden = NO;
        self.zeroPriceLabel.hidden = NO;
        self.outOfStockLabel.hidden = NO;
        self.outOfStockLabel.text =[NSString stringWithFormat:@"ONLY %@ IN STOCK. PLEASE REDUCE THE QUANTITY.",self.productModal.noOfItemInStock];
    }else{
        self.imgViewSoldout.hidden = YES;
        self.addSubstractView.hidden = NO;
        self.zeroPriceLabel.hidden = NO;
        self.outOfStockLabel.hidden = YES;
//        [self.promotionLabel setHidden:YES];
    }
    
    
   
    
    if (self.productModal.promotion_level.length > 1 && self.productModal.sale_price.integerValue == 0) {
        self.offerImg.hidden = NO;
        [self.offerImg setImage:[UIImage freeImage]];
    }
    else if (self.productModal.promotion_level.length > 1 && self.productModal.sale_price.integerValue != 0) {
        self.offerImg.hidden = NO;
        [self.offerImg setImage:[UIImage offerImage]];
    }
    else if (self.productModal.sale_price.integerValue == 0 ) {
        self.offerImg.hidden = NO;
        [self.offerImg setImage:[UIImage freeImage]];
    }
    else {
        self.offerImg.hidden = YES;
    }
    [self updatePriceLabel];
    
}

- (void)updatePriceLabel {
    
    double totalPrice = self.productModal.sale_price.doubleValue * self.productModal.productQuantity.integerValue;
    
    if (totalPrice > 0) {
        [self.priceLbl setText:[NSString stringWithFormat:@"₹%.2f", totalPrice]];
    }else{
        [self.priceLbl setText:[NSString stringWithFormat:@""]];
    }
    
//    NSString *priceQuantityStr = [NSString stringWithFormat:@"%@ x ₹%ld | ₹%ld", self.productModal.productQuantity, (long)self.productModal.sale_price.integerValue, (long)self.productModal.Price.integerValue];
//    [self.priceWithOfferLbl setText:priceQuantityStr];
    
    NSDictionary* style1 = @{
                             NSFontAttributeName : FONT_MEDIUM(12),
                             NSForegroundColorAttributeName : [UIColor blackColor]
                             };
    
    NSDictionary* style2 = @{
                             NSFontAttributeName : FONT_LIGHT(14),
                             NSForegroundColorAttributeName : [UIColor gmGrayColor],
                             NSStrikethroughStyleAttributeName : @1
                             };
    
//    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ x ₹%ld | ", self.productModal.productQuantity, (long)self.productModal.sale_price.integerValue] attributes:style1];
    
     NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ | ₹%ld | ", self.productModal.p_pack, (long)self.productModal.sale_price.integerValue] attributes:style1];
    
    [attString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"₹%ld", (long)self.productModal.Price.integerValue] attributes:style2]];
    
    
//    [self.quantityLbl setText:self.productModal.p_pack];

      [self.quantityLbl setAttributedText:attString];
//    [self.priceWithOfferLbl setAttributedText:attString];
    
    if([self.productModal.productQuantity intValue]>0) {
        self.priceWithOfferLbl.text = [NSString stringWithFormat:@"%@ @ ₹%.2f",self.productModal.productQuantity,(totalPrice/[self.productModal.productQuantity intValue])];
    }else {
        self.priceWithOfferLbl.text = @"";
    }
    
//    self.leftLyaoutConstraint.constant = 75;
    self.savingPrice.backgroundColor = [UIColor colorFromHexString:@"#379136"];
    self.savingPrice.textColor = [UIColor whiteColor];
    [self.savingPrice setFont:FONT_MEDIUM(7)];
    self.zeroPriceLabel.textColor = [UIColor blackColor];
    
    if([self.productModal.Price integerValue]>0){
        double saving = 0.0;
        if(NSSTRING_HAS_DATA(self.productModal.row_total)){
            
            int newAddedItem = 0;
            if(NSSTRING_HAS_DATA(self.productModal.extraQuantityAddedOnCart)) {
                newAddedItem = [self.productModal.extraQuantityAddedOnCart intValue];
            }
            saving = [self.productModal.Price doubleValue]*([self.productModal.productQuantity intValue]-newAddedItem) - [self.productModal.row_total doubleValue] ;
        }else {
            saving = [self.productModal.Price doubleValue]*[self.productModal.productQuantity intValue] - totalPrice ;
        }
//        if(saving<0){
//            saving = [self.productModal.Price doubleValue]*[self.productModal.productQuantity intValue] - totalPrice ;
//        }
        
        self.savingPrice.text = [NSString stringWithFormat:@"SAVING ₹%.2f",saving];
        self.savingPrice.hidden = FALSE;
    }else {
        self.savingPrice.text = @"";
        self.savingPrice.hidden = TRUE;
    }
    
    if (self.productModal.sale_price.integerValue == 0 ) {
        self.zeroPriceLabel.textColor = [UIColor redColor];
        self.savingPrice.textColor = [UIColor redColor];
        self.savingPrice.backgroundColor = [UIColor colorFromHexString:@"#FFCF06"];
        self.savingPrice.text = [NSString stringWithFormat:@"Free Item"];
        [self.savingPrice setFont:FONT_MEDIUM(10)];
//        self.leftLyaoutConstraint.constant = 50;
    }

//    379136
    if(self.productModal.sale_price.integerValue == 0) {
        
        [self.addSubstractView setHidden:YES];
        [self.deleteButton setHidden:YES];
        [self.zeroPriceLabel setHidden:NO];
        [self.zeroPriceLabel setText:self.productModal.productQuantity];
    }
    else {
        
        [self.addSubstractView setHidden:NO];
        [self.deleteButton setHidden:NO];
        [self.zeroPriceLabel setHidden:YES];
    }

    if ([self.productModal.Status isEqualToString:@"0"] && [self.productModal.noOfItemInStock intValue]<1) {
        self.imgViewSoldout.hidden = NO;
        self.addSubstractView.hidden = YES;
        [self.promotionLabel setText:kFreePromotionString];
        self.zeroPriceLabel.hidden = YES;
        [self.promotionLabel setHidden:NO];
        [self.bellImageView setHidden:NO];
        self.outOfStockLabel.hidden = YES;
    }else if ([self.productModal.Status isEqualToString:@"0"] && [self.productModal.noOfItemInStock intValue]>0){
        [self.promotionLabel setHidden:YES];
        [self.bellImageView setHidden:YES];
        self.imgViewSoldout.hidden = YES;
        self.addSubstractView.hidden = NO;
        self.zeroPriceLabel.hidden = NO;
        self.outOfStockLabel.hidden = NO;
        self.outOfStockLabel.text =[NSString stringWithFormat:@"ONLY %@ IN STOCK. PLEASE REDUCE THE QUANTITY.",self.productModal.noOfItemInStock];
        
        if(self.productModal.sale_price.integerValue == 0) {
            
            [self.addSubstractView setHidden:YES];
            [self.deleteButton setHidden:YES];
            [self.zeroPriceLabel setHidden:NO];
            [self.zeroPriceLabel setText:self.productModal.productQuantity];
            self.outOfStockLabel.hidden = YES;
            [self.promotionLabel setHidden:NO];
            [self.bellImageView setHidden:NO];
        }
        else {
            
            [self.addSubstractView setHidden:NO];
            [self.deleteButton setHidden:NO];
            [self.zeroPriceLabel setHidden:YES];
            self.outOfStockLabel.hidden = NO;
            [self.promotionLabel setHidden:YES];
            [self.bellImageView setHidden:YES];
        }
    }else{
        self.imgViewSoldout.hidden = YES;
        self.addSubstractView.hidden = NO;
        self.zeroPriceLabel.hidden = NO;
        self.outOfStockLabel.hidden = YES;
//        [self.promotionLabel setHidden:YES];
        
        if(self.productModal.sale_price.integerValue == 0) {
            
            [self.addSubstractView setHidden:YES];
            [self.deleteButton setHidden:YES];
            [self.zeroPriceLabel setHidden:NO];
            [self.zeroPriceLabel setText:self.productModal.productQuantity];
        }
        else {
            
            [self.addSubstractView setHidden:NO];
            [self.deleteButton setHidden:NO];
            [self.zeroPriceLabel setHidden:YES];
        }
    }

}

- (IBAction)actionSubstractProduct:(UIButton *)sender {
    
    if(self.quantityValue > 1) {
        
        if(NSSTRING_HAS_DATA(self.productModal.extraQuantityAddedOnCart)) {
            NSString *newAddedCount = [NSString stringWithFormat:@"%d",[self.productModal.extraQuantityAddedOnCart intValue]-1];
            [self.productModal setExtraQuantityAddedOnCart:newAddedCount];
        }else {
            [self.productModal setExtraQuantityAddedOnCart:@"-1"];
        }
        
        
        self.quantityValue --;
        NSString *productQuantity = [NSString stringWithFormat:@"%lu",(unsigned long)self.quantityValue];
        [self.addSubstractLbl setText:productQuantity];
        [self.productModal setProductQuantity:productQuantity];
        [self updatePriceLabel];
        if([self.delegate respondsToSelector:@selector(productQuantityValueChanged)])
            [self.delegate productQuantityValueChanged];
    }
}

- (IBAction)actionAddProduct:(UIButton *)sender {
    
    self.quantityValue ++;
    NSString *productQuantity = [NSString stringWithFormat:@"%lu",(unsigned long)self.quantityValue];
    if(NSSTRING_HAS_DATA(self.productModal.extraQuantityAddedOnCart)) {
        NSString *newAddedCount = [NSString stringWithFormat:@"%d",[self.productModal.extraQuantityAddedOnCart intValue]+1];
    [self.productModal setExtraQuantityAddedOnCart:newAddedCount];
    }else {
        [self.productModal setExtraQuantityAddedOnCart:@"1"];
    }
    [self.addSubstractLbl setText:productQuantity];
    [self.productModal setProductQuantity:productQuantity];
    [self updatePriceLabel];
    if([self.delegate respondsToSelector:@selector(productQuantityValueChanged)])
        [self.delegate productQuantityValueChanged];
}

+ (CGFloat)cellHeightWithNoPromotion {
    
    return 120.0;
}

+ (CGFloat)cellHeightForPromotionalLabelWithText:(NSString*)str {
    
    NSDictionary *attributes = @{NSFontAttributeName: FONT_LIGHT(15)};
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(kScreenWidth - 15, MAXFLOAT)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attributes
                                    context:nil];
    
    return 120 + rect.size.height + 5;
}

@end
