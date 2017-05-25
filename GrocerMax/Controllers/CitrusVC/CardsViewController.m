//
//  CardsViewController.m
//  PaymentSdk_GUI
//
//  Created by Vikas Singh on 8/26/15.
//  Copyright (c) 2015 Vikas Singh. All rights reserved.
//

#import "CardsViewController.h"
#import "UIUtility.h"
#import "HMSegmentedControl.h"
#import "MerchantConstants.h"

#import "GMTextFieldCell.h"
#import "GMCardInfoCell.h"
#import "GMSaveCardCell.h"
#import "GMSavedCardCell.h"
#import "UIViewController+MGTopNavigationBarViewController.h"

static NSString * const kInputFieldCellIdentifier                 =  @"inputFieldCellIdentifier";
static NSString * const kCardInfoCellIdentifier                   =  @"cardInfoCellIdentifier";
static NSString * const kSaveCardCellIdentifier                   =  @"saveCardCellIdentifier";
static NSString * const kSavedCardCellIdentifier                   =  @"savedCardCellIdentifier";

@interface CCCardInfo : NSObject 

@property (nonatomic , strong) NSString *cardNumber;
@property (nonatomic , strong) NSString *ownerName;
@property (nonatomic , strong) NSString *expiryDate;
@property (nonatomic , strong) NSString *cvvNumber;
@property BOOL isSwitchOn;


@end

@implementation CCCardInfo

@synthesize cardNumber,ownerName,expiryDate,cvvNumber,isSwitchOn;

@end

@interface CardsViewController (){

    NSArray *array;
    UITextField *currentTextField;
    NSDictionary *codeDict;
    UISegmentedControl *segControl;
    CTSPaymentDetailUpdate *cardInfo;
    NSArray *debitArray;
    NSArray *creditArray;
    NSMutableArray *saveCardsArray;
    NSDictionary *netBankingDict;
    NSInteger selectedRow;
    NSString *cvvText;
    NSMutableDictionary *imageDict;
    
//    UISwitch *switchView;
}
@property (nonatomic , strong) CCCardInfo *cccardInfo;

@end

@implementation CardsViewController
@synthesize cccardInfo;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    GMCommonNavBarView *commonNavBarView = [self addBarViewWithTitle:@"Load Money" isRightButton:NO];
    [commonNavBarView.backBtn addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self registerCellsForTableView];
    [self initialSetting];
    
}
-(void)backButtonPressed{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
//    [switchView setOn:NO animated:YES];
    self.cccardInfo.isSwitchOn = NO;
    [self.ccddtableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Initial Setting Methods
- (void) initialSetting{
    
//    [self dynamicPricing];
    
// Button & View setting
    self.netBankCodeTextField.text = @"Select Bank";
    self.cccardInfo = [[CCCardInfo alloc]init];
    
    self.indicatorView.hidden = TRUE;
    self.loadButton.layer.cornerRadius = 4;
    [self.saveCardsTableView setHidden:TRUE];
    self.netBankCodeTextField.hidden = TRUE;
    
    
    array =[[NSArray alloc]init];
    saveCardsArray =[[NSMutableArray alloc]init];
    
    [self requestPaymentModes];
    

    
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignKeyboard:)];
    [self.ccddtableView addGestureRecognizer:tapRecognizer];
    
    
//    UIPickerView *pickerView = [[UIPickerView alloc] init];
    
    [self.pickerView setHidden:TRUE];
    UIToolbar *accessoryToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    accessoryToolbar.barTintColor = [UIColor orangeColor];
    // Configure toolbar .....
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hidePickerView)];
    
    [accessoryToolbar setItems:[NSArray arrayWithObjects:doneButton, nil] animated:YES];
    
    self.netBankCodeTextField.inputView = self.pickerView;
    self.netBankCodeTextField.inputAccessoryView = accessoryToolbar;
    
    
    //Setting for Segment Control
    
    
    if (self.landingScreen==0) {
        
        self.title = @"Payment";
        NSString *string = [NSString stringWithFormat:@"Pay Rs %@",self.amount];
        [self.loadButton setTitle:string forState:UIControlStateNormal];
        //        [self.loadMoneyButton setTitle:@"Payment" forState:UIControlStateNormal];
        
    }
    else if (self.landingScreen==1){
        self.title = @"Load Money";
        NSString *string = [NSString stringWithFormat:@"Load Rs %@",self.amount];
        [self.loadButton setTitle:string forState:UIControlStateNormal];
        //        [self.loadMoneyButton setTitle:@"Load Money" forState:UIControlStateNormal];
        
    }
    else if (self.landingScreen==2){
        self.title = @"Dynamic Pricing";
        NSString *string = [NSString stringWithFormat:@"Pay Rs %@",self.ruleInfo.originalAmount];
        [self.loadButton setTitle:string forState:UIControlStateNormal];
        //        [self.loadMoneyButton setTitle:@"Apply Dynamic Pricing" forState:UIControlStateNormal];
    }
    
    // Segmented control with scrolling
    HMSegmentedControl *segmentedControl ;
    
    segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"Debit Card", @"Credit Card", @"Net Banking", @"Saved Card"]];
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    segmentedControl.frame = CGRectMake(0, 60, viewWidth, 45);
    segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.verticalDividerEnabled = YES;
    segmentedControl.verticalDividerColor = [UIColor whiteColor];
    segmentedControl.verticalDividerWidth = 1.5f;
    [segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        return attString;
    }];
    [segmentedControl addTarget:self action:@selector(loadUsingCard:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
    
    
    imageDict = [[CTSDataCache sharedCache] fetchCachedDataForKey:BANK_LOGO_KEY];
    
}

- (void)registerCellsForTableView {
    
    [self.ccddtableView registerNib:[UINib nibWithNibName:@"GMTextFieldCell" bundle:nil] forCellReuseIdentifier:kInputFieldCellIdentifier];
    
    [self.ccddtableView registerNib:[UINib nibWithNibName:@"GMCardInfoCell" bundle:nil] forCellReuseIdentifier:kCardInfoCellIdentifier];
    
    [self.ccddtableView registerNib:[UINib nibWithNibName:@"GMSaveCardCell" bundle:nil] forCellReuseIdentifier:kSaveCardCellIdentifier];
    
    
    [self.saveCardsTableView registerNib:[UINib nibWithNibName:@"GMSavedCardCell" bundle:nil] forCellReuseIdentifier:kSavedCardCellIdentifier];
}
#pragma mark - Action Methods
// You can load/add money as per following way
-(IBAction)loadUsingCard:(id)sender{
    
    segControl = (UISegmentedControl *)sender;
    
     [self.view endEditing:YES];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self resetUI];
        
    });
    [self.pickerView setHidden:TRUE];
     self.loadButton.hidden = FALSE;
    self.loadButton.userInteractionEnabled = TRUE;
    if (segControl.selectedSegmentIndex==0 || segControl.selectedSegmentIndex==1) {

        [self.saveCardsTableView setHidden:TRUE];
        self.ccddtableView.hidden = FALSE;
        self.netBankCodeTextField.hidden = TRUE;
        
    }
    else if (segControl.selectedSegmentIndex==2){
        
        [self.saveCardsTableView setHidden:TRUE];
        self.ccddtableView.hidden = TRUE;
        self.netBankCodeTextField.hidden = FALSE;
        self.loadButton.userInteractionEnabled = FALSE;
        
        
    }
    else if (segControl.selectedSegmentIndex==3){
        [self.saveCardsTableView setHidden:FALSE];
        self.ccddtableView.hidden = TRUE;
        self.netBankCodeTextField.hidden = TRUE;
        self.loadButton.hidden = TRUE;
        [self getSaveCards:nil];
    }
    else if (segControl.selectedSegmentIndex==4){
    
        [self.saveCardsTableView setHidden:TRUE];
        self.ccddtableView.hidden = TRUE;
        self.netBankCodeTextField.hidden = TRUE;
        self.loadButton.hidden = TRUE;
    }
}

