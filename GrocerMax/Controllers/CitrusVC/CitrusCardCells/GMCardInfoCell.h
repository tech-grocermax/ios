//
//  GMCardInfoCell.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 22/02/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMCardInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *cardExpryDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *cvvTextField;

@end
