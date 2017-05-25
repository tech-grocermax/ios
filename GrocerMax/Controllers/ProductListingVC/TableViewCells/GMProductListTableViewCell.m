//
//  GMProductListTableViewCell.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMProductListTableViewCell.h"
#import "GMProductModal.h"
#import "GMCartModal.h"

#define kMAX_Quantity 1000

@interface GMProductListTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomOfferConstraint;
@property (weak, nonatomic) IBOutlet UILabel *promotionalLbl;
//@property (weak, nonatomic) IBOutlet UIButton *viewAllProductButton;

@property (weak, nonatomic) IBOutlet UIView *bgVeiw;

@property (weak, nonatomic) IBOutlet UIImageView *productImgView;

@property (weak, nonatomic) IBOutlet UILabel *productDescriptionLbl;

@property (weak, nonatomic) IBOutlet UILabel *productQuantityLbl;

@property (weak, nonatomic) IBOutlet UILabel *productBrandLabel;

@property (weak, nonatomic) IBOutlet UILabel *productNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *productPackLabel;

@property (weak, nonatomic) IBOutlet UILabel *productOfferLabel;

@property (weak, nonatomic) IBOutlet UIView *cartView;

@property (weak, nonatomic) IBOutlet UILabel *itemsNumberLabel;

@property (strong, nonatomic) GMProductModal *productModal;

@property (nonatomic, strong) GMCartModal *cartModal;

@property (nonatomic, assign) NSUInteger totalProductsInCart;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewSoldout;

@property (weak, nonatomic) IBOutlet UIImageView *offerImg;

@property (weak, nonatomic) IBOutlet UIView *productAddSubView;

@property (nonatomic, assign) NSUInteger quantityValue;

@end

@implementation GMProductListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
//    self.addBtn.layer.cornerRadius = 3.0;
    self.addBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - GETTER/SETTER Methods

- (void)setCartView:(UIView *)cartView {
    
    _cartView = cartView;
    [_cartView setHidden:YES];
}

- (void)setBgVeiw:(UIView *)bgVeiw {
    
    _bgVeiw = bgVeiw;
//    _bgVeiw.layer.cornerRadius = 5.0;
    _bgVeiw.layer.masksToBounds = YES;
//    _bgVeiw.layer.borderWidth = 0.8;
//    _bgVeiw.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.4].CGColor;
}

#pragma mark - Configure Cell

- (void)configureCellWithProductModal:(GMProductModal *)productModal andCartModal:(GMCartModal *)cartModal {
    
    self.productModal = productModal;
    self.cartModal = cartModal;
    self.addBtn.produtModal = productModal;
    self.imgBtn.produtModal = productModal;
    self.viewAllProductButton.produtModal = productModal;
    
    [self.productImgView setImageWithURL:[NSURL URLWithString:self.productModal.image] placeholderImage:[UIImage productPlaceHolderImage]];
    [self.productBrandLabel setText:self.productModal.p_brand.uppercaseString];
    [self.productNameLabel setText:self.productModal.p_name];
    [self.productPackLabel setText:self.productModal.p_pack];
    
    NSDictionary* style1 = @{
                             NSFontAttributeName : FONT_LIGHT(14),
                             NSForegroundColorAttributeName : [UIColor gmRedColor]
                             };
    
    NSDictionary* style2 = @{
                             NSFontAttributeName : FONT_LIGHT(14),
                             NSForegroundColorAttributeName : [UIColor lightGrayColor],
                             NSStrikethroughStyleAttributeName : @1
                             };
    
    NSDictionary* style3 = @{
                             NSFontAttributeName : FONT_LIGHT(14),
                             NSForegroundColorAttributeName : [UIColor lightGrayColor]
                             };
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"₹%@",self.productModal.sale_price] attributes:style1];
    [attString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" | " attributes:style3]];
    [attString appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"₹%@", self.productModal.Price] attributes:style2]];

    [self.productOfferLabel setAttributedText:attString];
    
//    [self.productOfferLabel setText:[NSString stringWithFormat:@"₹%@ | ₹%@", self.productModal.sale_price, self.productModal.Price]];
    
    self.promotionalLbl.text = self.productModal.promotion_level;
    self.quantityValue = self.productModal.productQuantity.integerValue > 0 ? self.productModal.productQuantity.integerValue : 1;
    self.productQuantityLbl.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.quantityValue];
    [self updateTotalProductItemsInCart];
    
    if (self.productModal.promotion_level.length > 1) {
        self.promotionalLbl.hidden = FALSE;
        self.offerImg.hidden = NO;
    }else{
        self.offerImg.hidden = YES;
        self.promotionalLbl.hidden = TRUE;
    }

    if ([self.productModal.Status isEqualToString:@"Sold Out"]) {
        self.imgViewSoldout.hidden = NO;
        self.addBtn.hidden = YES;
        self.productAddSubView.hidden = YES;
    }else{
        self.imgViewSoldout.hidden = YES;
        self.addBtn.hidden = NO;
        self.productAddSubView.hidden = NO;
    }
    
    if (self.productModal.product_count>1) {
        self.bottomOfferConstraint.constant = 42;
        self.viewAllProductButton.hidden = NO;
    }else {
        self.bottomOfferConstraint.constant = -1;
        self.viewAllProductButton.hidden = YES;
    }
    
}