-(IBAction)saveCard:(id)sender{

   self.loadButton.userInteractionEnabled = TRUE;
   
    [self setCardInfo];
//    switchView = (UISwitch *)sender;
    
    NSString *resultantDate;
    
    NSString *cardNumber = [self.cccardInfo.cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (self.cccardInfo.cardNumber.length>0) {
        NSString *scheme = [CTSUtility fetchCardSchemeForCardNumber:cardNumber];
        if ([scheme isEqualToString:@"MTRO"] ){
            if ((self.cccardInfo.cvvNumber.length==0) && (self.cccardInfo.expiryDate.length==0)) {
                self.cccardInfo.expiryDate = @"11/2019";
                self.cccardInfo.cvvNumber = @"123";
            }
        }
    }
    
    if (self.cccardInfo.expiryDate.length!=0) {
        NSArray* subStrings = [self.cccardInfo.expiryDate componentsSeparatedByString:@"/"];
        int year = [[subStrings objectAtIndex:1] intValue]+2000;
        resultantDate = [NSString stringWithFormat:@"%d/%d",[[subStrings objectAtIndex:0] intValue],year];
    }
    // Configure your request here.
    if (self.cccardInfo.cardNumber.length==0 || self.cccardInfo.expiryDate.length==0 || self.cccardInfo.cvvNumber.length==0 || self.cccardInfo.ownerName.length==0) {
        [UIUtility toastMessageOnScreen:@"Couldn't save this card.\n All fields are mandatory."];
//        [switchView setOn:NO animated:YES];
        self.cccardInfo.isSwitchOn = NO;
        [self.ccddtableView reloadData];
    }
    else if (![CTSUtility validateExpiryDate:resultantDate]){
        [UIUtility toastMessageOnScreen:@"Expiry date is not valid."];
//        [switchView setOn:NO animated:YES];
        self.cccardInfo.isSwitchOn = NO;
        [self.ccddtableView reloadData];
    }
    else{
        
        NSString *scheme = [CTSUtility fetchCardSchemeForCardNumber:cardNumber];
        if ([scheme isEqualToString:@"MTRO"] ){
            self.cccardInfo.cvvNumber = [self.cccardInfo.cvvNumber stringByTrimmingCharactersInSet:
                                       [NSCharacterSet whitespaceCharacterSet]];
            self.cccardInfo.expiryDate = [self.cccardInfo.expiryDate stringByTrimmingCharactersInSet:
                                      [NSCharacterSet whitespaceCharacterSet]];
           
        }
        [proifleLayer updatePaymentInformation:cardInfo withCompletionHandler:^(NSError *error) {
            self.loadButton.userInteractionEnabled = TRUE;
            if(error == nil){
                // Your code to handle success.
                [UIUtility toastMessageOnScreen:@"Successfully card saved"];
            }
            else {
//                [switchView setOn:NO animated:YES];
                self.cccardInfo.isSwitchOn = NO;
                [self.ccddtableView reloadData];
                // Your code to handle error.
                [UIUtility toastMessageOnScreen:error.localizedDescription];
                //                [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@" couldn't save card\n error: %@",error]];
            }
        }];
    }
    
}

- (void)updateSwitchAtIndexPath:(UISwitch *)localSwitchView {
   
    if ([localSwitchView isOn]) {
        [localSwitchView setOn:YES animated:YES];
        self.cccardInfo.isSwitchOn = YES;
        [self.ccddtableView reloadData];
        
        [self saveCard:localSwitchView];
    } else {
        [localSwitchView setOn:NO animated:YES];
        self.cccardInfo.isSwitchOn = NO;
//        [self.ccddtableView reloadData];
        
    }
    
}

-(IBAction)loadOrPayMoney:(id)sender{

    [self.view endEditing:YES];
    // Credit card
    self.indicatorView.hidden = FALSE;
    [self.indicatorView startAnimating];
    
//    [switchView setOn:NO animated:YES];
    self.cccardInfo.isSwitchOn = NO;
    [self.ccddtableView reloadData];
    NSString *cardNumber = [self.cccardInfo.cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (segControl.selectedSegmentIndex==0) {
        if (debitArray.count==0) {
            [UIUtility toastMessageOnScreen:@"Please Contact to Citruspay care to enable your card scheme."];
        }
        else{
            BOOL isSchemeAvailable = FALSE;
            for(NSString *string in debitArray){
//                NSLog(@"card scheme %@",[CTSUtility fetchCardSchemeForCardNumber:cardNumber]);
                if ([string caseInsensitiveCompare:[CTSUtility fetchCardSchemeForCardNumber:cardNumber]] == NSOrderedSame) {
                    isSchemeAvailable=TRUE;
                    break;
                }
            }
            if (!isSchemeAvailable) {
                
                [UIUtility toastMessageOnScreen:@"This card scheme is not valid for you.Please Contact to Citruspay care."];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.indicatorView stopAnimating];
                    self.indicatorView.hidden = TRUE;
                });
                return;
            }
            
            if (self.cccardInfo.expiryDate.length!=0) {
                NSArray* subStrings = [self.cccardInfo.expiryDate componentsSeparatedByString:@"/"];
                int year = [[subStrings objectAtIndex:1] intValue]+2000;
                NSString *resultantDate = [NSString stringWithFormat:@"%d/%d",[[subStrings objectAtIndex:0] intValue],year];
                if (![CTSUtility validateExpiryDate:resultantDate]){
                    [UIUtility toastMessageOnScreen:@"Expiry date is not valid."];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.indicatorView stopAnimating];
                        self.indicatorView.hidden = TRUE;
                    });
                    return;
                }
            }
        }
    }
    else if (segControl.selectedSegmentIndex==1){
        
        if (creditArray.count==0) {
            [UIUtility toastMessageOnScreen:@"Please Contact to Citruspay care to enable your card scheme."];
        }
        else{
            
            BOOL isSchemeAvailable = FALSE;
            for(NSString *string in creditArray){
                if ([string caseInsensitiveCompare:[CTSUtility fetchCardSchemeForCardNumber:cardNumber]] == NSOrderedSame) {
                    isSchemeAvailable = TRUE;
                    break;
                }
            }
            if (!isSchemeAvailable) {
                
                [UIUtility toastMessageOnScreen:@"This card scheme is not valid for you.Please Contact to Citruspay care."];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.indicatorView stopAnimating];
                    self.indicatorView.hidden = TRUE;
                });
                return;
            }
            NSArray* subStrings = [self.cccardInfo.expiryDate componentsSeparatedByString:@"/"];
            int year = [[subStrings objectAtIndex:1] intValue]+2000;
            NSString *resultantDate = [NSString stringWithFormat:@"%d/%d",[[subStrings objectAtIndex:0] intValue],year];
            if (![CTSUtility validateExpiryDate:resultantDate]){
                [UIUtility toastMessageOnScreen:@"Expiry date is not valid."];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.indicatorView stopAnimating];
                    self.indicatorView.hidden = TRUE;
                });
                return;
            }
        }
    }
    
    [self setCardInfo];
    
    if (self.landingScreen==1) {
        
        [CTSUtility requestBillAmount:self.amount billURL:BillUrl callback: ^(CTSBill *bill , NSError *error){
            
            if(error){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.indicatorView stopAnimating];
                    self.indicatorView.hidden = TRUE;
                });
                [UIUtility toastMessageOnScreen:error.localizedDescription];
            }
            else {
                [paymentLayer requestDirectChargePayment:cardInfo withContact:contactInfo withAddress:addressInfo bill:bill returnViewController:self withCompletionHandler:^(CTSCitrusCashRes *citrusCashResponse, NSError *error) {
                
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.indicatorView stopAnimating];
                        self.indicatorView.hidden = TRUE;
                    });
                    if(error){
                        [UIUtility toastMessageOnScreen:error.localizedDescription];
                    }
                    else {
                        [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"Payment Status %@",[citrusCashResponse.responseDict valueForKey:@"TxStatus"] ]];
                        [self resetUI];
                    }
                }];
            }
            
        }];
        
        
    }
    else if(self.landingScreen==0){
        
        [paymentLayer requestLoadMoneyInCitrusPay:cardInfo withContact:contactInfo withAddress:addressInfo amount:self.amount returnUrl:LoadWalletReturnUrl customParams:customParams  returnViewController:self withCompletionHandler:^(CTSCitrusCashRes *citrusCashResponse, NSError *error) {
            
             dispatch_async(dispatch_get_main_queue(), ^{
             [self.indicatorView stopAnimating];
             self.indicatorView.hidden = TRUE;
             });
            if(error){
                [UIUtility toastMessageOnScreen:error.localizedDescription];
            }
            else {
                
                
//                [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"Load Money Status %@",[citrusCashResponse.responseDict valueForKey:LoadMoneyResponeKey]]];
//                [self resetUI];
                [self backButtonPressed];
            }
        }];
    }
    else if(self.landingScreen==2){
    
        [self dynamicPricing];
    
    }
  
}

