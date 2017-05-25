//
//  GMButton.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMButton.h"

@implementation GMButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setAttributedTextWith:self.titleLabel.text andAnyModal:NO];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {

        [self setAttributedTextWith:self.titleLabel.text andAnyModal:NO];
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    
    [super setTitle:title forState:state];
    [self setAttributedTextWith:title andAnyModal:[self isAnyModalPresent]];
}

- (void)setAttributedTextWith:(NSString *)title andAnyModal:(BOOL)isModal {
    
    if(!title)
        return;
    
    if(isModal) {
        
        [self.titleLabel setText:title];
        return;
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:title];
    
    float spacing = 2.0f;
    [attributedString addAttribute:NSKernAttributeName
                             value:@(spacing)
                             range:NSMakeRange(0, [title length])];
    [self.titleLabel setAttributedText:attributedString];
}

- (void)setProdutModal:(GMProductModal *)produtModal {
    
    _produtModal = produtModal;
    [self setAttributedTextWith:self.titleLabel.text andAnyModal:YES];
}

- (void)setAddressModal:(GMAddressModalData *)addressModal {
    
    _addressModal = addressModal;
    [self setAttributedTextWith:self.titleLabel.text andAnyModal:YES];
}

- (void)setTimeSlotModal:(GMTimeSloteModal *)timeSlotModal {
    
    _timeSlotModal = timeSlotModal;
    [self setAttributedTextWith:self.titleLabel.text andAnyModal:YES];
}

- (BOOL)isAnyModalPresent {
    
    if(self.addressModal)
        return YES;
    if(self.timeSlotModal)
        return YES;
    if(self.produtModal)
        return YES;
    
    return NO;
}
@end
