//
//  GMChangePasswordVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 22/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMChangePasswordVC.h"

#import "GMRegisterInputCell.h"
#import "PlaceholderAndValidStatus.h"
#import "GMUserModal.h"
#import "TPKeyboardAvoidingTableView.h"
#import "GMRegistrationResponseModal.h"
#import "GMStateBaseModal.h"


static NSString * const kInputFieldCellIdentifier           = @"inputFieldCellIdentifier";

static NSString * const kOldPasswordCell                     =  @"Old Password";
static NSString * const kNewPasswordCell                     =  @"New Password";
static NSString * const kConformPasswordCell                 =  @"Confirm Password";


@interface GMChangePasswordVC ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *changePasswordTableView;

@property (weak, nonatomic) IBOutlet GMButton *saveBtn;

@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) GMUserModal *userModal;

@property (nonatomic, strong) UITextField *currentTextField;

@end

@implementation GMChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.userModal = [GMUserModal loggedInUser];
    [self registerCellsForTableView];
    [self.changePasswordTableView setSeparatorColor:[UIColor colorFromHexString:@"e2e2e2"]];
    [self uiChange];
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Profile Activity" label:@"Change Password"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    self.title = @"Change Password";
    [[GMSharedClass sharedClass] setTabBarVisible:NO ForController:self animated:YES];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_ChangePassword_Screen];
}

- (void)setSaveBtn:(GMButton *)saveBtn {
    
    _saveBtn = saveBtn;
//    [_saveBtn setTitle:@"SAVE" forState:UIControlStateNormal];
}

- (IBAction)actionSaveBtn:(id)sender {
    
    [self.view endEditing:YES];
    if([self performValidations]) {
        NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
        if(NSSTRING_HAS_DATA(self.userModal.email))
            [userDic setObject:self.userModal.email forKey:kEY_uemail];
        if(NSSTRING_HAS_DATA(self.userModal.password))
            [userDic setObject:self.userModal.password forKey:kEY_oldPassword];
        if(NSSTRING_HAS_DATA(self.userModal.newpassword))
            [userDic setObject:self.userModal.newpassword forKey:kEY_password];
        if(NSSTRING_HAS_DATA(self.userModal.userId))
            [userDic setObject:self.userModal.userId forKey:kEY_userid];
        [self showProgress];
        [[GMOperationalHandler handler] changePassword:userDic  withSuccessBlock:^(GMRegistrationResponseModal *registrationResponse) {
            
            if([registrationResponse.flag isEqualToString:@"1"]) {
                
                [[GMSharedClass sharedClass] showErrorMessage:registrationResponse.result];
                [self.navigationController popViewControllerAnimated:YES];
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


-(void) uiChange {
    
    UIView *footer =
    [[UIView alloc] initWithFrame:CGRectZero];
    self.changePasswordTableView.tableFooterView = footer;
    footer = nil;
}

- (void)registerCellsForTableView {
    
    [self.changePasswordTableView registerNib:[UINib nibWithNibName:@"GMRegisterInputCell" bundle:nil] forCellReuseIdentifier:kInputFieldCellIdentifier];
}

#pragma mark - GETTER/SETTER Methods

- (NSMutableArray *)cellArray {
    
    if(!_cellArray) {
        
        _cellArray = [NSMutableArray arrayWithObjects:
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kOldPasswordCell placeHolder:@"required" andStatus:kNone],
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kNewPasswordCell placeHolder:@"required" andStatus:kNone],
                      [[PlaceholderAndValidStatus alloc] initWithCellType:kConformPasswordCell placeHolder:@"required" andStatus:kNone],
                      nil];
    }
    return _cellArray;
}
//- (GMUserModal *)userModal {
//    
//    if(!_userModal) _userModal = [[GMUserModal alloc] init];
//    
//    
//    return _userModal;
//}


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
    
    if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kOldPasswordCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.password) ? self.userModal.password : @"";
        inputCell.inputTextField.secureTextEntry = YES;
//        [inputCell.showButton setHidden:NO];
    }
    else if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kNewPasswordCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.password) ? self.userModal.newpassword : @"";
        inputCell.inputTextField.secureTextEntry = YES;