- (IBAction)getSaveCards:(id)sender{
    
     self.indicatorView.hidden = FALSE;
    [self.indicatorView startAnimating];
   
    // Get the bind user cards.
    // Configure your request here.
    [proifleLayer requestPaymentInformationWithCompletionHandler:^(CTSProfilePaymentRes *paymentInfo, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = TRUE;

        });
        if (error == nil) {
            // Your code to handle success.
            
            //Fetching save NetBanking Option
//            NSArray  *netBankingArray = paymentInfo.getSavedNBPaymentOption;
//            NSLog(@"netBankingArray : %@",netBankingArray);
//            //Fetching save Debit cards Option
//            NSArray  *debitCardArray = paymentInfo.getSavedDCPaymentOption;
//            NSLog(@"debitCardArray : %@",debitCardArray);
//            //Fetching save Credit cards Option
//            NSArray  *creditCardArray = paymentInfo.getSavedCCPaymentOption;
//            NSLog(@"creditCardArray : %@",creditCardArray);
            
            NSMutableString *toastString = [[NSMutableString alloc] init];
            if([paymentInfo.paymentOptions count])
            {
                saveCardsArray = (NSMutableArray *) paymentInfo.paymentOptions;
               // sleep(3);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.saveCardsTableView reloadData];
                });
                
                
                //   [toastString appendString:[self convertToString:[paymentInfo.paymentOptions objectAtIndex:0]]];
                
            }
            else{
                toastString =(NSMutableString *) @"No saved cards, please save card first";
                [UIUtility toastMessageOnScreen:toastString];
            }
            
        } else {
            // Your code to handle error.
            [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"Couldn't find saved cards \nerror: %@",[error localizedDescription]]];
        }
    }];
}

