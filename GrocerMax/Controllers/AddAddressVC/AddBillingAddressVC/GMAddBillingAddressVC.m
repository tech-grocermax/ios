//
//  GMAddBillingAddressVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 21/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMAddBillingAddressVC.h"
#import "GMRegisterInputCell.h"
#import "PBPickerVC.h"
#import "GMStateBaseModal.h"
#import "GMAddressModal.h"

@interface GMAddBillingAddressVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, PBPickerDoneCancelDelegate>

@property (weak, nonatomic) IBOutlet UITableView *billingAddressTableView;

@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (nonatomic, strong) NSMutableArray *cellArray;

@property (nonatomic, strong) NSMutableArray *stateArray;

@property (nonatomic, strong) GMAddressModalData *addressModal;

@property (nonatomic, strong) UITextField *currentTextField;

/** This property is for picker for name prefix, occupation, marital status */
@property (nonatomic, strong) PBPickerVC* valuePickerVC;

@property (nonatomic, assign) BOOL isDefaultBillingAddress;
@end

static NSString * const kInputFieldCellIdentifier           = @"inputFieldCellIdentifier";

static NSString * const kHouseCell                      =  @"House No.";
static NSString * const kStreetCell                     =  @"Street Address/ Locality";
static NSString * const kClosestLandmarkCell            =  @"Closest landmark";
static NSString * const kCityCell                       =  @"City";
static NSString * const kStateCell                      =  @"State";
static NSString * const kPincodeCell                    =  @"Pincode";

static NSString * const kFirstNameCell                  =  @"First Name";
static NSString * const kLastNameCell                   =  @"Last Name";
static NSString * const kPhoneCell                     =  @"Phone Number";

@implementation GMAddBillingAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerCellsForTableView];
    [self.billingAddressTableView setTableFooterView:self.footerView];
    self.isDefaultBillingAddress = YES;
    [self fetchStatesFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Billing Address";
    [[GMSharedClass sharedClass] setTabBarVisible:NO ForController:self animated:YES];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_AddBilling_Screen];
}

- (void)registerCellsForTableView {
    
    [self.billingAddressTableView registerNib:[UINib nibWithNibName:@"GMRegisterInputCell" bundle:nil] forCellReuseIdentifier:kInputFieldCellIdentifier];
}

- (void)fetchStatesFromServer {
    
    [self showProgress];
    [[GMOperationalHandler handler] getStateWithSuccessBlock:^(GMStateBaseModal *stateBaseModal) {
        [self removeProgress];
        if(stateBaseModal)
            self.stateArray = [NSMutableArray arrayWithArray:stateBaseModal.stateArray];
    } failureBlock:^(NSError *error) {
        [self removeProgress];
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
    }];
}

#pragma mark - GETTER/SETTER Methods

- (NSMutableArray *)cellArray {
    
    if(!_cellArray) {
        
//        _cellArray = [NSMutableArray arrayWithObjects:
//                      [[PlaceholderAndValidStatus alloc] initWithCellType:kHouseCell placeHolder:@"required" andStatus:kNone],
//                      [[PlaceholderAndValidStatus alloc] initWithCellType:kStreetCell placeHolder:@"eg. A-1221, DLF OakWood Apartment" andStatus:kNone],
//                      [[PlaceholderAndValidStatus alloc] initWithCellType:kClosestLandmarkCell placeHolder:@"to get your groceries to you quicker" andStatus:kNone],
//                      [[PlaceholderAndValidStatus alloc] initWithCellType:kCityCell placeHolder:@"eg. Gurgaon" andStatus:kNone],
//                      [[PlaceholderAndValidStatus alloc] initWithCellType:kStateCell placeHolder:@"Select from dropdown" andStatus:kNone],
//                      [[PlaceholderAndValidStatus alloc] initWithCellType:kPincodeCell placeHolder:@"required" andStatus:kNone],
//                      nil];
        
        _cellArray = [NSMutableArray arrayWithObjects:
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kFirstNameCell placeHolder:@"required" andStatus:kNone],
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kLastNameCell placeHolder:@"required" andStatus:kNone],[[PlaceholderAndValidStatus alloc] initWithCellType:kHouseCell placeHolder:@"required" andStatus:kNone],
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kStreetCell placeHolder:@"eg. A-1221, DLF OakWood Apartment" andStatus:kNone],
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kClosestLandmarkCell placeHolder:@"to get your groceries to you quicker" andStatus:kNone],
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kCityCell placeHolder:@"eg. Gurgaon" andStatus:kNone],
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kStateCell placeHolder:@"Select from dropdown" andStatus:kNone],
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kPincodeCell placeHolder:@"required" andStatus:kNone],[[PlaceholderAndValidStatus alloc] initWithCellType:kPhoneCell placeHolder:@"required" andStatus:kNone],
                      nil];
        
        
    }
    return _cellArray;
}

