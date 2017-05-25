//
//  GMOrderDetailHeaderView.h
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 25/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMOrderDetailHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *headerTitleLbl;
@property (weak, nonatomic) IBOutlet UIView *headerBgView;

- (void)congigerHeaderData :(NSString *)value;
@end