// Tokenized card payment.
-(IBAction)tokenizedPaymentWithToken:(NSString *)token withCVV:(NSString *)cvv andWithScheme:(NSString *)scheme{
    
    self.indicatorView.hidden = FALSE;
    [self.indicatorView startAnimating];
    CTSPaymentDetailUpdate *tokenizedCardInfo = [[CTSPaymentDetailUpdate alloc] init];
    // Update card for tokenized payment.
    CTSElectronicCardUpdate *tokenizedCard = [[CTSElectronicCardUpdate alloc] initCreditCard];
    tokenizedCard.cvv= cvv;
    tokenizedCard.token= token; // @"5115669e6129247a1e7a3599ea58e947";
    tokenizedCard.scheme = scheme;

    [tokenizedCardInfo addCard:tokenizedCard];
    
    [CTSUtility requestBillAmount:self.amount billURL:BillUrl callback: ^(CTSBill *bill , NSError *error){
        
        if(error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.indicatorView stopAnimating];
                self.indicatorView.hidden = TRUE;
            });
            [UIUtility toastMessageOnScreen:error.localizedDescription];
        }
        else {
       //Vikas
             [paymentLayer requestChargeTokenizedPayment:tokenizedCardInfo withContact:contactInfo withAddress:addressInfo bill:bill customParams:customParams returnViewController:self withCompletionHandler:^(CTSCitrusCashRes *citrusCashResponse, NSError *error) {
    
//             [paymentLayer requestDirectChargePayment:tokenizedCardInfo withContact:contactInfo withAddress:addressInfo bill:bill returnViewController:self withCompletionHandler:^(CTSCitrusCashRes *citrusCashResponse, NSError *error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.indicatorView stopAnimating];
                    self.indicatorView.hidden = TRUE;
                });
                if(error){
                    [UIUtility toastMessageOnScreen:error.localizedDescription];
                }
                else {
                    [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"Payment Status %@",[citrusCashResponse.responseDict valueForKey:@"TxStatus"] ]];
                }
            }];
        }
    }];
    
}


- (void)resignKeyboard:(UITapGestureRecognizer *)sender{
    
    [self.view endEditing:YES];
}

- (void)hidePickerView{

    self.loadButton.userInteractionEnabled = TRUE;
    [currentTextField resignFirstResponder];
}