- (GMAddressModalData *)addressModal {
    
    if(!_addressModal) {
        
        if(!self.editAddressModal) {
            _addressModal = [[GMAddressModalData alloc] initWithUserModal:[GMUserModal loggedInUser]];
        }
        else
            _addressModal = self.editAddressModal;
    }
    return _addressModal;
}

#pragma mark - UITavleView Delegate/Datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.cellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [GMRegisterInputCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMRegisterInputCell *inputFieldCell = (GMRegisterInputCell *)[tableView dequeueReusableCellWithIdentifier:kInputFieldCellIdentifier];
    inputFieldCell.selectionStyle = UITableViewCellSelectionStyleNone;
    inputFieldCell.inputTextField.delegate = self;
    [self configureInputFieldCell:inputFieldCell withIndex:indexPath.row];
    return inputFieldCell;
}

- (void)configureInputFieldCell:(GMRegisterInputCell*)inputCell withIndex:(NSInteger)cellIndex {
    
    PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:cellIndex];
    inputCell.inputTextField.returnKeyType = UIReturnKeyNext;
    inputCell.inputTextField.placeholder = objPlaceholderAndStatus.placeholder ;
    inputCell.statusType = (StatusType) objPlaceholderAndStatus.statusType ;
    inputCell.inputTextField.tag = cellIndex;
    inputCell.inputTextField.secureTextEntry = NO;
    inputCell.cellNameLabel.text = objPlaceholderAndStatus.inputFieldCellType;
    [inputCell.showButton setHidden:YES];
    inputCell.inputTextField.keyboardType = UIKeyboardTypeDefault;
    
    
    if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kFirstNameCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.addressModal.firstName) ? self.addressModal.firstName : @"";
    }
    else if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kLastNameCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.addressModal.lastName) ? self.addressModal.lastName : @"";
    }
    else if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kHouseCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.addressModal.houseNo) ? self.addressModal.houseNo : @"";
    }
    else if ([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kStreetCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.addressModal.locality) ? self.addressModal.locality : @"";
    }
    else if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kClosestLandmarkCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.addressModal.closestLandmark) ? self.addressModal.closestLandmark : @"";
    }
    else if ([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kCityCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.addressModal.city) ? self.addressModal.city : @"";
    }
    else if ([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kStateCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.addressModal.region) ? self.addressModal.region : @"";
    }
    else if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kPincodeCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.addressModal.pincode) ? self.addressModal.pincode : @"";
        inputCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        inputCell.inputTextField.keyboardAppearance = UIKeyboardAppearanceDark;
    }
    else if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kPhoneCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.addressModal.telephone) ? self.addressModal.telephone : @"";
        inputCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        inputCell.inputTextField.keyboardAppearance = UIKeyboardAppearanceDark;
    }
}

#pragma mark- UITextField Delegates...

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    self.currentTextField = textField;
    if (self.currentTextField.tag == 6) {
        
        textField.inputView = [self configureValuePicker];
    }
    else{
        self.currentTextField.inputView = nil;
    }
    return YES;  // Hide both keyboard and blinking cursor.
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    switch (textField.tag) {
        case 0: {
            
            NSString *firstName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = firstName;
            [self.addressModal setFirstName:firstName];
            [self checkValidFirstName];
        }
            break;
        case 1: {
            
            NSString *lastName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = lastName;
            [self.addressModal setLastName:lastName];
            [self checkValidLastName];
        }
        case 2: {
            
            NSString *houseNo = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = houseNo;
            [self.addressModal setHouseNo:houseNo];
            [self checkValidHouseNo];
        }
            break;
        case 3: {
            
            NSString *locality = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = locality;
            [self.addressModal setLocality:locality];
            [self checkValidStreetAddress];
        }
            break;
        case 4: {
            
            NSString *landmark = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = landmark;
            [self.addressModal setClosestLandmark:landmark];
            [self checkValidClosestLandmark];
        }
            break;
        case 5: {
            
            NSString *city = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = city;
            [self.addressModal setCity:city];
            [self checkValidCity];
        }
            break;
        case 6: {
            
            if(!NSSTRING_HAS_DATA(textField.text))
                [self.addressModal setRegion:textField.text];
            [self checkValidState];
        }
            break;
        case 7: {
            
            NSString *pincode = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = pincode;
            [self.addressModal setPincode:pincode];
            [self checkValidPincode];
        }
            break;
            
        case 8: {
            
            NSString *phoneNumber = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = phoneNumber;
            [self.addressModal setTelephone:phoneNumber];
            [self checkValidPincode];
        }
            break;
            
        default:
            break;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self focusToNextInputField];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    switch (textField.tag) {
            
        case 7: {
            
            if([resultString length] > 6)
                return NO;
        }
            break;
        case 8: {
            
            if([resultString length] > 10)
                return NO;
        }
            break;
        default:
            break;
    }
    return YES;
}

