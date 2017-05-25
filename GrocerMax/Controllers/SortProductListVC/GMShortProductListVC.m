//
//  GMShortProductListVC.m
//  GrocerMax
//
//  Created by Arvind Kumar Gupta on 20/04/16.
//  Copyright © 2016 Deepak Soni. All rights reserved.
//

#import "GMShortProductListVC.h"
#import "GMSortProductListCell.h"

NSString *const kGMSortProductListCell = @"GMSortProductListCell";

@interface GMShortProductListVC ()<UITableViewDataSource,UITableViewDelegate>{
    int selectedIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *sortTableView;

@property (strong, nonatomic) NSMutableArray *sortDatatArray;

@end

@implementation GMShortProductListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.sortDatatArray = [[NSMutableArray alloc]initWithObjects:@"Popularity",@"Discounts",@"Title A to Z",@"Title Z to A",@"Price low to high",@"Price high to low", nil];
    [self registerCellsForTableView];
    self.sortTableView.delegate = self;
    self.sortTableView.dataSource = self;
    selectedIndex = [[GMSharedClass sharedClass]getProductSortIndex];
    [self.sortTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self configerView];
        self.navigationItem.title = @"Sort";
    [[GMSharedClass sharedClass] setTabBarVisible:NO ForController:self animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[GMSharedClass sharedClass] setTabBarVisible:YES ForController:self animated:YES];
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
    
    [self.sortTableView registerNib:[UINib nibWithNibName:@"GMSortProductListCell" bundle:nil] forCellReuseIdentifier:kGMSortProductListCell];
}

-(IBAction)applyButtonPressed:(id)sender{
    [[GMSharedClass sharedClass]setProductSortIndex:[NSString stringWithFormat:@"%d",selectedIndex]];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableviewDelegate/DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.sortDatatArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *sortString = [self.sortDatatArray objectAtIndex:indexPath.row];
    GMSortProductListCell *cell = [tableView dequeueReusableCellWithIdentifier:kGMSortProductListCell];
    
    if(selectedIndex == indexPath.row){
        [cell configerCellViewWithTitle:sortString selected:YES];
    }else{
        [cell configerCellViewWithTitle:sortString selected:NO];
    }
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [GMSortProductListCell getCellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedIndex = (int)indexPath.row;
    [self.sortTableView reloadData];
    //    GMProductDescriptionVC* vc = [[GMProductDescriptionVC alloc] initWithNibName:@"GMProductDescriptionVC" bundle:nil];
    //    vc.modal = self.productBaseModal.productsListArray[indexPath.row];
    //    vc.parentVC = self.parentVC;
    //    [self.navigationController pushViewController:vc animated:YES];
}

@end