-(void)dynamicPricing{
    
//    //Citrus cash
//    CTSPaymentDetailUpdate *paymentInfo = [[CTSPaymentDetailUpdate alloc] initCitrusCash];
    self.indicatorView.hidden = FALSE;
    [self.indicatorView startAnimating];
    
//    CTSRuleInfo *ruleInfo = [[CTSRuleInfo alloc] init];
//    ruleInfo.ruleName = @"YaddyBoy10";
//    ruleInfo.alteredAmount = @"20";
//    ruleInfo.originalAmount = @"100";
//    ruleInfo.operationType = DPRequestTypeValidate;
    
    
//    CTSElectronicCardUpdate *instrument = [[CTSElectronicCardUpdate alloc] initCreditCard];
//    instrument.cvv= TEST_CREDIT_CARD_CVV;
//    instrument.token= @"2ecd7e218f1663d2c9285e54994eec43";
    

//    CTSPaymentDetailUpdate *paymentInfo = [[CTSPaymentDetailUpdate alloc] init];
//    [paymentInfo addCard:instrument];
    
    CTSUser *user = [[CTSUser alloc] init];
    user.email = @"vikas.singh@citruspay.com";
    user.mobile = @"9533998688";
    
    
    [paymentLayer requestPerformDynamicPricingRule:self.ruleInfo paymentInfo:cardInfo billUrl:BillUrl user:user extraParams:nil completionHandler:^(CTSDyPResponse *dyPResponse, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = TRUE;
        });
        if (error==nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *originalAmountString = [NSString stringWithFormat:@"%@ %@",[dyPResponse.originalAmount valueForKey:@"currency"], [dyPResponse.originalAmount valueForKey:@"value"] ];
               
                NSString *alteredAmountString = [NSString stringWithFormat:@"%@ %@",[dyPResponse.alteredAmount valueForKey:@"currency"], [dyPResponse.alteredAmount valueForKey:@"value"] ];
                NSString *messageString = nil;
                if([dyPResponse.extraParams valueForKey:@"consumerMessage"]==nil){
                     messageString = [NSString stringWithFormat:@"%@\nOriginal Amount : %@\nAltered Amount : %@\nConsumer Message:",dyPResponse.resultMessage,originalAmountString,alteredAmountString];
                }
                else
                   messageString = [NSString stringWithFormat:@"%@\nOriginal Amount : %@\nAltered Amount : %@\nConsumer Message:%@",dyPResponse.resultMessage,originalAmountString,alteredAmountString,[dyPResponse.extraParams valueForKey:@"consumerMessage"]];
                
                
               
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dynamic Pricing Response" message:messageString delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Pay" , nil];
                alert.tag = 101;
                
                [alert show];
            });
        }
        else
            [UIUtility toastMessageOnScreen:error.localizedDescription];
    }];
}

-(void)payUsingDp{
    
    [paymentLayer requestChargeDynamicPricingContact:contactInfo withAddress:addressInfo customParams:nil returnViewController:self withCompletionHandler:^(CTSCitrusCashRes *citrusCashResponse, NSError *error) {
//        NSLog(@"citrusCashResponse %@",citrusCashResponse);
//        NSLog(@"error %@",error);
        
        if(error){
            [UIUtility toastMessageOnScreen:error.localizedDescription];
        }
        else {
            [self resetUI];
            [UIUtility toastMessageOnScreen:[NSString stringWithFormat:@"DP Status %@",[citrusCashResponse.responseDict valueForKey:@"TxStatus"] ]];
        }
    }];
}



#pragma mark - TextView Delegate Methods
- (void)textFieldDidBeginEditing:(UITextField *)textField{

    if (textField==self.netBankCodeTextField) {
        
        if (netBankingDict.count==0) {
            [self.pickerView setHidden:TRUE];
            [self.netBankCodeTextField resignFirstResponder];
            [self.pickerView removeFromSuperview];
            
            [UIUtility toastMessageOnScreen:@"Please Contact to Citruspay care to enable your Net banking."];
        }
        else{
            [self.pickerView setHidden:FALSE];
            currentTextField=textField;
            array = [netBankingDict allKeys];
            [self.pickerView reloadAllComponents];
            [self.pickerView selectRow:0 inComponent:0 animated:YES];
            [self pickerView:self.pickerView didSelectRow:0 inComponent:0];
            [self.pickerView removeFromSuperview];
            [self.netBankCodeTextField becomeFirstResponder];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
    if (textField.tag == 2000) {
        self.cccardInfo.cardNumber = textField.text;
        
    }
    else if (textField.tag== 2002) {
        self.cccardInfo.expiryDate = textField.text;
    }
    else if (textField.tag==2004) {
        self.cccardInfo.cvvNumber = textField.text;
    }else if (textField.tag==2006) {
        self.cccardInfo.ownerName = textField.text;
    }
    
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if (textField.tag == 2000) {
        __block NSString *text = [textField text];
        if ([textField.text isEqualToString:@""] || ( [string isEqualToString:@""] && textField.text.length==1)) {
            self.schemeTypeImageView.image = [CTSUtility getSchmeTypeImage:string];
        }
        
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (text.length>1) {
            self.schemeTypeImageView.image = [CTSUtility getSchmeTypeImage:text];
        }
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        if (newString.length>1) {
            NSString* scheme = [CTSUtility fetchCardSchemeForCardNumber:[newString stringByReplacingOccurrencesOfString:@" " withString:@""]];
            if ([scheme isEqualToString:@"MTRO"]) {
                if (newString.length >= 24) {
                    return NO;
                }
            }
            else{
                if (newString.length >= 20) {
                    return NO;
                }
            }
        }
        
        [textField setText:newString];
        return NO;
        
    }
    else if (textField.tag== 2004) {
        NSString *currentString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        int length = (int)[currentString length];
        if (length > 4) {
            return NO;
        }
    }
    else if (textField.tag==2002) {
        __block NSString *text = [textField text];
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789/"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        NSArray* subStrings = [text componentsSeparatedByString:@"/"];
        int month = [[subStrings objectAtIndex:0] intValue];
        if(month > 12){
            NSString *string=@"";
            string = [string stringByAppendingFormat:@"0%@",text];
            text = string;
        }
        text = [text stringByReplacingOccurrencesOfString:@"/" withString:@""];
        if ([string isEqualToString:@""]) {
            return YES;
        }
        
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 2)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 2 && ![newString containsString:@"/"]) {
                newString = [newString stringByAppendingString:@"/"];
            }
            text = [text substringFromIndex:MIN(text.length, 2)];
        }
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        
        if (newString.length >=6) {
            return NO;
        }
        
        [textField setText:newString];
        
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        else{
            return NO;
        }
    }
    
    return YES;
   
}

