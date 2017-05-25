//
//  GMSoldOutItemCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 03/07/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import "GMSoldOutItemCell.h"

@implementation GMSoldOutItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.removeBtn.layer.cornerRadius = 10.0;
    self.removeBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Configure the view for the selected state
}


-(void)configerUIForSoldOutWithData:(GMProductModal *)productModal{
    
    self.removeBtn.produtModal = productModal;
    if(NSSTRING_HAS_DATA(productModal.name)){
        self.productNameLbl.text = [NSString stringWithFormat:@"1. %@",productModal.name];
    }else {
       self.productNameLbl.text = @"";
    }
    
    self.soldoutLbl.textColor = [UIColor redColor];
    self.soldoutLbl.text = @"SOLD OUT";
    self.removeBtn.hidden = FALSE;
    self.addSubtractView.hidden = TRUE;
    
    self.removeBtn.backgroundColor = [UIColor blackColor];
    [self.removeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.removeBtn setTitle:@"Remove" forState:UIControlStateNormal];
    
    if(productModal.isDeleted) {
        self.removeBtn.backgroundColor = [UIColor clearColor];
        [self.removeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.removeBtn setTitle:@"Removed" forState:UIControlStateNormal];
    }
    
}

-(void)configerUIForOutOfStokWithData:(GMProductModal *)productModal{
    
    self.substractBtn.produtModal = productModal;
    self.addBtn.produtModal = productModal;
    
    if(NSSTRING_HAS_DATA(productModal.name)){
        self.productNameLbl.text = [NSString stringWithFormat:@"1. %@",productModal.name];
    }else {
        self.productNameLbl.text = @"";
    }
    self.soldoutLbl.textColor = [UIColor blueColor];
    
    if(NSSTRING_HAS_DATA(productModal.noOfItemInStock)){
        self.soldoutLbl.text =[NSString stringWithFormat:@"AVAILABLE QTY. %@",productModal.noOfItemInStock];
    }else {
        self.soldoutLbl.text =[NSString stringWithFormat:@"AVAILABLE QTY. 0"];
    }
    
    NSUInteger quantityValue = productModal.productQuantity.integerValue;
    [self.addSubstractLbl setText:[NSString stringWithFormat:@"%lu",(unsigned long)quantityValue]];

    self.removeBtn.hidden = TRUE;
    self.addSubtractView.hidden = FALSE;
    
}

- (IBAction)actionAddProduct:(GMButton *)sender {
    NSUInteger quantityValue = sender.produtModal.productQuantity.integerValue;
    quantityValue ++;
    
    NSString *productQuantity = [NSString stringWithFormat:@"%lu",(unsigned long)quantityValue];
    [self.addSubstractLbl setText:productQuantity];
    [sender.produtModal setProductQuantity:productQuantity];
//    if([self.delegate respondsToSelector:@selector(productQuantityValueChanged)])
//        [self.delegate productQuantityValueChanged];
    if([self.delegate respondsToSelector:@selector(productQuantityValueReduce)])
        [self.delegate productQuantityValueReduce];
}


- (IBAction)actionSubstractProduct:(GMButton *)sender {
    
    NSUInteger quantityValue = sender.produtModal.productQuantity.integerValue;
    
    if(quantityValue > 0) {
        
        quantityValue --;
        NSString *productQuantity = [NSString stringWithFormat:@"%lu",(unsigned long)quantityValue];
        [self.addSubstractLbl setText:productQuantity];
        [sender.produtModal setProductQuantity:productQuantity];
//        if([self.delegate respondsToSelector:@selector(productQuantityValueChanged)])
//            [self.delegate productQuantityValueChanged];
        
        if([self.delegate respondsToSelector:@selector(productQuantityValueReduce)])
            [self.delegate productQuantityValueReduce];
    }
    
}
+(CGFloat)getCellHeight{
    return 56.0f;
}
@end
