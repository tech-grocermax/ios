//
//  GMDeliveryDetailVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 20/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMDeliveryDetailVC.h"
#import "GMDeliveryDetailCell.h"
#import "GMTimeSloteModal.h"
#import "GMTimeSlotBaseModal.h"
#import "GMDeliveryDateTimeSlotModal.h"
#import "GMPaymentVC.h"
#import "NSDateFormatter+Extend.h"
#import "GMStateBaseModal.h"

static NSString *kIdentifierDeliveryDetailCell = @"deliveryDetailIdentifierCell";

@interface GMDeliveryDetailVC ()
{
    NSInteger selectedDateIndex;
    NSString *selectedDate;
}
@property (strong, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UIButton *preSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextSelectBtn;


@property (weak, nonatomic) IBOutlet UILabel *selectedDateLbl;
@property (strong, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UITableView *timeSloteTableView;

@property (nonatomic, strong) GMTimeSloteModal *selectedTimeSlotModal;

@property (weak, nonatomic) IBOutlet UILabel *youShavedLbl;

@property (weak, nonatomic) IBOutlet UILabel *totalPriceLbl;

@end

@implementation GMDeliveryDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerCellsForTableView];
    selectedDateIndex = 0;
    [self.timeSloteTableView setBackgroundColor:[UIColor colorWithRed:244.0/256.0 green:244.0/256.0 blue:244.0/256.0 alpha:1]];
    self.dateTimeSloteModalArray = [[NSMutableArray alloc]init];;
    [self getDateAndTimeSlot];
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Delivery details" label:@""];
    
    [self configureAmountView];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Delivery Detail";
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_CartDeliveryDetail_Screen];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMDeliveryDetailCell" bundle:[NSBundle mainBundle]];
    [self.timeSloteTableView registerNib:nib forCellReuseIdentifier:kIdentifierDeliveryDetailCell];
    
}

#pragma mark - GETTER/SETTER Methods

- (void)setDateLbl:(UILabel *)dateLbl {
    
    _dateLbl = dateLbl;
    [_dateLbl.layer setCornerRadius:10.0];
    [_dateLbl setBackgroundColor:[UIColor gmRedColor]];
    [_dateLbl setClipsToBounds:YES];
}