#pragma mark - PickerView Delegate Methods

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
        return [array count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {

        return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    currentTextField.text = [array objectAtIndex:row];
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{

        return [array objectAtIndex:row];
//    return nil;
    
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIView *tempView = view;

    UILabel *pickerLabel;
    UIImageView *imageView;
    if (!tempView)
    {
        tempView =[[UIView alloc]init];
        imageView = [[UIImageView alloc] init];
        imageView.frame = CGRectMake(10, 0, 30, 30);
        pickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, -5, 255, 40)];
        pickerLabel.textColor = [UIColor darkGrayColor];
        pickerLabel.font = [UIFont fontWithName:@"Verdana-Semibold" size:15];
        pickerLabel.textAlignment = NSTextAlignmentLeft;
        pickerLabel.backgroundColor = [UIColor clearColor];
        
        [tempView addSubview:imageView];
        [tempView addSubview:pickerLabel];
    }
    
    imageView.image = [CTSUtility fetchBankLogoImageByBankIssuerCode:[[netBankingDict allValues] objectAtIndex:row]];
    [pickerLabel setText:[array objectAtIndex:row]];
    
    
    return tempView;
}

#pragma mark - TableView Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //
    if (tableView==self.saveCardsTableView) {
        return saveCardsArray.count;
    }
    else
        return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView==self.ccddtableView) {
//        NSString *simpleTableIdentifier =[NSString stringWithFormat:@"test%d",(int)indexPath.row];
//        cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//            
//        }
        if (indexPath.row==0) {
            
            GMTextFieldCell *textFieldCell = (GMTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:kInputFieldCellIdentifier];
            textFieldCell.inputTextField.tag = 2000;
            textFieldCell.inputTextField.placeholder = @"Card Number";
            if(NSSTRING_HAS_DATA(self.cccardInfo.cardNumber)) {
                textFieldCell.inputTextField.text = self.cccardInfo.cardNumber;
            } else{
                textFieldCell.inputTextField.text =@"";
            }
            textFieldCell.inputTextField.delegate = self;
            textFieldCell.inputTextField.keyboardType = UIKeyboardTypeNumberPad;
//            self.schemeTypeImageView = (UIImageView *)[cell.contentView viewWithTag:2001];
            
            return textFieldCell;
            
        }
        if (indexPath.row==1) {
            
            GMCardInfoCell *cardInfoCell = (GMCardInfoCell *)[tableView dequeueReusableCellWithIdentifier:kCardInfoCellIdentifier];
            cardInfoCell.cardExpryDateTextField.tag = 2002;
            cardInfoCell.cvvTextField.tag = 2004;
            cardInfoCell.cardExpryDateTextField.delegate = self;
            cardInfoCell.cvvTextField.delegate = self;
            cardInfoCell.cardExpryDateTextField.placeholder =@"MM/YY";
            cardInfoCell.cvvTextField.placeholder =@"CVV";
            if(NSSTRING_HAS_DATA(self.cccardInfo.expiryDate)) {
                cardInfoCell.cardExpryDateTextField.text = self.cccardInfo.expiryDate;
            }else{
                cardInfoCell.cardExpryDateTextField.text =@"";
            }
            if(NSSTRING_HAS_DATA(self.cccardInfo.cvvNumber)) {
                cardInfoCell.cvvTextField.text = self.cccardInfo.cvvNumber;
            }else{
                cardInfoCell.cvvTextField.text =@"";
            }
            
            return cardInfoCell;
            
//            self.expiryDateTextField = (UITextField *)[cell.contentView viewWithTag:2002];
//            self.expiryDateTextField.delegate = self;
////            self.expiryMonthTextField = (UITextField *)[cell.contentView viewWithTag:2002];
////            self.expiryMonthTextField.delegate = self;
////            self.expiryYearTextField = (UITextField *)[cell.contentView viewWithTag:2003];
////            self.expiryYearTextField.delegate = self;
//            self.cvvTextField = (UITextField *)[cell.contentView viewWithTag:2004];
//            self.cvvTextField.delegate = self;
        }
        if (indexPath.row==2) {
            
            GMTextFieldCell *textFieldCell = (GMTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:kInputFieldCellIdentifier];
            textFieldCell.inputTextField.tag = 2006;
            textFieldCell.inputTextField.placeholder = @"Card Owner Name";
            if(NSSTRING_HAS_DATA(self.cccardInfo.ownerName)) {
                textFieldCell.inputTextField.text = self.cccardInfo.ownerName;
            } else{
               textFieldCell.inputTextField.text =@"";
            }
            textFieldCell.inputTextField.delegate = self;
            //            self.schemeTypeImageView = (UIImageView *)[cell.contentView viewWithTag:2001];
            textFieldCell.inputTextField.keyboardType = UIKeyboardTypeDefault;
            return textFieldCell;

            
//            self.ownerNameTextField = (UITextField *)[cell.contentView viewWithTag:2006];
//            self.ownerNameTextField.delegate = self;
            
        }
        if (indexPath.row==3) {
           
            
            GMSaveCardCell *saveCardCell = (GMSaveCardCell *)[tableView dequeueReusableCellWithIdentifier:kSaveCardCellIdentifier];
            saveCardCell.saveSwitchBtn.tag = 2005;
            
            
            [saveCardCell.saveSwitchBtn setOn:self.cccardInfo.isSwitchOn animated:YES];
//            UISwitch *localSwitchView = (UISwitch *)[cell.contentView viewWithTag:2005];
            [saveCardCell.saveSwitchBtn addTarget:self action:@selector(updateSwitchAtIndexPath:)forControlEvents:UIControlEventValueChanged];
            return saveCardCell;
        }
        return nil;
        
    }
    else if (tableView==self.saveCardsTableView){
    
    
//        static NSString *simpleTableIdentifier = @"saveCardIdentifier";
//        
//       cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//        
//        if (cell == nil) {
//            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
//            
//        }
        
        GMSavedCardCell *savedCardCell = (GMSavedCardCell *)[tableView dequeueReusableCellWithIdentifier:kSavedCardCellIdentifier];
        
        
        NSDictionary *tempDict = [saveCardsArray objectAtIndex:indexPath.row];
        savedCardCell.name.text = [tempDict valueForKey:@"name"];
        savedCardCell.number.text = [tempDict valueForKey:@"number"];
        savedCardCell.owner.text = [tempDict valueForKey:@"owner"];
        NSMutableString *string = [[tempDict valueForKey:@"expiryDate"] mutableCopy];
        [string insertString:@"/" atIndex:2];
        savedCardCell.expiryDate.text = string;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([[tempDict valueForKey:@"type"] isEqualToString:@"netbanking"]) {
                savedCardCell.bankLogoImageView.image = [CTSUtility fetchBankLogoImageByBankName:[tempDict valueForKey:@"bank"]];
            }
            else {
                savedCardCell.bankLogoImageView.image = [CTSUtility fetchSchemeImageBySchemeType:[tempDict valueForKey:@"scheme"]];
            }
        });
        return savedCardCell;
    }
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.saveCardsTableView) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        selectedRow = indexPath.row;
        NSDictionary *tempDict = [saveCardsArray objectAtIndex:indexPath.row];
        
        if ([[tempDict valueForKey:@"type"] isEqualToString:@"netbanking"]) {
         [self loadOrPayMoney:nil];
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                UIAlertView *cvvAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter cvv." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok" , nil];
                cvvAlert.tag = 100;
                cvvAlert.alertViewStyle = UIAlertViewStyleSecureTextInput;
                UITextField * cvvTextField = [cvvAlert textFieldAtIndex:0];
                cvvTextField.keyboardType = UIKeyboardTypeNumberPad;
                cvvTextField.placeholder = @"cvv";
                
                [cvvAlert show];
            });
        }
    }
}

