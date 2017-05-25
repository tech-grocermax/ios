//
//  PBDatePickerVC.h
//  PolicyBazaar
//
//  Created by Neeraj Kumar on 28/08/14.
//  Copyright (c) 2014 Neeraj Kumar. All rights reserved.
//

@protocol PBDatePickerDelegate <NSObject>

@optional
- (void)donePressedDatePiker:(NSDate*)selectedDate;
- (void)cancelPressedDatePicker:(id)sender;
- (void)valueChanged:(NSDate*)changedDate;

@end

#import <UIKit/UIKit.h>

@interface PBDatePickerVC : UIViewController

@property (nonatomic, assign) id<PBDatePickerDelegate> pbDatePickerDelegate;
@property (nonatomic, strong) IBOutlet UIDatePicker* datePicker;

- (IBAction)donePressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;

@end
