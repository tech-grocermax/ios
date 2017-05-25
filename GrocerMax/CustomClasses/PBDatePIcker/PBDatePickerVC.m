//
//  PBDatePickerVC.m
//  PolicyBazaar
//
//  Created by Neeraj Kumar on 28/08/14.
//  Copyright (c) 2014 Neeraj Kumar. All rights reserved.
//

#import "PBDatePickerVC.h"

@interface PBDatePickerVC ()

@end

@implementation PBDatePickerVC

@synthesize pbDatePickerDelegate = _pbDatePickerDelegate;
@synthesize datePicker = _datePicker;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self loadView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.datePicker addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)valueChanged:(id)sender{
    UIDatePicker* datePicker = (UIDatePicker*)sender;
    if (self.pbDatePickerDelegate != nil && [self.pbDatePickerDelegate respondsToSelector:@selector(valueChanged:)]) {
        [self.pbDatePickerDelegate performSelector:@selector(valueChanged:) withObject:datePicker.date];
    }
}

- (IBAction)donePressed:(id)sender{
    NSDate* selectedDate = _datePicker.date;
    if (self.pbDatePickerDelegate != nil && [self.pbDatePickerDelegate respondsToSelector:@selector(donePressedDatePiker:)]) {
        [self.pbDatePickerDelegate performSelector:@selector(donePressedDatePiker:) withObject:selectedDate];
    }
}

- (IBAction)cancelPressed:(id)sender{    
    if (self.pbDatePickerDelegate != nil && [self.pbDatePickerDelegate respondsToSelector:@selector(cancelPressedDatePicker:)]) {
        [self.pbDatePickerDelegate performSelector:@selector(cancelPressedDatePicker:) withObject:sender];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) externallyAddPicker
{
    [self.view addSubview:_datePicker];
}

@end
