//
//  PBPickerVC.m
//  PolicyBazaar
//
//  Created by Neeraj Kumar on 28/08/14.
//  Copyright (c) 2014 Neeraj Kumar. All rights reserved.
//

#import "PBPickerVC.h"

@interface PBPickerVC ()

@end

@implementation PBPickerVC
@synthesize pickerDoneCancelDelegate = _pickerDoneCancelDelegate;
@synthesize pickerView = _pickerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.font = FONT_LIGHT(20);
        [self loadView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)setArrayValuesToDisplay:(NSMutableArray *)arrayValuesToDisplay{
    if (arrayValuesToDisplay.count && [[arrayValuesToDisplay objectAtIndex:0] count]) {
        _arrayValuesToDisplay = arrayValuesToDisplay;
//        for (int indx = 0; indx < _arrayValuesToDisplay.count; indx++) {
//            [_pickerView selectRow:0 inComponent:indx animated:NO];
//        }
        [_pickerView reloadAllComponents];
    }
}

#pragma mark -
#pragma mark - Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return _arrayValuesToDisplay.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return   [[_arrayValuesToDisplay objectAtIndex:component] count] ? [[_arrayValuesToDisplay objectAtIndex:component] count]: 1;
}

- (UIView *)pickerView:(UIPickerView *)pickerView  viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel* textLabel = (UILabel*)view;
    if (textLabel == nil) {
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/_arrayValuesToDisplay.count - 10, 25)];
        textLabel.font = self.font;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.minimumScaleFactor = 0.5;
        textLabel.adjustsFontSizeToFitWidth = YES;
    }
    

    if ([[_arrayValuesToDisplay objectAtIndex:component] count]) {
        textLabel.text = [[_arrayValuesToDisplay objectAtIndex:component] objectAtIndex:row];
    }else{
        textLabel.text = @"No Content Availble.";
    }
    return textLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if([self.pickerDoneCancelDelegate respondsToSelector:@selector(pickerValueChanged:)])
        [self.pickerDoneCancelDelegate pickerValueChanged:[[_arrayValuesToDisplay objectAtIndex:0] objectAtIndex:row]];
}

- (IBAction)donePressed:(id)sender{
    if ([[_arrayValuesToDisplay objectAtIndex:0] count]) {
        NSMutableArray* arraySelectedIndexes = [NSMutableArray array];
        for (int compIndex = 0; compIndex<_arrayValuesToDisplay.count; compIndex++) {
            NSUInteger selectedIndex = [_pickerView selectedRowInComponent:compIndex];
            [arraySelectedIndexes addObject:[NSNumber numberWithInteger:selectedIndex]];
        }
        [self.pickerDoneCancelDelegate donePressedValuePicker:arraySelectedIndexes];
    }
}

- (IBAction)cancelPressed:(id)sender{
    [self.pickerDoneCancelDelegate cancelPressedValuePicker:sender];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
