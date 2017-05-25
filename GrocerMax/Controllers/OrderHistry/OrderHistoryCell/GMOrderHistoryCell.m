//
//  GMOrderHistoryCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 18/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMOrderHistoryCell.h"
#import "GMBaseOrderHistoryModal.h"
#import "GMStateBaseModal.h"

#define ORDER_ID @"Order Id: "
#define ORDER_DATE @"Order Date: "
#define ORDER_AMOUNT_PAID @"Amount Paid: "
#define ORDER_STATUS @"Status: "
#define ORDER_ITEMS @"Items: "

#define FIRST_FONTSIZE 14.0
#define TITLE_FONTSIZE 14.0

@interface GMOrderHistoryCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderIdLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderDateLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderPaidAmountLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLbl;
@property (weak, nonatomic) IBOutlet UILabel *totalItemOrderLbl;


@end

@implementation GMOrderHistoryCell

- (void)awakeFromNib {
    // Initialization code
    
//    [self.cellBgView.layer setCornerRadius:5.0f];
//    self.cellBgView.layer.borderWidth =1.0f;
//    self.cellBgView.layer.borderColor = [UIColor darkGrayColor].CGColor;
    
    self.cellBgView.layer.borderColor = BORDER_COLOR;
    self.cellBgView.layer.borderWidth = BORDER_WIDTH;
    self.cellBgView.layer.cornerRadius = CORNER_RADIUS;
    
    [self setBackgroundColor:[UIColor colorWithRed:244.0/256.0 green:244.0/256.0 blue:244.0/256.0 alpha:1]];
    self.reorderBtn.layer.borderColor = BORDER_COLOR;
    self.reorderBtn.layer.borderWidth = BORDER_WIDTH;
    self.reorderBtn.layer.cornerRadius = CORNER_RADIUS;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)configerViewWithData:(id)modal {
    
    GMOrderHistoryModal *orderHistryModal = (GMOrderHistoryModal *)modal;
    
    self.reorderBtn.orderHistoryModal = orderHistryModal;
    self.reorderBtn.hidden = TRUE;
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    
    if([orderHistryModal.storeId isEqualToString:cityModal.storeId]) {
        self.reorderBtn.hidden = FALSE;
    }
    
    //NSString *mainStrign= @"";

    if(NSSTRING_HAS_DATA(orderHistryModal.incrimentId))
    {
        NSString *orderIdStrign = [NSString stringWithFormat:@"%@%@",ORDER_ID,orderHistryModal.incrimentId];
        NSMutableAttributedString *orderIdAttString = [[NSMutableAttributedString alloc] initWithString:orderIdStrign];
        [orderIdAttString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:[orderIdStrign rangeOfString:orderHistryModal.incrimentId]];
        [orderIdAttString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:FIRST_FONTSIZE]} range:[orderIdStrign rangeOfString:orderHistryModal.incrimentId]];
        
         [orderIdAttString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:[orderIdStrign rangeOfString:ORDER_ID]];
        [orderIdAttString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FIRST_FONTSIZE]} range:[orderIdStrign rangeOfString:ORDER_ID]];
        self.orderIdLbl.attributedText = orderIdAttString;
    } else {
        self.orderIdLbl.text = @"";
    }
    
    if(NSSTRING_HAS_DATA(orderHistryModal.orderDate))
    {
//        mainStrign = [NSString stringWithFormat:@"%@\n%@%@",mainStrign,ORDER_DATE,orderHistryModal.orderDate];
        
        NSString *orderDateStrign = [NSString stringWithFormat:@"%@%@",ORDER_DATE,orderHistryModal.orderDate];
        NSMutableAttributedString *orderDateAttString = [[NSMutableAttributedString alloc] initWithString:orderDateStrign];
        [orderDateAttString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:[orderDateStrign rangeOfString:orderHistryModal.orderDate]];
        [orderDateAttString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:FIRST_FONTSIZE]} range:[orderDateStrign rangeOfString:orderHistryModal.orderDate]];
        
        [orderDateAttString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:[orderDateStrign rangeOfString:ORDER_DATE]];
        [orderDateAttString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FIRST_FONTSIZE]} range:[orderDateStrign rangeOfString:ORDER_DATE]];
        self.orderDateLbl.attributedText = orderDateAttString;
    } else {
        self.orderDateLbl.text = @"";
    }
    
    if(NSSTRING_HAS_DATA(orderHistryModal.paidAmount))
    {
//        mainStrign = [NSString stringWithFormat:@"%@\n%@%@",mainStrign,ORDER_AMOUNT_PAID,orderHistryModal.paidAmount];
        
        NSString *orderPaidAmountStrign = [NSString stringWithFormat:@"%@₹%.2f",ORDER_AMOUNT_PAID,orderHistryModal.paidAmount.floatValue];
        NSMutableAttributedString *orderPaidAmountAttString = [[NSMutableAttributedString alloc] initWithString:orderPaidAmountStrign];
        [orderPaidAmountAttString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:[orderPaidAmountStrign rangeOfString:[NSString stringWithFormat:@"₹%.2f", orderHistryModal.paidAmount.floatValue]]];
        [orderPaidAmountAttString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:FIRST_FONTSIZE]} range:[orderPaidAmountStrign rangeOfString:[NSString stringWithFormat:@"₹%.2f", orderHistryModal.paidAmount.floatValue]]];
        
        [orderPaidAmountAttString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:[orderPaidAmountStrign rangeOfString:ORDER_AMOUNT_PAID]];
        [orderPaidAmountAttString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FIRST_FONTSIZE]} range:[orderPaidAmountStrign rangeOfString:ORDER_AMOUNT_PAID]];
        self.orderPaidAmountLbl.attributedText = orderPaidAmountAttString;
    } else {
        self.orderPaidAmountLbl.text = @"";
    }
    
    if(NSSTRING_HAS_DATA(orderHistryModal.status))
    {
//        mainStrign = [NSString stringWithFormat:@"%@\n%@%@",mainStrign,ORDER_STATUS ,orderHistryModal.status];
        
        NSString *orderStatusStrign = [NSString stringWithFormat:@"%@%@",ORDER_STATUS,orderHistryModal.status];
        NSMutableAttributedString *orderStatusAttString = [[NSMutableAttributedString alloc] initWithString:orderStatusStrign];
        [orderStatusAttString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:[orderStatusStrign rangeOfString:orderHistryModal.status]];
        [orderStatusAttString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:FIRST_FONTSIZE]} range:[orderStatusStrign rangeOfString:orderHistryModal.status]];
        
        [orderStatusAttString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:[orderStatusStrign rangeOfString:ORDER_STATUS]];
        [orderStatusAttString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FIRST_FONTSIZE]} range:[orderStatusStrign rangeOfString:ORDER_STATUS]];
        self.orderStatusLbl.attributedText = orderStatusAttString;
    } else {
        self.orderStatusLbl.text = @"";
    }
    
    if(NSSTRING_HAS_DATA(orderHistryModal.totalItem))
    {
//        mainStrign = [NSString stringWithFormat:@"%@\n%@%@",mainStrign,ORDER_ITEMS,orderHistryModal.totalItem];
        
        NSString *orderItemsStrign = [NSString stringWithFormat:@"%@%@",ORDER_ITEMS,orderHistryModal.totalItem];
        NSMutableAttributedString *orderItemsAttString = [[NSMutableAttributedString alloc] initWithString:orderItemsStrign];
        [orderItemsAttString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:[orderItemsStrign rangeOfString:orderHistryModal.status]];
        [orderItemsAttString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:FIRST_FONTSIZE]} range:[orderItemsStrign rangeOfString:orderHistryModal.totalItem]];
        
        [orderItemsAttString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:[orderItemsStrign rangeOfString:ORDER_ITEMS]];
        [orderItemsAttString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FIRST_FONTSIZE]} range:[orderItemsStrign rangeOfString:ORDER_ITEMS]];
        self.totalItemOrderLbl.attributedText = orderItemsAttString;
        
    } else {
         self.totalItemOrderLbl.text = @"";
    }
    
    /*
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:mainStrign];
    
    if(NSSTRING_HAS_DATA(orderHistryModal.orderId))
    {
        [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:[mainStrign rangeOfString:orderHistryModal.orderId]];
        [attString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:orderHistryModal.orderId]];
    }
    if(NSSTRING_HAS_DATA(orderHistryModal.orderDate))
    {
        [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:[mainStrign rangeOfString:orderHistryModal.orderDate]];
        [attString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:orderHistryModal.orderDate]];
    }
    if(NSSTRING_HAS_DATA(orderHistryModal.paidAmount))
    {
        [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:[mainStrign rangeOfString:orderHistryModal.paidAmount]];
        [attString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:orderHistryModal.paidAmount]];
    }
    if(NSSTRING_HAS_DATA(orderHistryModal.status))
    {
        [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:[mainStrign rangeOfString:orderHistryModal.status]];
        [attString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:orderHistryModal.status]];
    }
    if(NSSTRING_HAS_DATA(orderHistryModal.totalItem))
    {
        [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} range:[mainStrign rangeOfString:orderHistryModal.totalItem]];
        [attString addAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:[NSString stringWithFormat:@"%@%@",ORDER_ITEMS,orderHistryModal.totalItem]]];
    }
    

    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:[mainStrign rangeOfString:ORDER_ID]];
    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:[mainStrign rangeOfString:ORDER_DATE]];
    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:[mainStrign rangeOfString:ORDER_AMOUNT_PAID]];
    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:[mainStrign rangeOfString:ORDER_STATUS]];
    [attString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:[mainStrign rangeOfString:ORDER_ITEMS]];
    
    [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:ORDER_ID]];
    [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:ORDER_DATE]];
    [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:ORDER_AMOUNT_PAID]];
    [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:ORDER_STATUS]];
    [attString addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:FIRST_FONTSIZE]} range:[mainStrign rangeOfString:ORDER_ITEMS]];

    
    
    self.titleLbl.numberOfLines = 5;
    self.titleLbl.attributedText = attString;
     */
//
    
}
+ (CGFloat) getCellHeight {
    
    return 139.0;
}
@end
