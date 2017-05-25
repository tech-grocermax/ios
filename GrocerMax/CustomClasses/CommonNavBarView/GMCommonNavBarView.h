//
//  MGCommonNavBarView.h
//  FINDIT333
//
//  Created by rahul chaudhary on 07/01/15.
//  Copyright (c) 2015 Arvind Gupta. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMCommonNavBarView : UIView

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UILabel *horizantalLineAtBottomLbl;

@end