- (void)setTimeLbl:(UILabel *)timeLbl {
    
    _timeLbl = timeLbl;
    [_timeLbl.layer setCornerRadius:10.0];
    [_timeLbl setBackgroundColor:[UIColor gmRedColor]];
    [_timeLbl setClipsToBounds:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Button Action Methods
- (IBAction)actionProceed:(id)sender {
    
    if(self.checkOutModal.timeSloteModal) {
        
        NSString *userName = @"";
        GMUserModal *userModal = [GMUserModal loggedInUser];
        if(userModal != nil && NSSTRING_HAS_DATA(userModal.firstName) && NSSTRING_HAS_DATA(userModal.userId)){
            userName = [NSString stringWithFormat:@"%@/%@",userModal.firstName,userModal.userId];
            
        }else if(userModal != nil && NSSTRING_HAS_DATA(userModal.firstName)){
            userName = [NSString stringWithFormat:@"%@",userModal.firstName];
        }else if(userModal != nil && NSSTRING_HAS_DATA(userModal.userId)){
            userName = [NSString stringWithFormat:@"%@",userModal.userId];
        }
        
        
        [[GMSharedClass sharedClass] trakeEventWithNameNew:kEY_GA_EventAction_Delivery_Slot withCategory:kEY_GA_Category_Checkout_Funnel label:userName];
        
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_ProceedPaymentMethod withCategory:@"" label:nil value:nil];
        
        
        NSMutableDictionary *qaGrapEventDic = [[NSMutableDictionary alloc]init];
        if(NSSTRING_HAS_DATA(userModal.userId)){
            [qaGrapEventDic setObject:userModal.userId forKey:kEY_QA_EventParmeter_UserID];
        }
        [qaGrapEventDic setObject:self.checkOutModal.timeSloteModal.firstTimeSlote forKey:kEY_QA_EventParmeter_DeliverySlot];
        [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_CheckOutDelivery withExtraParameter:qaGrapEventDic];
        
        GMPaymentVC *paymentVC = [GMPaymentVC new];
        paymentVC.checkOutModal = self.checkOutModal;
        [self.navigationController pushViewController:paymentVC animated:YES];
    } else {
                    [[GMSharedClass sharedClass] showErrorMessage:@"Select Time sloat."];
    }
    
    
    //
}
- (IBAction)actionPriviouesDate:(id)sender {
    
    if(selectedDateIndex!=0 && self.dateTimeSloteModalArray.count>0)
    {
        GMDeliveryDateTimeSlotModal *deliveryDateTimeSlotModal = [self.dateTimeSloteModalArray objectAtIndex:selectedDateIndex-1];
        
//        NSDate *deliveryDate = [[NSDateFormatter dateFormatter_yyyy_MM_dd] dateFromString:deliveryDateTimeSlotModal.deliveryDate];
//        NSString *timeStr = [[NSDateFormatter dateFormatter_DD_MMM_YYYY] stringFromDate:deliveryDate];
        NSString *delecryDate = [[GMSharedClass sharedClass] getDeliveryDate:deliveryDateTimeSlotModal.deliveryDate];
        self.dateLbl.text = delecryDate;//timeStr;
        selectedDate = deliveryDateTimeSlotModal.deliveryDate;
//        self.selectedDateLbl.text = timeStr;
//        self.dateLbl.text = deliveryDateTimeSlotModal.deliveryDate;
        self.selectedDateLbl.text = delecryDate;
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.isSelected == YES"];
        NSArray *arry = [deliveryDateTimeSlotModal.timeSlotModalArray filteredArrayUsingPredicate:pred];
        if(arry.count>0)
        {
            GMTimeSloteModal *timeSloteModal =[arry objectAtIndex:0];
            timeSloteModal.deliveryDate = deliveryDateTimeSlotModal.deliveryDate;
            self.selectedTimeSlotModal = timeSloteModal;
            self.checkOutModal.timeSloteModal = timeSloteModal;
            self.timeLbl.text = timeSloteModal.firstTimeSlote;
            [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_SlotSelect withCategory:@"" label:timeSloteModal.firstTimeSlote value:nil];
        } else {
            self.checkOutModal.timeSloteModal = nil;
        }
        
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_DateSelect withCategory:@"" label:deliveryDateTimeSlotModal.deliveryDate value:nil];
        selectedDateIndex = selectedDateIndex-1;
        [self.timeSloteTableView reloadData];
    }
}
- (IBAction)actionNextDate:(id)sender {
    if(selectedDateIndex < 6 && self.dateTimeSloteModalArray.count>0)
    {
        GMDeliveryDateTimeSlotModal *deliveryDateTimeSlotModal = [self.dateTimeSloteModalArray objectAtIndex:selectedDateIndex+1];
//        self.dateLbl.text = deliveryDateTimeSlotModal.deliveryDate;
        
        NSString *delecryDate = [[GMSharedClass sharedClass] getDeliveryDate:deliveryDateTimeSlotModal.deliveryDate];
        self.dateLbl.text = delecryDate;
        selectedDate = deliveryDateTimeSlotModal.deliveryDate;
        self.selectedDateLbl.text = delecryDate;
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.isSelected == YES"];
        NSArray *arry = [deliveryDateTimeSlotModal.timeSlotModalArray filteredArrayUsingPredicate:pred];
        if(arry.count>0)
        {
           GMTimeSloteModal *timeSloteModal =[arry objectAtIndex:0];
            self.selectedTimeSlotModal = timeSloteModal;
            timeSloteModal.deliveryDate = deliveryDateTimeSlotModal.deliveryDate;
            self.checkOutModal.timeSloteModal = timeSloteModal;
            self.timeLbl.text = timeSloteModal.firstTimeSlote;
            [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_SlotSelect withCategory:@"" label:timeSloteModal.firstTimeSlote value:nil];
        } else {
            self.checkOutModal.timeSloteModal = nil;
        }
        selectedDateIndex = selectedDateIndex+1;
        
        [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_DateSelect withCategory:@"" label:deliveryDateTimeSlotModal.deliveryDate value:nil];
        
        
        [self.timeSloteTableView reloadData];
    }
}

-(void)timeSlotButtonTapped:(GMButton *)sender {
    
    GMTimeSloteModal *timeSloteModal = sender.timeSlotModal;
    if(timeSloteModal.isSloatFull || sender.selected)
        return;
    timeSloteModal.deliveryDate= selectedDate;
    self.checkOutModal.timeSloteModal = timeSloteModal;
    
    if(self.selectedTimeSlotModal)
       [self.selectedTimeSlotModal setIsSelected:NO];
    
    [timeSloteModal setIsSelected:YES];
    self.selectedTimeSlotModal = timeSloteModal;
    self.timeLbl.text = timeSloteModal.firstTimeSlote;
    [self.timeSloteTableView reloadData];
    
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_SlotSelect withCategory:@"" label:timeSloteModal.firstTimeSlote value:nil];
    
}

