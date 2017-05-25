//
//  GMMaxCoinsVC.m
//  GrocerMax
//
//  Created by Rahul on 7/6/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import "GMMaxCoinsVC.h"
#import "GMMaxCoinBaseModal.h"
#import "GMMaxCoinsTableViewCell.h"

static NSString * const kGMMaxCoinsTableViewCellID    = @"GMMaxCoinsTableViewCell";

@interface GMMaxCoinsVC ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *lbl_totalPoint;
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@property (strong, nonatomic) GMMaxCoinBaseModal *maxCoinBaseModal;

@end

@implementation GMMaxCoinsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    [self configure];
    [self registerCellsForTableView];
    [self getMaxcoinsDataFromServer];
    
    GMUserModal *userModal = [GMUserModal loggedInUser];
    
    NSMutableDictionary *qaGrapEventDic = [[NSMutableDictionary alloc]init]; if(NSSTRING_HAS_DATA(userModal.userId)){
        [qaGrapEventDic setObject:userModal.userId forKey:kEY_QA_EventParmeter_UserID];
    }
    [[GMSharedClass sharedClass] trakeForQAWithEventame:kEY_QA_EventLabel_Profile_ViewMaxCoins withExtraParameter:qaGrapEventDic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

-(void)configure{

    self.title = @"Max Coins";
    self.tblView.tableFooterView = [UIView new];
}

- (void)registerCellsForTableView {
    
    [self.tblView registerNib:[UINib nibWithNibName:@"GMMaxCoinsTableViewCell" bundle:nil] forCellReuseIdentifier:kGMMaxCoinsTableViewCellID];
}

#pragma mark - Server date

-(void)getMaxcoinsDataFromServer {

    [self showProgress];

    GMUserModal *userModal = [GMUserModal loggedInUser];
    
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(userModal.userId)) {
        [userDic setObject:userModal.userId forKey:kEY_user_id];        
    }
    
    [[GMOperationalHandler handler] getMaxCoinsList:userDic withSuccessBlock:^(GMMaxCoinBaseModal *maxCoinBaseModal) {
        
        self.maxCoinBaseModal = maxCoinBaseModal;
        self.lbl_totalPoint.text = maxCoinBaseModal.totalPoints;
        [self.tblView reloadData];
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        [self removeProgress];
    }];
}

#pragma mark - UITableView Delegates/Datasource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [self.maxCoinBaseModal.maxcoinsListArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 38;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return @"Transactions";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMMaxCoinModal *maxCoinModal = [self.maxCoinBaseModal.maxcoinsListArray objectAtIndex:indexPath.row];
    
    GMMaxCoinsTableViewCell *maxCoinsTableViewCell = [tableView dequeueReusableCellWithIdentifier:kGMMaxCoinsTableViewCellID];
    
    [maxCoinsTableViewCell configerUI:maxCoinModal];
    return maxCoinsTableViewCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}



@end