//        [inputCell.showButton setHidden:NO];
    }
    else if([objPlaceholderAndStatus.inputFieldCellType isEqualToString:kConformPasswordCell]) {
        
        inputCell.inputTextField.text = NSSTRING_HAS_DATA(self.userModal.password) ? self.userModal.conformPassword : @"";
        inputCell.inputTextField.secureTextEntry = YES;
//        [inputCell.showButton setHidden:NO];
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
            
            NSString *password = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = password;
            [self.userModal setPassword:password];
            [self checkValidPassword:password rowNumber:0];
        }
            break;
        case 1: {
            
            NSString *password = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = password;
            [self.userModal setNewpassword:password];
            [self checkValidPassword:password rowNumber:1];
        }
            break;
        case 2: {
            
            NSString *password = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            textField.text = password;
            [self.userModal setConformPassword:password];
            [self checkValidPassword:password rowNumber:2];
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
            
            if([resultString length] > 20)
                return NO;
        }
            break;
        case 1: {
            
            if([resultString length] > 20)
                return NO;
        }
            break;
        case 2: {
            
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
    GMRegisterInputCell *cell = (GMRegisterInputCell*)[self.changePasswordTableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:nextTag inSection:0]];
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
    
    if (![self checkValidPassword:self.userModal.password rowNumber:0]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    
    if (![self checkValidPassword:self.userModal.newpassword rowNumber:1]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    
    if (![self checkValidPassword:self.userModal.conformPassword rowNumber:2]) {
        resultedBool =  resultedBool && NO;
    }else{
        resultedBool =  resultedBool && YES;
    }
    return resultedBool;
}





- (BOOL)checkValidPassword :(NSString *)password rowNumber:(int)rowNumber{
    
    BOOL resultedBool = YES;
    GMRegisterInputCell* cell ;
    if(NSSTRING_HAS_DATA(password) && [password length] >= 6) {
        
        if(rowNumber == 1 || rowNumber ==2)
        {
            if([self.userModal.newpassword isEqualToString:self.userModal.conformPassword])
            {
                int otherRow ;
                if(rowNumber == 1)
                {
                    otherRow = 2;
                }
                else
                {
                    otherRow = 1;
                }
                cell = (GMRegisterInputCell*) [self.changePasswordTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
                cell.statusType = kValid;
                resultedBool = YES;
                PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
                objPlaceholderAndStatus.statusType = kValid;
                
                GMRegisterInputCell *otherCell = (GMRegisterInputCell*) [self.changePasswordTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:otherRow inSection:0]];
                otherCell.statusType = kValid;
                resultedBool = YES;
                PlaceholderAndValidStatus* otherObjPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
                otherObjPlaceholderAndStatus.statusType = kValid;
                
                return YES;
            }
            else
            {
                
                int otherRow ;
                if(rowNumber == 1)
                {
                    otherRow = 2;
                }
                else
                {
                    otherRow = 1;
                }
                
                cell = (GMRegisterInputCell*) [self.changePasswordTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
                cell.statusType = kInvalid;
                PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
                objPlaceholderAndStatus.statusType = kInvalid;
                
                GMRegisterInputCell *otherCell = (GMRegisterInputCell*) [self.changePasswordTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:otherRow inSection:0]];
                otherCell.statusType = kInvalid;
                resultedBool = NO;
                PlaceholderAndValidStatus* otherObjPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
                otherObjPlaceholderAndStatus.statusType = kInvalid;
                return NO;
            }
        }
        else
        {
            cell = (GMRegisterInputCell*) [self.changePasswordTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
            cell.statusType = kValid;
            resultedBool = YES;
            PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
            objPlaceholderAndStatus.statusType = kValid;
            return YES;
        }
    }
    else {
        
        cell = (GMRegisterInputCell*) [self.changePasswordTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:rowNumber inSection:0]];
        cell.statusType = kInvalid;
        PlaceholderAndValidStatus* objPlaceholderAndStatus = [self.cellArray objectAtIndex:rowNumber];
        objPlaceholderAndStatus.statusType = kInvalid;
        return NO;
    }
    return resultedBool;
}

#pragma mark - IBAction Methods

@end