//Use to fill the timeslot modal into array from base modal array
- (void)setDataInArray:( NSArray*)array {
    NSString *date = @"";
    BOOL isselected = FALSE;
    GMDeliveryDateTimeSlotModal *deliveryDateTimeSlotModal;
    for(int i= 0; i<array.count;i++) {
        GMDeliveryTimeSlotModal *deliveryTimeSlotModal = [array objectAtIndex:i];
        if(![date isEqualToString:deliveryTimeSlotModal.deliveryDate]) {
            deliveryDateTimeSlotModal = [[GMDeliveryDateTimeSlotModal alloc]init];
            isselected = FALSE;
            deliveryDateTimeSlotModal.deliveryDate = deliveryTimeSlotModal.deliveryDate;
            deliveryDateTimeSlotModal.timeSlotModalArray = [[NSMutableArray alloc]init];
            date = deliveryTimeSlotModal.deliveryDate;
            
            GMTimeSloteModal *timeSloteModal = [[GMTimeSloteModal alloc]init];
            timeSloteModal.firstTimeSlote = deliveryTimeSlotModal.timeSlot;
            if([deliveryTimeSlotModal.isAvailable intValue] == 0) {
                timeSloteModal.isSloatFull = YES;
                timeSloteModal.isSelected = FALSE;
            }
            else {
                timeSloteModal.isSloatFull = NO;
                if(!isselected) {
                    timeSloteModal.isSelected = TRUE;
                    isselected = TRUE;
                }
                else {
                    timeSloteModal.isSelected = FALSE;
                }
            }
            [deliveryDateTimeSlotModal.timeSlotModalArray addObject:timeSloteModal];
            [self.dateTimeSloteModalArray addObject:deliveryDateTimeSlotModal];
        }
        else {
            GMTimeSloteModal *timeSloteModal = [[GMTimeSloteModal alloc]init];
            timeSloteModal.firstTimeSlote = deliveryTimeSlotModal.timeSlot;
            if([deliveryTimeSlotModal.isAvailable intValue] == 0) {
                timeSloteModal.isSloatFull = YES;
                timeSloteModal.isSelected = FALSE;
            }
            else {
                timeSloteModal.isSloatFull = NO;
                if(!isselected) {
                    timeSloteModal.isSelected = TRUE;
                    isselected = TRUE;
                }
                else {
                    timeSloteModal.isSelected = FALSE;
                }
            }
            [deliveryDateTimeSlotModal.timeSlotModalArray addObject:timeSloteModal];
        }
    }
    
    if(self.dateTimeSloteModalArray.count>0) {
        GMDeliveryDateTimeSlotModal *deliveryDateTimeSlotModal = [self.dateTimeSloteModalArray objectAtIndex:0];
        selectedDateIndex = 0;
//        self.dateLbl.text = deliveryDateTimeSlotModal.deliveryDate;
        NSString *delecryDate = [[GMSharedClass sharedClass] getDeliveryDate:deliveryDateTimeSlotModal.deliveryDate];
        self.dateLbl.text = delecryDate;
        selectedDate = deliveryDateTimeSlotModal.deliveryDate;
        self.selectedDateLbl.text = delecryDate;
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.isSelected == YES"];
        NSArray *arry = [deliveryDateTimeSlotModal.timeSlotModalArray filteredArrayUsingPredicate:pred];
        if(arry.count>0) {
            GMTimeSloteModal *timeSloteModal =[arry objectAtIndex:0];
            self.selectedTimeSlotModal = timeSloteModal;
            timeSloteModal.deliveryDate = deliveryDateTimeSlotModal.deliveryDate;
            GMDeliveryDateTimeSlotModal *deliveryDateTimeSlotModal = [self.dateTimeSloteModalArray objectAtIndex:0];
            
            
            
            for(int timeslotIndex = 0; timeslotIndex<deliveryDateTimeSlotModal.timeSlotModalArray.count; timeslotIndex++ ) {
                GMTimeSloteModal *checkSloatTimeSloteModal = [deliveryDateTimeSlotModal.timeSlotModalArray objectAtIndex:timeslotIndex];
                
                if([timeSloteModal.firstTimeSlote isEqualToString:checkSloatTimeSloteModal.firstTimeSlote]) {
                    self.checkOutModal.timeSloteModal = timeSloteModal;
                    break;
                } else {
                    self.checkOutModal.timeSloteModal = nil;
                }
            }
            
            
            
            self.timeLbl.text = timeSloteModal.firstTimeSlote;
            
        }else {
            self.checkOutModal.timeSloteModal = nil;
        }
    }else {
        self.checkOutModal.timeSloteModal = nil;
    }
}

