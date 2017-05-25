//
//  GMDeliveryDetailCell.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMDeliveryDetailCell.h"
#import "GMTimeSloteModal.h"

@implementation GMDeliveryDetailCell

- (void)awakeFromNib {
    // Initialization code
    
    self.cellBgView.layer.borderColor = [UIColor colorWithRed:225.0/256.0 green:225.0/256.0 blue:225.0/256.0 alpha:1].CGColor;
    self.cellBgView.layer.borderWidth = 1.0;
    self.cellBgView.layer.cornerRadius = 2.0;
    
    [self setBackgroundColor:[UIColor colorWithRed:244.0/256.0 green:244.0/256.0 blue:244.0/256.0 alpha:1]];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)configerViewWithData:(id)modal withSecondModal:(id)secondModal {
    
    [self.firstTimeBtn setBackgroundColor:[UIColor clearColor]];
    [self.secondTimeBtn setBackgroundColor:[UIColor clearColor]];
    
    
    GMTimeSloteModal *timeSloteModal = (GMTimeSloteModal*)modal;
    GMTimeSloteModal *secondTimeSloteModal = (GMTimeSloteModal*)secondModal;
    
    if(timeSloteModal) {
        
        [self.firstTimeBtn setTimeSlotModal:timeSloteModal];
        [self.firstTimeBtn setTitle:timeSloteModal.firstTimeSlote forState:UIControlStateNormal];
        self.secondTimeBtn.hidden = FALSE;
        if(timeSloteModal.isSelected)
        {
            self.firstTimeBtn.selected = TRUE;
            [self.firstTimeBtn setBackgroundColor:[UIColor colorWithRed:227.0/256.0 green:227.0/256.0 blue:227.0/256.0 alpha:1]];
        }
        else
        {
            self.firstTimeBtn.selected = FALSE;
        }
        if(timeSloteModal.isSloatFull)
        {
            self.firstSlotFullLbl.hidden = FALSE;
            self.firstTimeBtn.userInteractionEnabled = FALSE;
        }
        else
        {
            self.firstSlotFullLbl.hidden = TRUE;
            self.firstTimeBtn.userInteractionEnabled = TRUE;
        }
    }
    else
    {
        self.firstTimeBtn.hidden = TRUE;
        self.firstTimeBtn.selected = FALSE;
        self.firstSlotFullLbl.hidden = TRUE;
        self.firstTimeBtn.userInteractionEnabled = FALSE;
    }
    
    if(secondTimeSloteModal)
    {
        [self.secondTimeBtn setTimeSlotModal:secondTimeSloteModal];
        [self.secondTimeBtn setTitle:secondTimeSloteModal.firstTimeSlote forState:UIControlStateNormal];
        self.secondTimeBtn.hidden = FALSE;
        if(secondTimeSloteModal.isSelected)
        {
            self.secondTimeBtn.selected = TRUE;
            [self.secondTimeBtn setBackgroundColor:[UIColor colorWithRGBValue:227 green:227 blue:227]];
        }
        else
        {
             self.secondTimeBtn.selected = FALSE;
        }
        
        if(secondTimeSloteModal.isSloatFull)
        {
            self.secondSlotFullLbl.hidden = FALSE;
            self.secondTimeBtn.userInteractionEnabled = FALSE;
        }
        else
        {
            self.secondSlotFullLbl.hidden = TRUE;
            self.secondTimeBtn.userInteractionEnabled = TRUE;
        }
        
    }
    else
    {
        self.secondTimeBtn.hidden = TRUE;
        self.secondTimeBtn.selected = FALSE;
        self.secondSlotFullLbl.hidden = TRUE;
        self.secondTimeBtn.userInteractionEnabled = FALSE;
    }
}

@end