#pragma mark - Class Level Methods


+ (CTSBill*)getDPBillFromServer:(NSString *)amount operation:(DPRequestType)type ruleInfo:(CTSRuleInfo *)ruleInfo{
    // Configure your request here.
    NSMutableURLRequest* urlReq=nil;
    
    switch (type) {
        case DPRequestTypeValidate:{
            urlReq = [[NSMutableURLRequest alloc] initWithURL:
                                           [NSURL URLWithString:[NSString stringWithFormat:@"%@?amount=%@&dpOperation=%@&ruleName=%@&alteredAmount=%@",BillUrl,amount,[CardsViewController toDpTypeString:type],ruleInfo.ruleName,ruleInfo.alteredAmount]]];
        }
            break;
        case DPRequestTypeSearchAndApply:{
            
            urlReq = [[NSMutableURLRequest alloc] initWithURL:
                      [NSURL URLWithString:[NSString stringWithFormat:@"%@?amount=%@&dpOperation=%@&ruleName=YaddyBoy10",BillUrl,amount,[CardsViewController toDpTypeString:type]]]];
        }
            break;
        case DPRequestTypeCalculate:{
            urlReq = [[NSMutableURLRequest alloc] initWithURL:
                      [NSURL URLWithString:[NSString stringWithFormat:@"%@?amount=%@&dpOperation=%@&ruleName=%@",BillUrl,amount,[CardsViewController toDpTypeString:type],ruleInfo.ruleName]]];
        }
            break;
        default:
            break;
    }
   
    
    [urlReq setHTTPMethod:@"POST"];
    NSError* error = nil;
    NSData* signatureData = [NSURLConnection sendSynchronousRequest:urlReq
                                                  returningResponse:nil
                                                              error:&error];
    NSString* billJson = [[NSString alloc] initWithData:signatureData
                                               encoding:NSUTF8StringEncoding];
    JSONModelError *jsonError;
    CTSBill* sampleBill = [[CTSBill alloc] initWithString:billJson
                                                    error:&jsonError];
    LogTrace(@"billJson %@",billJson);
    LogTrace(@"signature %@ ", sampleBill);
    //sampleBill.dpSignature = @"f07abf0a768e9f3ee9bed9c0f1eba1c0a2d88db7";
    //sampleBill.merchantTxnId = @"144119346346509";
    return sampleBill;
}

+(NSString *)toDpTypeString:(DPRequestType)type{
    
    NSString *typeString = nil;
    switch (type) {
        case DPRequestTypeValidate:
            typeString = @"validateRule";
            break;
        case DPRequestTypeSearchAndApply:
            typeString = @"searchAndApply";
            break;
        case DPRequestTypeCalculate:
            typeString = @"calculatePricing";
            break;
        default:
            break;
    }
    
    return typeString;
}


