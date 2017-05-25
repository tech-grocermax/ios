//
//  GMRegisterVC.m
//  GrocerMax
//
//  Created by Deepak Soni on 13/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMRegisterVC.h"
#import "GMRegisterInputCell.h"
#import "PlaceholderAndValidStatus.h"
#import "GMUserModal.h"
#import "GMGenderCell.h"
#import "GMOtpVC.h"
#import "GMRegistrationResponseModal.h"

#import <Google/SignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "GMRegisterVC.h"
#import "GMForgotVC.h"
#import "GMProfileVC.h"
#import "GMProvideMobileInfoVC.h"

#import <Google/SignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "GMWebViewVC.h"

@interface GMRegisterVC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, GMGenderCellDelegate, GIDSignInUIDelegate,GIDSignInDelegate>

@property (weak, nonatomic) IBOutlet UITableView *registerTableView;

@property (strong, nonatomic) IBOutlet UIView *registerHeaderView;

@property (strong, nonatomic) IBOutlet UIView *footerView;

@property (nonatomic, strong) NSMutableArray *cellArray;

@property (nonatomic, strong) GMGenderCell *genderCell;

@property (nonatomic, strong) GMUserModal *userModal;

@property (nonatomic, strong) UITextField *currentTextField;
@end

static NSString * const kInputFieldCellIdentifier           = @"inputFieldCellIdentifier";

static NSString * const kNameCell                           =  @"Name";
//static NSString * const kLastNameCell                       =  @"Last Name";
static NSString * const kMobileCell                         =  @"Mobile No";
static NSString * const kEmailCell                          =  @"Email";
static NSString * const kPasswordCell                       =  @"Password";
static NSString * const kGenderCell                         =  @"Gender";


@implementation GMRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerCellsForTableView];
    [self.registerTableView setTableHeaderView:self.registerHeaderView];
    [self.registerTableView setTableFooterView:self.footerView];
    
    // google login
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.title = @"Register";
    [[GMSharedClass sharedClass] setTabBarVisible:NO ForController:self animated:YES];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_Register_Screen];
    
    //    [GIDSignIn sharedInstance].uiDelegate = self;
    //    [GIDSignIn sharedInstance].delegate = self;
    //    [GIDSignIn sharedInstance].scopes = @[@"https://www.googleapis.com/auth/userinfo.email", @"https://www.googleapis.com/auth/userinfo.profile"];
    
    [self configureView];
}

- (void)configureView{
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].scopes = @[@"https://www.googleapis.com/auth/userinfo.email", @"https://www.googleapis.com/auth/userinfo.profile"];
    [GIDSignIn sharedInstance].allowsSignInWithBrowser = FALSE;
}
- (void)registerCellsForTableView {
    
    [self.registerTableView registerNib:[UINib nibWithNibName:@"GMRegisterInputCell" bundle:nil] forCellReuseIdentifier:kInputFieldCellIdentifier];
}

#pragma mark - GETTER/SETTER Methods

- (NSMutableArray *)cellArray {
    
    if(!_cellArray) {
        
//        _cellArray = [NSMutableArray arrayWithObjects:
//                      [[PlaceholderAndValidStatus alloc] initWithCellType:kFirstNameCell placeHolder:@"required" andStatus:kNone],
//                      [[PlaceholderAndValidStatus alloc] initWithCellType:kLastNameCell placeHolder:@"required" andStatus:kNone],
//                      [[PlaceholderAndValidStatus alloc] initWithCellType:kMobileCell placeHolder:@"required" andStatus:kNone],
//                      [[PlaceholderAndValidStatus alloc] initWithCellType:kEmailCell placeHolder:@"required" andStatus:kNone],
//                      [[PlaceholderAndValidStatus alloc] initWithCellType:kPasswordCell placeHolder:@"required" andStatus:kNone],
//                      [[PlaceholderAndValidStatus alloc] initWithCellType:kGenderCell placeHolder:@"required" andStatus:kNone],
//                      nil];
        _cellArray = [NSMutableArray arrayWithObjects:
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kNameCell placeHolder:kNameCell andStatus:kNone],
                       [[PlaceholderAndValidStatus alloc] initWithCellType:kEmailCell placeHolder:kEmailCell andStatus:kNone],
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kMobileCell placeHolder:kMobileCell andStatus:kNone],
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kPasswordCell placeHolder:kPasswordCell andStatus:kNone],
                      nil];
    }
    return _cellArray;
}

