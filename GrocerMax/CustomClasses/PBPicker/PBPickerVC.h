//
//  PBPickerVC.h
//  PolicyBazaar
//
//  Created by Neeraj Kumar on 28/08/14.
//  Copyright (c) 2014 Neeraj Kumar. All rights reserved.
//
@protocol PBPickerDoneCancelDelegate <NSObject>

@optional

- (void)donePressedValuePicker:(NSArray*)selectedIndeces;
- (void)cancelPressedValuePicker:(id)sender;
- (void)pickerValueChanged:(NSString *)changeValue;

@end

#import <UIKit/UIKit.h>

@interface PBPickerVC : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,assign) id<PBPickerDoneCancelDelegate> pickerDoneCancelDelegate;
@property (nonatomic,strong) IBOutlet UIPickerView* pickerView;
@property (nonatomic,strong) NSMutableArray* arrayValuesToDisplay;
@property (nonatomic,strong) UIFont* font;

- (IBAction)donePressed:(id)sender;

@end
