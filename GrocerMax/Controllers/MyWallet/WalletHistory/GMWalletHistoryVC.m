//
//  GMWalletHistoryVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 15/12/15.
//  Copyright © 2015 Deepak Soni. All rights reserved.
//

#import "GMWalletHistoryVC.h"
#import "GMWalletHistoryCell.h"
#import "GMWalletOrderModal.h"
#import "GMOrderDetailHeaderView.h"

static NSString *kIdentifierWalletOrderHistoryCell = @"WalletOrderHistoryIdentifierCell";

static NSString *kIdentifierWalletOrderHeader = @"WalletOrderIdentifierHeader";


@interface GMWalletHistoryVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString *messageString;
}
@property (weak, nonatomic) IBOutlet UITableView *walletOrderHistoryTableView;

@property(nonatomic, strong) NSMutableArray *walletOrderHistoryDataArray;

@end

@implementation GMWalletHistoryVC
@synthesize walletTotalPrice;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    messageString = @"Fetching your wallet history from server.";
    UIView *footer =
    [[UIView alloc] initWithFrame:CGRectZero];
    self.walletOrderHistoryTableView.tableFooterView = footer;
    footer = nil;
    
    [self registerCellsForTableView];
    [self getWalletHistoryDataFromServer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.title = @"Transactions";
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_WalletHistory_Screen];
    //    [self configrationUI];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Register Cells
- (void)registerCellsForTableView {
    self.walletOrderHistoryDataArray = [[NSMutableArray alloc]init];
    
    UINib *nib = [UINib nibWithNibName:@"GMWalletHistoryCell" bundle:[NSBundle mainBundle]];
    [self.walletOrderHistoryTableView registerNib:nib forCellReuseIdentifier:kIdentifierWalletOrderHistoryCell];
    
    nib = [UINib nibWithNibName:@"GMOrderDetailHeaderView" bundle:[NSBundle mainBundle]];
    [self.walletOrderHistoryTableView registerNib:nib forHeaderFooterViewReuseIdentifier:kIdentifierWalletOrderHeader];
}



#pragma mark - TableView DataSource and Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.walletOrderHistoryDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GMWalletHistoryCell *walletOrderHistoryCell = [tableView dequeueReusableCellWithIdentifier:kIdentifierWalletOrderHistoryCell];
    walletOrderHistoryCell.tag = indexPath.row;
    GMWalletOrderHistoryModal *walletOrderHistoryModal  = [self.walletOrderHistoryDataArray objectAtIndex:indexPath.row];
    
    [walletOrderHistoryCell configerViewWithData:walletOrderHistoryModal];
    
    return walletOrderHistoryCell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(self.walletOrderHistoryDataArray.count>0) {
        return 42.0f;
    }
    else {
        return tableView.frame.size.height;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(self.walletOrderHistoryDataArray.count>0) {
        UIView *headerView;
        GMOrderDetailHeaderView *header  = [tableView dequeueReusableHeaderFooterViewWithIdentifier:kIdentifierWalletOrderHeader];
        if (!header) {
            header = [[GMOrderDetailHeaderView alloc] initWithReuseIdentifier:kIdentifierWalletOrderHeader];
        }
        
        if(NSSTRING_HAS_DATA(self.walletTotalPrice)) {
        [header congigerHeaderData:[NSString stringWithFormat:@"Balance ₹%@",self.self.walletTotalPrice]];
        } else {
            [header congigerHeaderData:[NSString stringWithFormat:@"Balance ₹0.00"]];
        }
       
        headerView = header;
        return headerView;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, CGRectGetHeight(tableView.bounds))];
    [headerView setBackgroundColor:[UIColor clearColor]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, CGRectGetHeight(tableView.bounds))];
    [headerLabel setTextColor:[UIColor darkTextColor]];
    [headerLabel setFont:[UIFont systemFontOfSize:16.0f]];
    [headerLabel setTextAlignment:NSTextAlignmentCenter];
    [headerView addSubview:headerLabel];
    [headerLabel setText:messageString];
    
    return headerView;
}

#pragma mark - Server date
-(void)getWalletHistoryDataFromServer {
    [self showProgress];
    
    //staging.grocermax.com/api/getwalletbalance?CustId=
    GMUserModal *userModal = [GMUserModal loggedInUser];
    
    NSMutableDictionary *userDic = [[NSMutableDictionary alloc]init];
    if(NSSTRING_HAS_DATA(userModal.email))
        [userDic setObject:userModal.email forKey:kEY_email];
    if(NSSTRING_HAS_DATA(userModal.userId)) {
        [userDic setObject:userModal.userId forKey:kEY_userid];
        [userDic setObject:userModal.userId forKey:@"CustId"];
    }
    
    [[GMOperationalHandler handler] getUserWalletHistory:userDic withSuccessBlock:^(NSArray *responceData) {
        messageString = @"No transaction history found.";
        [self.walletOrderHistoryDataArray addObjectsFromArray:responceData];
        [self.walletOrderHistoryTableView reloadData];
        [self removeProgress];
        
    } failureBlock:^(NSError *error) {
        [self removeProgress];
    }];
}

@end
