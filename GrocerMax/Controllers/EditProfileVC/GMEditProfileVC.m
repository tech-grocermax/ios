//
//  GMEditProfileVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMEditProfileVC.h"

#import "GMRegisterInputCell.h"
#import "PlaceholderAndValidStatus.h"
#import "GMUserModal.h"
#import "GMRegistrationResponseModal.h"
#import "TPKeyboardAvoidingTableView.h"
#import "GMStateBaseModal.h"
#import "GMOtpVC.h"

static NSString * const kInputFieldCellIdentifier           = @"inputFieldCellIdentifier";

static NSString * const kNameCell                      =  @"Name";
static NSString * const kLastNameCell                       =  @"Last Name";
static NSString * const kMobileCell                         =  @"Mobile No";

@interface GMEditProfileVC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *editProfileTableView;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (nonatomic, strong) NSMutableArray *cellArray;

@property (nonatomic, strong) GMUserModal *userModal;

@property (nonatomic, strong) UITextField *currentTextField;

@end

@implementation GMEditProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    GMUserModal *loginUser = [GMUserModal loggedInUser];
    self.userModal = [[GMUserModal alloc]init];
    self.userModal.firstName = loginUser.firstName;
    self.userModal.lastName = loginUser.lastName;
    self.userModal.mobile = loginUser.mobile;
    self.userModal.email = loginUser.email;
    self.userModal.password = loginUser.password;
    self.userModal.otp = loginUser.otp;
    self.userModal.gender = loginUser.gender;
    self.userModal.userId = loginUser.userId;
    self.userModal.quoteId = loginUser.quoteId;
    self.userModal.newpassword = loginUser.newpassword;
    self.userModal.conformPassword = loginUser.conformPassword;
    
    self.userModal.fbId = loginUser.fbId;
    self.userModal.googleId = loginUser.googleId;
    self.userModal.isShowTapped = loginUser.isShowTapped;
    self.userModal.balenceInWallet = loginUser.balenceInWallet;
    
    [self registerCellsForTableView];
    self.editProfileTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.editProfileTableView setSeparatorColor:[UIColor colorFromHexString:@"e2e2e2"]];
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Profile Activity" label:@"Edit Information"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Edit Profile";
    [[GMSharedClass sharedClass] setTabBarVisible:NO ForController:self animated:YES];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_EditProfile_Screen];
}

#pragma mark - IBAction Methods

- (IBAction)actionSaveBtn:(id)sender {
    
    [self.view endEditing:YES];
    if([self performValidations]) {
        NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
        if(NSSTRING_HAS_DATA(self.userModal.firstName))
            [userDic setObject:self.userModal.firstName forKey:kEY_fname];
        if(NSSTRING_HAS_DATA(self.userModal.lastName))
            [userDic setObject:self.userModal.lastName forKey:kEY_lname];
        if(NSSTRING_HAS_DATA(self.userModal.email))
            [userDic setObject:self.userModal.email forKey:kEY_uemail];
        if(NSSTRING_HAS_DATA(self.userModal.mobile))
            [userDic setObject:self.userModal.mobile forKey:kEY_number];
        if(NSSTRING_HAS_DATA(self.userModal.userId))
            [userDic setObject:self.userModal.userId forKey:kEY_userid];
        
        [self showProgress];
        [[GMOperationalHandler handler] editProfile:userDic   withSuccessBlock:^(GMRegistrationResponseModal *registrationResponse) {
            
            
            
            if([registrationResponse.flag isEqualToString:@"1"]) {
                [[GMSharedClass sharedClass] showErrorMessage:registrationResponse.result];
                [self.userModal persistUser];
                
                [self.navigationController popViewControllerAnimated:YES];
            } else if([registrationResponse.flag isEqualToString:@"2"]) {
                
                if (registrationResponse.otp) {
                    NSString *optString = [NSString stringWithFormat:@"%@", registrationResponse.otp];
                    
                    if(NSSTRING_HAS_DATA(optString)) {
                        [self.userModal setOtp:optString];
                    }
                }
                
                GMOtpVC *otpVC = [[GMOtpVC alloc] initWithNibName:@"GMOtpVC" bundle:nil];
                otpVC.userModal = self.userModal;
                otpVC.isEditProfile = YES;
                [self.navigationController pushViewController:otpVC animated:YES];
            }
            else
                [[GMSharedClass sharedClass] showErrorMessage:registrationResponse.result];
            
            [self removeProgress];
            
        } failureBlock:^(NSError *error) {
            [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
            [self removeProgress];
        }];

        
//        [[GMOperationalHandler handler] createUser:userDic withSuccessBlock:^(GMRegistrationResponseModal *registrationResponse) {
//            
//        } failureBlock:^(NSError *error) {
//            [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
//        }];
    }

}

- (void)registerCellsForTableView {
    
    [self.editProfileTableView registerNib:[UINib nibWithNibName:@"GMRegisterInputCell" bundle:nil] forCellReuseIdentifier:kInputFieldCellIdentifier];
}

#pragma mark - GETTER/SETTER Methods

- (NSMutableArray *)cellArray {
    
    if(!_cellArray) {
        
        _cellArray = [NSMutableArray arrayWithObjects:
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kNameCell placeHolder:@"required" andStatus:kNone],[[PlaceholderAndValidStatus alloc] initWithCellType:kLastNameCell placeHolder:@"required" andStatus:kNone],                       [[PlaceholderAndValidStatus alloc] initWithCellType:kMobileCell placeHolder:@"required" andStatus:kNone],
                      nil];
    }
    return _cellArray;
}

