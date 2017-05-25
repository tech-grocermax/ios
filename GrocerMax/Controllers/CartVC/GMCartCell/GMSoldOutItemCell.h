//
//  GMSoldOutItemCell.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 03/07/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GMSoldOutItemCellDelegate <NSObject>

- (void)productQuantityValueReduce;

@end


@interface GMSoldOutItemCell : UITableViewCell

@property (nonatomic, weak) id<GMSoldOutItemCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *productNameLbl;
@property (weak, nonatomic) IBOutlet UILabel *soldoutLbl;
@property (weak, nonatomic) IBOutlet GMButton *removeBtn;
@property (weak, nonatomic) IBOutlet UIView *addSubtractView;
@property (weak, nonatomic) IBOutlet UILabel *addSubstractLbl;
@property (weak, nonatomic) IBOutlet GMButton *substractBtn;
@property (weak, nonatomic) IBOutlet GMButton *addBtn;


-(void)configerUIForSoldOutWithData:(GMProductModal *)productModal;

-(void)configerUIForOutOfStokWithData:(GMProductModal *)productModal;


+(CGFloat)getCellHeight;
@end