- (GMGenderCell *)genderCell {
    
    if(!_genderCell) _genderCell = [[[NSBundle mainBundle] loadNibNamed:@"GMGenderCell" owner:self options:nil] lastObject];
    return _genderCell;
}

- (GMUserModal *)userModal {
    
    if(!_userModal) _userModal = [[GMUserModal alloc] init];
    return _userModal;
}

#pragma mark - UITavleView Delegate/Datasource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.cellArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:indexPath.row];
    if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kGenderCell])
        return [GMGenderCell cellHeight];
    return [GMRegisterInputCell cellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PlaceholderAndValidStatus *objPlaceholderAndStatus = [self.cellArray objectAtIndex:indexPath.row];
    if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kGenderCell]) {
        
        [self.genderCell setDelegate:self];
        self.genderCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return self.genderCell;
    }
    else {
        
        GMRegisterInputCell *inputFieldCell = (GMRegisterInputCell *)[tableView dequeueReusableCellWithIdentifier:kInputFieldCellIdentifier];
        inputFieldCell.selectionStyle = UITableViewCellSelectionStyleNone;
        inputFieldCell.inputTextField.delegate = self;
        [inputFieldCell.showButton addTarget:self action:@selector(showButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self configureInputFieldCell:inputFieldCell withIndex:indexPath.row];
        return inputFieldCell;
    }
}

- (void)configureInputFieldCell:(GMRegisterInputCell*)inputCell withIndex:(NSInteger)cellIndex {
    
    PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:cellIndex];
    inputCell.inputTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:objPlaceholderAndStatus.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    
    inputCell.inputTextField.returnKeyType = UIReturnKeyNext;
//    inputCell.inputTextField.placeholder = objPlaceholderAndStatus.placeholder ;
    inputCell.statusType = (StatusType) objPlaceholderAndStatus.statusType ;
    inputCell.inputTextField.tag = cellIndex;
    inputCell.inputTextField.secureTextEntry = NO;
    inputCell.cellNameLabel.text = @"";//objPlaceholderAndStatus.inputFieldCellType;
    [inputCell.showButton setHidden:YES];
    
    if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kNameCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.firstName) ? self.userModal.firstName : @"";
    }
//    else if ([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kLastNameCell]) {
//        
//        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.lastName) ? self.userModal.lastName : @"";
//    }
    else if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kMobileCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.mobile) ? self.userModal.mobile : @"";
        inputCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
        inputCell.inputTextField.keyboardAppearance = UIKeyboardAppearanceDark;
    }
    else if ([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kEmailCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.email) ? self.userModal.email : @"";
        inputCell.inputTextField.keyboardType = UIKeyboardTypeEmailAddress;
    }
    else if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kPasswordCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.password) ? self.userModal.password : @"";
        if(self.userModal.isShowTapped) {
            
            [inputCell.showButton setTitle:@"Hide" forState:UIControlStateNormal];
            inputCell.inputTextField.secureTextEntry = NO;
        }
        else {
            
            [inputCell.showButton setTitle:@"Show" forState:UIControlStateNormal];
            inputCell.inputTextField.secureTextEntry = YES;
        }
        [inputCell.showButton setHidden:NO];
    }
}

