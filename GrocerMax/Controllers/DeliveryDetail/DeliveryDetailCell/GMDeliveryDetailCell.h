//
//  GMDeliveryDetailCell.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMDeliveryDetailCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *cellBgView;
@property (strong, nonatomic) IBOutlet GMButton *firstTimeBtn;
@property (strong, nonatomic) IBOutlet GMButton *secondTimeBtn;
@property (weak, nonatomic) IBOutlet UILabel *firstSlotFullLbl;
@property (weak, nonatomic) IBOutlet UILabel *secondSlotFullLbl;


-(void)configerViewWithData:(id)modal withSecondModal:(id)secondModal;
@end