- (void)configureAmountView {
    
    if(self.checkOutModal.cartDetailModal.shippingAmount.doubleValue <= 0) {
        [self.totalPriceLbl setText:[NSString stringWithFormat:@""]];
    }else{
        [self.totalPriceLbl setText:[NSString stringWithFormat:@"Shipping: ₹%.2f\n", self.self.checkOutModal.cartDetailModal.shippingAmount.doubleValue]];
    }
    [self.totalPriceLbl setText:[NSString stringWithFormat:@"%@Total: ₹%.2f", self.totalPriceLbl.text,self.checkOutModal.cartDetailModal.grandTotal.doubleValue]];
    
    double savingAmount = [self getSavedAmount];
    [self.youShavedLbl setText:[NSString stringWithFormat:@"₹%.2f", savingAmount]];
    
}

- (double)getSavedAmount {
    
    double saving = 0;
    for (GMProductModal *productModal in self.checkOutModal.cartDetailModal.productItemsArray) {
        
        saving += productModal.productQuantity.doubleValue * (productModal.Price.doubleValue - productModal.sale_price.doubleValue);
    }
    if(NSSTRING_HAS_DATA(self.checkOutModal.cartDetailModal.discountAmount))
        saving = saving - self.checkOutModal.cartDetailModal.discountAmount.doubleValue;
    return saving;
}

#pragma mark Request Methods

- (void)getDateAndTimeSlot {
    
    NSArray *array = self.timeSlotBaseModal.timeSlotArray;
    [self setDataInArray:array];
    
    if(self.checkOutModal.timeSloteModal) {
        [self.timeSloteTableView reloadData];
    }else {
        for(int index = 0; index<7; index ++){
            [self actionNextDate:nil];
            if(self.checkOutModal.timeSloteModal) {
                [self.timeSloteTableView reloadData];
                break;
            }
        }
        
    }
    
    
    
//        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
//    
//        [dataDic setObject:@"13807" forKey:kEY_userid];
//        [self showProgress];
//        [[GMOperationalHandler handler] getAddressWithTimeSlot:dataDic withSuccessBlock:^(GMTimeSlotBaseModal *responceData) {
//             self.timeSlotBaseModal = responceData;
//            NSArray *array = self.timeSlotBaseModal.timeSlotArray;
//            [self setDataInArray:array];
//            [self.timeSloteTableView reloadData];
//            [self removeProgress];
//            
//        } failureBlock:^(NSError *error) {
//            [[GMSharedClass sharedClass] showErrorMessage:@"Somthing Wrong !"];
//            [self removeProgress];
//            
//        }];
}


#pragma mark TableView DataSource and Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(self.dateTimeSloteModalArray.count>selectedDateIndex)
    {
        GMDeliveryDateTimeSlotModal *deliveryDateTimeSlotModal = [self.dateTimeSloteModalArray objectAtIndex:selectedDateIndex];
        
        return [deliveryDateTimeSlotModal.timeSlotModalArray count]%2==0? [deliveryDateTimeSlotModal.timeSlotModalArray count]/2 :[deliveryDateTimeSlotModal.timeSlotModalArray count]/2+1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMDeliveryDetailCell *deliveryDetailCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierDeliveryDetailCell];
    
    NSInteger index = indexPath.row*2;
    GMDeliveryDateTimeSlotModal *deliveryDateTimeSlotModal = [self.dateTimeSloteModalArray objectAtIndex:selectedDateIndex];
    
    GMTimeSloteModal *timeSloteModal = [deliveryDateTimeSlotModal.timeSlotModalArray objectAtIndex:index];
    GMTimeSloteModal *secondTimeSloteModal ;
    if(deliveryDateTimeSlotModal.timeSlotModalArray.count>index+1)
    {
        secondTimeSloteModal = [deliveryDateTimeSlotModal.timeSlotModalArray objectAtIndex:index+1];
    }
    
    
    deliveryDetailCell.selectionStyle = UITableViewCellSelectionStyleNone;
    deliveryDetailCell.tag = indexPath.row;
    
    [deliveryDetailCell.firstTimeBtn addTarget:self action:@selector(timeSlotButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [deliveryDetailCell.firstTimeBtn setExclusiveTouch:YES];
    
    
    [deliveryDetailCell.secondTimeBtn addTarget:self action:@selector(timeSlotButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [deliveryDetailCell.secondTimeBtn setExclusiveTouch:YES];
    
    [deliveryDetailCell configerViewWithData:timeSloteModal withSecondModal:secondTimeSloteModal];
    return deliveryDetailCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