-(void)requestPaymentModes{
    [paymentLayer requestLoadMoneyPgSettingsCompletionHandler:^(CTSPgSettings *pgSettings, NSError *error) {
        if(error){
            //handle error
            LogTrace(@"[error localizedDescription] %@ ", [error localizedDescription]);
        }
        else {
            //Vikas
            debitArray = [CTSUtility fetchMappedCardSchemeForSaveCards:[[NSSet setWithArray:pgSettings.debitCard] allObjects] ];
            creditArray = [CTSUtility fetchMappedCardSchemeForSaveCards:[[NSSet setWithArray:pgSettings.creditCard] allObjects] ];
            
            NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
            
            
            LogTrace(@" pgSettings %@ ", pgSettings);
            for (NSString* val in creditArray) {
                LogTrace(@"CC %@ ", val);
            }
            
            for (NSString* val in debitArray) {
                LogTrace(@"DC %@ ", val);
            }
            
            for (NSDictionary* arr in pgSettings.netBanking) {
                //setting the object for Issuer bank code in Dictionary
                [tempDict setObject:[arr valueForKey:@"issuerCode"] forKey:[arr valueForKey:@"bankName"]];
                
                LogTrace(@"bankName %@ ", [arr valueForKey:@"bankName"]);
                LogTrace(@"issuerCode %@ ", [arr valueForKey:@"issuerCode"]);
                
            }
            netBankingDict = tempDict;
            
        }
    }];
}

- (void) setCardInfo{

    CTSPaymentDetailUpdate *tempCardInfo = [[CTSPaymentDetailUpdate alloc] init];
    NSString *cardNumber = [self.cccardInfo.cardNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (segControl.selectedSegmentIndex==0) {
        
        // Update card for card payment.
        CTSElectronicCardUpdate *debitCard = [[CTSElectronicCardUpdate alloc] initDebitCard];
        debitCard.number = cardNumber;
//        debitCard.expiryDate = [NSString stringWithFormat:@"%@/%@",self.expiryMonthTextField.text , self.expiryYearTextField.text];
         debitCard.expiryDate = self.cccardInfo.expiryDate;
        debitCard.scheme =  [CTSUtility fetchCardSchemeForCardNumber:debitCard.number];
        debitCard.ownerName = self.cccardInfo.ownerName;
        debitCard.cvv = self.cccardInfo.cvvNumber;
//        debitCard.name = @"Kotak";
        [tempCardInfo addCard:debitCard];
        
    }
    else if (segControl.selectedSegmentIndex==1) {
        
        // Update card for card payment.
        CTSElectronicCardUpdate *creditCard = [[CTSElectronicCardUpdate alloc] initCreditCard];
        creditCard.number = cardNumber;
        creditCard.expiryDate = self.cccardInfo.expiryDate;
        creditCard.scheme =  [CTSUtility fetchCardSchemeForCardNumber:creditCard.number];
        creditCard.ownerName = self.cccardInfo.ownerName;
        creditCard.cvv = self.cccardInfo.cvvNumber;
        [tempCardInfo addCard:creditCard];
    }
    else if (segControl.selectedSegmentIndex==2){
        // Update bank details for net banking payment.
        CTSNetBankingUpdate* netBank = [[CTSNetBankingUpdate alloc] init];
        NSString *code = [netBankingDict valueForKey:self.netBankCodeTextField.text];
//        NSString *code = [codeDict valueForKey:self.netBankCodeTextField.text];
        netBank.code = code; // Issuer Bank Code
        [tempCardInfo addNetBanking:netBank];
        
    }
    else if (segControl.selectedSegmentIndex==3){
        
        NSDictionary *dict =[saveCardsArray objectAtIndex:selectedRow];
        
        if ([[dict valueForKey:@"type"] isEqualToString:@"netbanking"]) {
            CTSNetBankingUpdate* netBank = [[CTSNetBankingUpdate alloc] init];
            NSString *token =[dict valueForKey:@"token"];
            netBank.token=token;
            [tempCardInfo addNetBanking:netBank];
        }
        else{
            CTSElectronicCardUpdate *instrument = [[CTSElectronicCardUpdate alloc] initCreditCard];
            instrument.cvv= cvvText;
            NSString *token =[dict valueForKey:@"token"];
            instrument.token=token;
            [tempCardInfo addCard:instrument];
        }
        
    }
    
    cardInfo = nil;
    cardInfo = tempCardInfo;

}

#pragma mark - AlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [alertView dismissWithClickedButtonIndex:buttonIndex animated:NO];
    [self.view endEditing:YES];
    
    if (alertView.tag==100){
        
        if (buttonIndex==1) {
            
            UITextField * alertTextField = [alertView textFieldAtIndex:0];
            [alertTextField resignFirstResponder];
            cvvText = alertTextField.text;
            NSDictionary *dict =[saveCardsArray objectAtIndex:selectedRow];
            NSString *token =[dict valueForKey:@"token"];
            
            if(self.landingScreen==0){//Load money with saved card
                [self loadOrPayMoney:nil];
            }
            else{//payment with saved card
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                     [self tokenizedPaymentWithToken:token withCVV:alertTextField.text andWithScheme:[dict valueForKey:@"scheme"]];
                });
            }
            
        }
    }
    else if (alertView.tag==101){
        
        if (buttonIndex==1) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self payUsingDp];
            });
            
        }
    }
    
}


#pragma mark - Reset UI Methods
- (void) resetUI{
    
    self.cccardInfo.cardNumber = @"";
    self.cccardInfo.ownerName = @"";
//    self.expiryMonthTextField.text = @"";
    self.cccardInfo.expiryDate = @"";
//    self.expiryYearTextField.text = @"";
    self.cccardInfo.cvvNumber = @"";
    self.netBankCodeTextField.text = @"Select Bank";
    self.schemeTypeImageView.image = nil;
//    [switchView setOn:NO animated:YES];
    self.cccardInfo.isSwitchOn = NO;
    [self.ccddtableView reloadData];
}

#pragma mark - Dealloc Methods
- (void) dealloc{
    
    self.cccardInfo = nil;
    self.netBankCodeTextField = nil;
    self.loadButton = nil;
    self.pickerView = nil;
    self.indicatorView = nil;
    self.schemeTypeImageView = nil;
  
}


@end