- (void)showButtonTapped:(UIButton *)sender {
    
    GMRegisterInputCell *cell = (GMRegisterInputCell*) [self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    self.userModal.isShowTapped = !self.userModal.isShowTapped;
    if(self.userModal.isShowTapped) {
        
        [cell.showButton setTitle:@"Hide" forState:UIControlStateNormal];
        cell.inputTextField.secureTextEntry = NO;
    }
    else {
        
        [cell.showButton setTitle:@"Show" forState:UIControlStateNormal];
        cell.inputTextField.secureTextEntry = YES;
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
//        case 1: {
//            
//            NSString *lastName = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//            textField.text = lastName;
//            [self.userModal setLastName:lastName];
//            [self checkValidLastName];
//        }
            break;
        case 2: {
            
            NSString *phoneNumber = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = phoneNumber;
            [self.userModal setMobile:phoneNumber];
            [self checkValidMobileNumber];
        }
            break;
        case 1: {
            
            NSString *email = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = email;
            [self.userModal setEmail:email];
            [self checkValidEmailAddress];
        }
            break;
        case 3: {
            
            NSString *password = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = password;
            [self.userModal setPassword:password];
            [self checkValidPassword];
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
//        case 1: {
//            ACCEPTABLE_CHARACTERS = @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
//            if([resultString length] > 30)
//                return NO;
//        }
//            break;
        case 2: {
            
            if([resultString length] > 10)
                return NO;
        }
            break;
        case 1: {
            
            if([resultString length] > 30)
                return NO;
        }
            break;
        case 3: {
            
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
    GMRegisterInputCell *cell = (GMRegisterInputCell*)[self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:nextTag inSection:0]];
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
//    if (![self checkValidLastName]) {
//        resultedBool =  resultedBool && NO;
//    }else{
//        resultedBool =  resultedBool && YES;
//    }
    if (![self checkValidMobileNumber]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    if (![self checkValidEmailAddress]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    if (![self checkValidPassword]) {
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
        cell =(GMRegisterInputCell*) [self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }else {
        cell =(GMRegisterInputCell*) [self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
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
//    if (!NSSTRING_HAS_DATA(self.userModal.lastName)) {
//        cell =(GMRegisterInputCell*) [self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
//        cell.statusType = kInvalid;
//        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
//        objPlaceholderAndStatus.statusType = kInvalid;
//        return NO;
//    }else {
        cell =(GMRegisterInputCell*) [self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
//    }
    return resultedBool;
}

- (BOOL)checkValidMobileNumber{
    
    BOOL resultedBool = YES;
    int  rowNumber = 2;
    GMRegisterInputCell* cell ;
    if (![GMSharedClass validateMobileNumberWithString:self.userModal.mobile]) {
        cell =(GMRegisterInputCell*) [self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }else {
        cell =(GMRegisterInputCell*) [self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
    }
    return resultedBool;
}

- (BOOL)checkValidEmailAddress{
    
    BOOL resultedBool = YES;
    int  rowNumber = 1;
    GMRegisterInputCell* cell ;
    if (![GMSharedClass validateEmail:self.userModal.email]) {
        cell =(GMRegisterInputCell*) [self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }else {
        cell =(GMRegisterInputCell*) [self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
    }
    return resultedBool;
}

- (BOOL)checkValidPassword{
    
    BOOL resultedBool = YES;
    int  rowNumber = 3;
    GMRegisterInputCell* cell ;
    if(NSSTRING_HAS_DATA(self.userModal.password) && [self.userModal.password length] >= 6) {
        
        cell = (GMRegisterInputCell*) [self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kValid;
        resultedBool = YES;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kValid;
        return YES;
    }
    else {
        
        cell = (GMRegisterInputCell*) [self.registerTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }
    return resultedBool;
}

#pragma mark - IBAction Methods
- (IBAction)termsAndConditionButtonTapped:(id)sender {
    
    if([[GMSharedClass sharedClass] isInternetAvailable]) {
        GMWebViewVC *webViewVC = [[GMWebViewVC alloc] initWithNibName:@"GMWebViewVC" bundle:nil];
        webViewVC.isTermsAndCondition = TRUE;
        [self.navigationController pushViewController:webViewVC animated:YES];
    } else {
        [[GMSharedClass sharedClass] showErrorMessage:@"Please check internet connection."];
    }
}

- (IBAction)createAccountButtonTapped:(id)sender {
    
    [self.view endEditing:YES];
    if([self performValidations]) {
        NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
        if(NSSTRING_HAS_DATA(self.userModal.firstName))
            [userDic setObject:self.userModal.firstName forKey:kEY_fname];
        if(NSSTRING_HAS_DATA(self.userModal.lastName)) {
            [userDic setObject:self.userModal.lastName forKey:kEY_lname];
        }
        else {
            [userDic setObject:@"" forKey:kEY_lname];
        }
        if(NSSTRING_HAS_DATA(self.userModal.email))
            [userDic setObject:self.userModal.email forKey:kEY_uemail];
        if(NSSTRING_HAS_DATA(self.userModal.mobile))
            [userDic setObject:self.userModal.mobile forKey:kEY_number];
        if(NSSTRING_HAS_DATA(self.userModal.password))
            [userDic setObject:self.userModal.password forKey:kEY_password];
        GMUserModal *savedUserModal = [GMUserModal loggedInUser];
        if(NSSTRING_HAS_DATA(savedUserModal.quoteId)) {
            [userDic setObject:savedUserModal.quoteId forKey:kEY_quote_id];
        }
        
        [userDic setObject:@"0" forKey:kEY_otp];
        [self showProgress];
        [[GMOperationalHandler handler] createUser:userDic withSuccessBlock:^(GMRegistrationResponseModal *registrationResponse) {
            
            if([registrationResponse.flag isEqualToString:@"1"]) {
                [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_EmailRegister withCategory:@"" label:nil value:nil];
                [self.userModal setOtp:[NSString stringWithFormat:@"%@", registrationResponse.otp]];
                GMOtpVC *otpVC = [[GMOtpVC alloc] initWithNibName:@"GMOtpVC" bundle:nil];
                otpVC.userModal = self.userModal;
                [self.navigationController pushViewController:otpVC animated:YES];
            }
            else
                [[GMSharedClass sharedClass] showErrorMessage:registrationResponse.result];
            [self removeProgress];
            
        } failureBlock:^(NSError *error) {
            [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
            [self removeProgress];
        }];
    }
}

- (IBAction)fbLoginButtonPressed:(UIButton *)sender {
    
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email",@"public_profile"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        
        if (error) {
            // Process error
        } else if (result.isCancelled) {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                
                if ([FBSDKAccessToken currentAccessToken])
                {
                    
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields" : @"id,first_name,last_name,email,gender"}]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         if (!error) {
                             
                             NSDictionary *resultDic = result;
                             
                             if(resultDic != nil) {
                                 if ([result objectForKey:@"email"]) {
                                     [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_FacebookLogin withCategory:@"" label:nil value:nil];
                                     
                                     GMUserModal *userModal = [GMUserModal new];
                                     [userModal setFbId:[result objectForKey:@"id"]];
                                     [userModal setEmail:[result objectForKey:@"email"]];
                                     [userModal setFirstName:[result objectForKey:@"first_name"]];
                                     [userModal setLastName:[result objectForKey:@"last_name"]];
                                     [userModal setGender:[[result objectForKey:@"gender"] isEqualToString:@"male"]?GMGenderTypeMale:GMGenderTypeFemale];
                                     
////                                     if(NSSTRING_HAS_DATA(userModal.email))
////                                         [self fbRegisterOnServerWithUserModal:userModal];
////                                     else {
//                                         GMProvideMobileInfoVC *vc = [[GMProvideMobileInfoVC alloc] initWithNibName:@"GMProvideMobileInfoVC" bundle:nil];
//                                         vc.userModal = userModal;
//                                         [self.navigationController pushViewController:vc animated:YES];
////                                     }
                                     
//                                     if([[resultDic objectForKey:kEY_flag] isEqualToString:@"1"]) {
//                                         [userModal persistUser];// save user modal in memory
//                                         [[GMSharedClass sharedClass] setUserLoggedStatus:YES];// save logged in status
//                                         
//                                             [self setSecondTabAsProfile];//So user is registered, now set 2nd tab as profile
//                                             [self.navigationController popToRootViewControllerAnimated:YES];
//                                     } else {
//                                         GMProvideMobileInfoVC *vc = [[GMProvideMobileInfoVC alloc] initWithNibName:@"GMProvideMobileInfoVC" bundle:nil];
//                                         vc.userModal = userModal;
//                                         [self.navigationController pushViewController:vc animated:YES];
//                                     }

                                     [self fbRegisterOnServerWithUserModal:userModal];
                                 }
                             }
                             
                         }
                     }];
                }
            }
        }
    }];
}

- (IBAction)googleLoginButtonPressed:(UIButton *)sender {
    
    [[GIDSignIn sharedInstance] signIn];
}

#pragma mark - Google Login Delegate

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations on signed in user here.
    // ...
    
    if (user.profile.email) {
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_GoogleLogin withCategory:@"" label:nil value:nil];
        GMUserModal *userModal = [GMUserModal new];
        [userModal setGoogleId:user.userID];
        [userModal setEmail:user.profile.email];
        [userModal setFirstName:user.profile.name];
        [userModal setLastName:@""];
        [userModal setGender:GMGenderTypeMale];// suppose it defaul
        
//        if(NSSTRING_HAS_DATA(userModal.email))
            [self fbRegisterOnServerWithUserModal:userModal];
        [[GIDSignIn sharedInstance] signOut];
        
//        else {
//            GMProvideMobileInfoVC *vc = [[GMProvideMobileInfoVC alloc] initWithNibName:@"GMProvideMobileInfoVC" bundle:nil];
//            vc.userModal = userModal;
//            [self.navigationController pushViewController:vc animated:YES];
//        }
    }
}
- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}

#pragma mark - GenderCell Delegate Method

- (void)genderSelectionWithType:(GMGenderType)genderType {
    
    [self.userModal setGender:genderType];
}

#pragma mark - Send data on server

- (void)fbRegisterOnServerWithUserModal:(GMUserModal *)userModal {
    
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [paramDict setObject:userModal.email forKey:kEY_uemail];
    [paramDict setObject:@"" forKey:kEY_quote_id];
    [paramDict setObject:userModal.firstName ? userModal.firstName : @"" forKey:kEY_fname];
    [paramDict setObject:userModal.lastName ? userModal.lastName : @"" forKey:kEY_lname];
    [paramDict setObject:userModal.mobile ? userModal.mobile : @"" forKey:kEY_number];
    
    GMUserModal *savedUserModal = [GMUserModal loggedInUser];
    if(NSSTRING_HAS_DATA(savedUserModal.quoteId)) {
        [paramDict setObject:savedUserModal.quoteId forKey:kEY_quote_id];
    }
    
    [self showProgress];
    [[GMOperationalHandler handler] fgLoginRequestParamsWith:paramDict withSuccessBlock:^(id data) {
        
        [self removeProgress];
        NSDictionary *resDic = data;
        
        if ([resDic objectForKey:kEY_UserID]) {
            [userModal setQuoteId:resDic[kEY_QuoteId]];
            [userModal setUserId:resDic[kEY_UserID]];
        }
            if ([resDic objectForKey:kEY_Mobile]) {
                [userModal setMobile:[resDic objectForKey:kEY_Mobile]];
            }
            
            [userModal setTotalItem:[NSNumber numberWithInteger:[resDic[kEY_TotalItem] integerValue]]];
            
            
            if([[resDic objectForKey:kEY_flag] isEqualToString:@"1"]) {
                [[GMSharedClass sharedClass] makeLastNameFromUserModal:self.userModal];
                [userModal persistUser];// save user modal in memory
                [[GMSharedClass sharedClass] setUserLoggedStatus:YES];// save logged in status
                [self setSecondTabAsProfile];//So user is registered, now set 2nd tab as profile
                if(userModal.firstName && userModal.userId && userModal.email){
                    [rocqAnalytics identity:userModal.firstName properties:@{kEY_RocqAnalytics_User_Email:userModal.email,kEY_RocqAnalytics_User_FirstName:userModal.firstName,kEY_RocqAnalytics_User_Id:userModal.userId}];
                }
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                GMProvideMobileInfoVC *vc = [[GMProvideMobileInfoVC alloc] initWithNibName:@"GMProvideMobileInfoVC" bundle:nil];
                vc.userModal = userModal;
                [self.navigationController pushViewController:vc animated:YES];
            }
            
            
        
    } failureBlock:^(NSError *error) {
        
        [self removeProgress];
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
    }];
}
@end
