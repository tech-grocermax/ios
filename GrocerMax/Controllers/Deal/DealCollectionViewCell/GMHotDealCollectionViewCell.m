//
//  GMHotDealCollectionViewCell.m
//  GrocerMax
//
//  Created by arvind gupta on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMHotDealCollectionViewCell.h"
#import "GMHotDealBaseModal.h"

@implementation GMHotDealCollectionViewCell

- (void)awakeFromNib {
    // Initialization code

}


- (void)configureCellWithData:(id)data {
    
    GMHotDealModal *hotDealModal = (GMHotDealModal *)data;
    [self.dealImage setImageWithURL:[NSURL URLWithString:hotDealModal.bigImageURL] placeholderImage:nil];
}
@end
