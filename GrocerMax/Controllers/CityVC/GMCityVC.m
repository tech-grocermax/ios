//
//  GMCityVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 23/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMCityVC.h"
#import "GMStateBaseModal.h"
#import "GMCityCell.h"

static NSString *kIdentifierCityCell = @"CityIdentifierCell";

@interface GMCityVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *delhiBtn;

@property (weak, nonatomic) IBOutlet UIButton *gurgaonBtn;

@property (weak, nonatomic) IBOutlet UIButton *noidaBtn;

@property (weak, nonatomic) IBOutlet UITableView *cityTableView;

@property(strong, nonatomic) NSMutableArray *cityArray;

@property(strong, nonatomic) GMCityModal *cityModal;

@end

@implementation GMCityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self registerCellsForTableView];
    [self getLocation];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configerView];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_City_Screen];
    if (self.isCommimgFromHamberger) {
        self.navigationController.navigationBarHidden = NO;
        self.navigationItem.title = @"Pick your city";
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [[GMSharedClass sharedClass] setTabBarVisible:YES ForController:self animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)configerView {
    self.navigationController.navigationBarHidden = YES;
    [[GMSharedClass sharedClass] setTabBarVisible:NO ForController:self animated:YES];
}

#pragma mark - Register Cells
- (void)registerCellsForTableView {
    
    UINib *nib = [UINib nibWithNibName:@"GMCityCell" bundle:[NSBundle mainBundle]];
    [self.cityTableView registerNib:nib forCellReuseIdentifier:kIdentifierCityCell];
}
#pragma mark - Button Action

- (IBAction)actionDelhiBtnClicked:(id)sender {
    self.delhiBtn.selected = YES;
    self.gurgaonBtn.selected = NO;
    self.noidaBtn.selected = NO;
}
- (IBAction)actionGurgaonBtnClicked:(id)sender {
    self.delhiBtn.selected = NO;
    self.gurgaonBtn.selected = YES;
    self.noidaBtn.selected = NO;
}
- (IBAction)actionNoidaBtnClicked:(id)sender {
    self.delhiBtn.selected = NO;
    self.gurgaonBtn.selected = NO;
    self.noidaBtn.selected = YES;
}
- (void)cityBtnPressed:(GMButton *)sender {
    if(sender.selected)
        return;
    
    GMCityModal *tempCityModal = sender.cityModal;
    [tempCityModal setIsSelected:YES];
    [self.cityModal setIsSelected:NO];
    self.cityModal = tempCityModal;
    [self.cityTableView reloadData];
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_CitySelection withCategory:@"" label:tempCityModal.cityName value:nil];
    
    
}
- (IBAction)actionSaveBtnClicked:(id)sender {
    
    if(self.cityModal == nil) {
        GMCityModal *cityModal = [[GMCityModal alloc]init];
        if(self.delhiBtn.selected){
            cityModal.cityId = @"2";
            cityModal.cityName = @"Delhi";
            cityModal.stateId = @"485";
            cityModal.stateName = @"Delhi";
        }
        else if(self.gurgaonBtn.selected){
            cityModal.cityId = @"1";
            cityModal.cityName = @"Gurgaon";
            cityModal.stateId = @"487";
            cityModal.stateName = @"Haryana";
        }
        else {
            cityModal.cityId = @"3";
            cityModal.cityName = @"Noida";
            cityModal.stateId = @"486";
            cityModal.stateName = @"Uttar Pradesh";
        }
        self.cityModal = cityModal;
    }
    
    if([GMCityModal selectedLocation]) {
        
        GMCityModal *tempCityModal = [GMCityModal selectedLocation];
        if(![tempCityModal.cityId isEqualToString:self.cityModal.cityId]) {
            [[GMSharedClass sharedClass] clearCart];
            [self.tabBarController updateBadgeValueOnCartTab];
        }
    }
    
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_SaveCity withCategory:@"" label:self.cityModal.cityName value:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
     if(NSSTRING_HAS_DATA(self.cityModal.storeId)) {
        [defaults setObject:self.cityModal.storeId forKey:@"storeId"];
    }
    [defaults synchronize];
    
    [self.cityModal persistLocation];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - TableView DataSource and Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return [self.cityArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    GMCityCell *cityCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierCityCell];
    
    GMCityModal *cityModal = [self.cityArray objectAtIndex:indexPath.row];
    cityCell.tag = indexPath.row;
    [cityCell configureCellWithData:cityModal];
    
    [cityCell.cityBtn addTarget:self action:@selector(cityBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return cityCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [GMCityCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Request Methods

- (void)getLocation {
   
    [self showProgress];
    [[GMOperationalHandler handler] getLocation:nil  withSuccessBlock:^(GMStateBaseModal *responceData) {
        self.cityArray = (NSMutableArray *)responceData.cityArray;
        if(self.cityArray.count>0) {
            if(self.isCommimgFromHamberger) {
            GMCityModal *tempCityModal = [GMCityModal selectedLocation];
                if(NSSTRING_HAS_DATA(tempCityModal.cityId))  {
                    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF.cityId == %@", tempCityModal.cityId];
                    NSArray *SelectedCityArray =  [[self.cityArray filteredArrayUsingPredicate:pred] mutableCopy];
                    if(SelectedCityArray.count>0) {
                        self.cityModal = [SelectedCityArray objectAtIndex:0];
                        [self.cityModal setIsSelected:YES];
                        [self.cityTableView reloadData];
                    } else {
                        self.cityModal = [self.cityArray objectAtIndex:0];
                        [self.cityModal setIsSelected:YES];
                        [self.cityTableView reloadData];
                    }
                } else {
                    self.cityModal = [self.cityArray objectAtIndex:0];
                    [self.cityModal setIsSelected:YES];
                    [self.cityTableView reloadData];
                }
               
                
            } else {
                self.cityModal = [self.cityArray objectAtIndex:0];
                [self.cityModal setIsSelected:YES];
                [self.cityTableView reloadData];
            }
            
        }
        else
        {
            self.gurgaonBtn.hidden = FALSE;
            self.gurgaonBtn.hidden = FALSE;
            self.gurgaonBtn.hidden = FALSE;
            self.cityTableView.hidden = TRUE;
        }
        
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        [[GMSharedClass sharedClass] showErrorMessage:@"Somthing Wrong !"];
        self.gurgaonBtn.hidden = FALSE;
        self.gurgaonBtn.hidden = FALSE;
        self.gurgaonBtn.hidden = FALSE;
        self.cityTableView.hidden = TRUE;
        [self removeProgress];
    }];
}

@end
