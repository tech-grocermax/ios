//
//  GMCityCell.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 23/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMCityCell : UITableViewCell

@property (strong, nonatomic) IBOutlet GMButton *cityBtn;

@property (weak, nonatomic) IBOutlet UIImageView *locationImageView;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

-(void) configureCellWithData:(id)data ;

+ (CGFloat)cellHeight;
@end
