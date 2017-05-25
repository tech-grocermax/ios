//
//  GMSavedCardCell.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 23/02/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMSavedCardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel     *name;
@property (weak, nonatomic) IBOutlet UILabel     *number;
@property (weak, nonatomic) IBOutlet UILabel     *owner;
@property (weak, nonatomic) IBOutlet UILabel     *expiryDate;
@property (weak, nonatomic) IBOutlet UIImageView *bankLogoImageView;
@property (weak, nonatomic) IBOutlet UIView      *bgView;
@end