#pragma mark - UITavleView Delegate/Datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.cellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [GMRegisterInputCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    PlaceholderAndValidStatus *objPlaceholderAndStatus = [self.cellArray objectAtIndex:indexPath.row];
    
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
    
    if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kNameCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.firstName) ? self.userModal.firstName : @"";
    }
    else if ([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kLastNameCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.lastName) ? self.userModal.lastName : @"";
    }
    else if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kMobileCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.mobile) ? self.userModal.mobile : @"";
        inputCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        inputCell.inputTextField.keyboardAppearance = UIKeyboardAppearanceDark;
    }
}

#pragma mark- UITextField Delegates...

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    self.currentTextField = textField;
    return YES;  // Hide both keyboard and blinking cursor.
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    switch (textField.tag) {
        case 0: {
            
            NSString *firstName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = firstName;
            [self.userModal setFirstName:firstName];
            [self checkValidFirstName];
        }
            break;
        case 1: {
            
            NSString *lastName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = lastName;
            [self.userModal setLastName:lastName];
            [self checkValidLastName];
        }
            break;
        case 2: {
            
            NSString *phoneNumber = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = phoneNumber;
            [self.userModal setMobile:phoneNumber];
            [self checkValidMobileNumber];
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
    
    NSString *ACCEPTABLE_CHARACTERS;
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    switch (textField.tag) {
        case 0: {
            ACCEPTABLE_CHARACTERS = @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            if([resultString length] > 30)
                return NO;
        }
            break;
        case 1: {
            ACCEPTABLE_CHARACTERS = @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            if([resultString length] > 30)
                return NO;
        }
            break;
        case 2: {
            
            if([resultString length] > 10)
                return NO;
        }
            break;
        case 3: {
            
            if([resultString length] > 30)
                return NO;
        }
            break;
        case 4: {
            
            if([resultString length] > 20)
                return NO;
        }
            break;
        default:
            break;
    }
    
    if (ACCEPTABLE_CHARACTERS != nil) {
        
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return [string isEqualToString:filtered];
    }else
        return YES;
}

- (void)focusToNextInputField {
    
    [self.currentTextField resignFirstResponder];
    NSInteger nextTag = self.currentTextField.tag + 1;
    GMRegisterInputCell *cell = (GMRegisterInputCell*)[self.editProfileTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:nextTag inSection:0]];
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
    if (!NSSTRING_HAS_DATA(self.userModal.firstName)){
        cell =(GMRegisterInputCell*) [self.editProfileTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }else {
        cell =(GMRegisterInputCell*) [self.editProfileTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
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
    if (!NSSTRING_HAS_DATA(self.userModal.lastName)) {
        cell =(GMRegisterInputCell*) [self.editProfileTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }else {
        cell =(GMRegisterInputCell*) [self.editProfileTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
    }
    return resultedBool;
}

- (BOOL)checkValidMobileNumber{
    
    BOOL resultedBool = YES;
    int  rowNumber =2;
    GMRegisterInputCell* cell ;
    if (![GMSharedClass validateMobileNumberWithString:self.userModal.mobile]) {
        cell =(GMRegisterInputCell*) [self.editProfileTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }else {
        cell =(GMRegisterInputCell*) [self.editProfileTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
    }
    return resultedBool;
}
@end