#pragma mark - stepper (+/-) Button Action

- (IBAction)minusBtnPressed:(UIButton *)sender {
    
    if(self.quantityValue > 1) {
        
        self.quantityValue --;
        NSString *productQuantity = [NSString stringWithFormat:@"%lu",(unsigned long)self.quantityValue];
        [self.productQuantityLbl setText:productQuantity];
        [self.productModal setProductQuantity:productQuantity];
    }
}

- (IBAction)pluseBtnPressed:(UIButton *)sender {
    
    self.quantityValue ++;
    NSString *productQuantity = [NSString stringWithFormat:@"%lu",(unsigned long)self.quantityValue];
    [self.productQuantityLbl setText:productQuantity];
    [self.productModal setProductQuantity:productQuantity];
}

- (IBAction)addButtonTapped:(id)sender {
    
    if ([[GMSharedClass sharedClass] isInternetAvailable]) {
        
        if([self isProductAddedIntoCart]) {
            
            NSData *archivedData = [NSKeyedArchiver archivedDataWithRootObject:self.productModal];
            GMProductModal *productCartModal = [NSKeyedUnarchiver unarchiveObjectWithData:archivedData];
            GMCartModal *newCartModal = [GMCartModal loadCart];
            [newCartModal.cartItems addObject:productCartModal];
            [newCartModal archiveCart];
            if([self.delegate respondsToSelector:@selector(addProductModalInCart:)])
                [self.delegate addProductModalInCart:self.productModal];
        }
        else {
            
//            [self.cartModal archiveCart];
            if([self.delegate respondsToSelector:@selector(addProductModalInCart:)])
                [self.delegate addProductModalInCart:self.productModal];
        }
        self.productModal.productQuantity = nil;
        self.quantityValue = 1;
        self.productQuantityLbl.text = @"1";
    }
    else
        if([self.delegate respondsToSelector:@selector(addProductModalInCart:)])
            [self.delegate addProductModalInCart:self.productModal];
}

- (void)updateTotalProductItemsInCart {
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.productid == %@", self.productModal.productid];
    GMCartModal *newCartModal = [GMCartModal loadCart];
    NSArray *totalProducts = [newCartModal.cartItems filteredArrayUsingPredicate:pred];
    if(totalProducts.count ) {
        
        
        int totalItems = 0;
        //    GMCartModal *cartModal = [GMCartModal loadCart];
        
        for (GMProductModal *productModal in totalProducts) {
            
            if([productModal.productid isEqualToString:self.productModal.productid]) {
                totalItems += productModal.productQuantity.intValue;
            }
            
        }
        
        self.totalProductsInCart = totalItems;
        [self.cartView setHidden:NO];
        [self.itemsNumberLabel setText:[NSString stringWithFormat:@"%d", totalItems]];
    }
    else {
        
        self.totalProductsInCart = 0;
        [self.cartView setHidden:YES];
    }
    
    
//    int totalItems = 0;
////    GMCartModal *cartModal = [GMCartModal loadCart];
//    
//    for (GMProductModal *productModal in self.cartModal.cartItems) {
//        
//        if([productModal.productid isEqualToString:self.productModal.productid]) {
//            totalItems += productModal.productQuantity.intValue;
//        }
//        
//    }
//    if(totalItems>0){
//        [self.cartView setHidden:NO];
//        [self.itemsNumberLabel setText:[NSString stringWithFormat:@"%d", totalItems]];
//        self.totalProductsInCart = totalItems;
//    } else {
//        self.totalProductsInCart = 0;
//        [self.cartView setHidden:YES];
//    }
    
}

- (BOOL)isProductAddedIntoCart {
    
    NSUInteger totalQuantity = self.quantityValue;
    totalQuantity += self.totalProductsInCart;
    [self.cartView setHidden:NO];
    [self.itemsNumberLabel setText:[NSString stringWithFormat:@"%ld", (unsigned long)totalQuantity]];
    self.productModal.productQuantity = [NSString stringWithFormat:@"%ld",(unsigned long)totalQuantity];
    self.productModal.addedQuantity = [NSString stringWithFormat:@"%ld",(unsigned long)self.quantityValue];
    self.totalProductsInCart = totalQuantity;
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.productid == %@", self.productModal.productid];
    GMCartModal *newCartModal = [GMCartModal loadCart];
    NSArray *totalProducts = [newCartModal.cartItems filteredArrayUsingPredicate:pred];
    if(totalProducts.count) {
        
        GMProductModal *cartProductModal = [totalProducts firstObject];
        [cartProductModal setProductQuantity:[NSString stringWithFormat:@"%ld", (unsigned long)totalQuantity]];
        [newCartModal archiveCart];
        return NO;
    }
    return YES;
}

#pragma mark - Cell height

+ (CGFloat)cellHeightForNonPromotionalLabel {
    
    return 143.0f;
}

+ (CGFloat)cellHeightForPromotionalLabelWithText:(NSString*)str {
    
    NSDictionary *attributes = @{NSFontAttributeName: FONT_REGULAR(15)};
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(kScreenWidth - 25, MAXFLOAT)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attributes
                                    context:nil];

    return 143 + rect.size.height + 15;
}



@end