- (void)focusToNextInputField {
    
    [self.currentTextField resignFirstResponder];
    NSInteger nextTag = self.currentTextField.tag + 1;
    GMRegisterInputCell *cell = (GMRegisterInputCell*)[self.billingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:nextTag inSection:0]];
    if ([GMRegisterInputCell class] == [cell class]) {
        UIResponder* nextResponder = cell.inputTextField;
        if (nextResponder) {
            [nextResponder becomeFirstResponder];
        }
    }
}

#pragma mark-
#pragma mark Validations...

- (BOOL)performValidations {
    
    BOOL resultedBool = YES;
    
    if (![self checkValidFirstName]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    if (![self checkValidLastName]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }

    
    if (![self checkValidHouseNo]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    if (![self checkValidStreetAddress]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    if (![self checkValidClosestLandmark]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    if (![self checkValidCity]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    if (![self checkValidState]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    if (![self checkValidPincode]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    
    if (![self checkValidMobileNumber]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    return resultedBool;
}


- (BOOL)checkValidFirstName {
    
    BOOL resultedBool = YES;
    int  rowNumber = 0;
    GMRegisterInputCell* cell ;
    if (!NSSTRING_HAS_DATA(self.addressModal.firstName)){
        cell =(GMRegisterInputCell*) [self.billingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }else {
        cell =(GMRegisterInputCell*) [self.billingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
    }
    return resultedBool;
}

- (BOOL)checkValidLastName{
    
    BOOL resultedBool = YES;
    int  rowNumber = 1;
    GMRegisterInputCell* cell ;
    if (!NSSTRING_HAS_DATA(self.addressModal.lastName)) {
        cell =(GMRegisterInputCell*) [self.billingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }else {
        cell =(GMRegisterInputCell*) [self.billingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
    }
    return resultedBool;
}

- (BOOL)checkValidHouseNo {
    
    BOOL resultedBool = YES;
    int  rowNumber = 0;
    GMRegisterInputCell* cell ;
    if (!NSSTRING_HAS_DATA(self.addressModal.houseNo)){
        cell =(GMRegisterInputCell*) [self.billingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }else {
        cell =(GMRegisterInputCell*) [self.billingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
    }
    return resultedBool;
}

- (BOOL)checkValidStreetAddress {
    
    BOOL resultedBool = YES;
    int  rowNumber = 1;
    GMRegisterInputCell* cell ;
    if (!NSSTRING_HAS_DATA(self.addressModal.locality)) {
        cell =(GMRegisterInputCell*) [self.billingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }else {
        cell =(GMRegisterInputCell*) [self.billingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
    }
    return resultedBool;
}

- (BOOL)checkValidClosestLandmark {
    
    BOOL resultedBool = YES;
    int  rowNumber = 2;
    GMRegisterInputCell* cell ;
    if (!NSSTRING_HAS_DATA(self.addressModal.closestLandmark)) {
        cell =(GMRegisterInputCell*) [self.billingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }else {
        cell =(GMRegisterInputCell*) [self.billingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
    }
    return resultedBool;
}

- (BOOL)checkValidCity {
    
    BOOL resultedBool = YES;
    int  rowNumber = 3;
    GMRegisterInputCell* cell ;
    if (!NSSTRING_HAS_DATA(self.addressModal.city)) {
        cell =(GMRegisterInputCell*) [self.billingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }else {
        cell =(GMRegisterInputCell*) [self.billingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
    }
    return resultedBool;
}

- (BOOL)checkValidState {
    
    BOOL resultedBool = YES;
    int  rowNumber = 4;
    GMRegisterInputCell* cell ;
    if(NSSTRING_HAS_DATA(self.addressModal.region)) {
        
        cell = (GMRegisterInputCell*) [self.billingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
        return YES;
    }
    else {
        
        cell = (GMRegisterInputCell*) [self.billingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }
    return resultedBool;
}

- (BOOL)checkValidPincode {
    
    BOOL resultedBool = YES;
    int  rowNumber = 5;
    GMRegisterInputCell* cell ;
    if(NSSTRING_HAS_DATA(self.addressModal.pincode) && [self.addressModal.pincode length] == 6) {
        
        cell = (GMRegisterInputCell*) [self.billingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
        return YES;
    }
    else {
        
        cell = (GMRegisterInputCell*) [self.billingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }
    return resultedBool;
}


- (BOOL)checkValidMobileNumber{
    
    BOOL resultedBool = YES;
    int  rowNumber = 8;
    GMRegisterInputCell* cell ;
    if (![GMSharedClass validateMobileNumberWithString:self.addressModal.telephone]) {
        cell =(GMRegisterInputCell*) [self.billingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }else {
        cell =(GMRegisterInputCell*) [self.billingAddressTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
    }
    return resultedBool;
}
#pragma mark - Picker Configurations

- (UIView*)configureValuePicker {
    
    if (self.valuePickerVC == nil) {
        self.valuePickerVC = [[PBPickerVC alloc] initWithNibName:@"PBPickerVC" bundle:nil];
        self.valuePickerVC.pickerDoneCancelDelegate = self;
    }
    
    self.valuePickerVC.arrayValuesToDisplay = [self statesToDisplay];
    //    if(NSSTRING_HAS_DATA(self.addressModal.region))
    //        [self.valuePickerVC.pickerView selectRow:[self.stateArray indexOfObject:self.addressModal.region] inComponent:0 animated:NO];
    return self.valuePickerVC.view;
}

- (NSMutableArray*)statesToDisplay {
    
    NSMutableArray* displayValues = [NSMutableArray array];
    for (GMStateModal* stateModal in self.stateArray) {
        [displayValues addObject:stateModal.stateName];
    }
    return [NSMutableArray arrayWithObject:displayValues];
}

#pragma mark - PickerView Delegates

- (void)pickerValueChanged:(NSString *)changeValue {
    
    self.currentTextField.text = changeValue;
}

- (void)donePressedValuePicker:(NSArray *)selectedIndeces{
    
    if (!selectedIndeces.count)
        return;
    int selectedIndex = [[selectedIndeces objectAtIndex:0] intValue];
    GMStateModal *stateModal = [self.stateArray objectAtIndex:selectedIndex];
    [self.addressModal setRegion:stateModal.stateName];
    self.currentTextField.text = self.addressModal.region;
    [self focusToNextInputField];
}

- (void)cancelPressedValuePicker:(id)sender{
    
    self.currentTextField.text = self.addressModal.region;
    [self.currentTextField resignFirstResponder];
}

#pragma mark - IBAction Methods

- (IBAction)saveButtonTapped:(id)sender {
    
    [self.view endEditing:YES];
    if([self performValidations]) {
        
        [self.addressModal setIs_default_billing:[NSNumber numberWithBool:self.isDefaultBillingAddress]];
        [self.addressModal setIs_default_shipping:[NSNumber numberWithBool:NO]];
        
        GMRequestParams *requestParam = [GMRequestParams sharedClass];
        NSDictionary *requestDict = [requestParam getAddAddressParameterDictionaryFrom:self.addressModal andIsNewAddres:self.editAddressModal ? NO : YES];
        [self showProgress];
        
        if(self.editAddressModal) {
            
            [[GMOperationalHandler handler] editAddress:requestDict withSuccessBlock:^(BOOL success) {
                
                [self removeProgress];
                [self.navigationController popViewControllerAnimated:YES];
            } failureBlock:^(NSError *error) {
                
                [self removeProgress];
                [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
            }];
        }
        else {
            
            [[GMOperationalHandler handler] addAddress:requestDict withSuccessBlock:^(BOOL success) {
                [self removeProgress];
                [self.navigationController popViewControllerAnimated:YES];
            } failureBlock:^(NSError *error) {
                [self removeProgress];
                [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
            }];
        }

        
    }
}

- (IBAction)defaultBillingAddressButtonTapped:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    self.isDefaultBillingAddress = !self.isDefaultBillingAddress;
}
@end
