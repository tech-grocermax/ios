//
//  GMSearchVC.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 01/10/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMSearchVC.h"
#import "GMSearchResultModal.h"
#import "GMRootPageViewController.h"
#import "GMStateBaseModal.h"
#import "GMTrendingBaseModal.h"
#import "GMSearchKeyWordSavedModal.h"

@interface GMSearchVC ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate> {
    NSString *keyWord;
}

@property (weak, nonatomic) IBOutlet UISearchBar *searchBarView;
@property (weak, nonatomic) IBOutlet UITableView *searchtableView;

@property (strong, nonatomic) NSMutableArray *displayTrendingModalArray;

@end

@implementation GMSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"Search";
    self.searchBarView.delegate = self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithImage:[UIImage backBtnImage]
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(homeButtonPressed:)];
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_TabSearch withCategory:@"" label:nil value:nil];
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_OpenSearch withCategory:@"" label:nil value:nil];
    if(NSSTRING_HAS_DATA(keyWord)) {
        self.searchBarView.text = keyWord;
    }
    self.searchtableView.delegate = self;
    self.searchtableView.dataSource = self;
    
    self.displayTrendingModalArray = [[NSMutableArray alloc]init];
//    self.displayTrendingModalArray = [NSMutableArray arrayWithArray:[[GMSharedClass sharedClass] getTrendingBaseModalArray]];
    
    
    
    
    UIView *footer =
    [[UIView alloc] initWithFrame:CGRectZero];
    self.searchtableView.tableFooterView = footer;
    footer = nil;
    [self.searchtableView reloadData];

}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[GMSharedClass sharedClass] trakScreenWithScreenName:kEY_GA_Search_Screen];
    
    GMSearchKeyWordSavedModal *searchKeyWordSavedModal = [GMSearchKeyWordSavedModal loadSavedTrendingModal];
    
    if(searchKeyWordSavedModal) {
    self.displayTrendingModalArray = [NSMutableArray arrayWithArray:[searchKeyWordSavedModal savedTrendingModalArray]];
        if(self.searchBarView.text){
        [self autoSearch:self.searchBarView.text];
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button action

- (void)homeButtonPressed:(UIBarButtonItem*)sender {
    
    [self.tabBarController setSelectedIndex:0];
}

#pragma mark - Search bar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.searchBarView resignFirstResponder];
    
    if (!NSSTRING_HAS_DATA(self.searchBarView.text) || self.searchBarView.text.length < 3)
    {
        [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"plzEnterKeyword")];
        return;
    }
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:self.searchBarView.text forKey:kEY_keyword];
    
    [self performSearchOnServerWithParam:localDic isBanner:NO];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBarView resignFirstResponder];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self autoSearch:searchText];
    
}

-(void)autoSearch:(NSString *)searchText {
    if([searchText isEqualToString:@""]) {
        //        self.displayTrendingModalArray = [NSMutableArray arrayWithArray:[[GMSharedClass sharedClass] getTrendingBaseModalArray]];
        
        GMSearchKeyWordSavedModal *searchKeyWordSavedModal = [GMSearchKeyWordSavedModal loadSavedTrendingModal];
        
        if(searchKeyWordSavedModal) {
            self.displayTrendingModalArray = [NSMutableArray arrayWithArray:[searchKeyWordSavedModal savedTrendingModalArray]];
        }
        
    }else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.trendingName  beginsWith[cd] %@",searchText];
        //        if(ischecked)
        //        {
        
        GMSearchKeyWordSavedModal *searchKeyWordSavedModal = [GMSearchKeyWordSavedModal loadSavedTrendingModal];
        
        NSMutableArray * array = [[NSMutableArray alloc]init];
        if(searchKeyWordSavedModal) {
            array = [NSMutableArray arrayWithArray:[searchKeyWordSavedModal savedTrendingModalArray]];
        }
        
        //    NSArray *tempArray = [[[GMSharedClass sharedClass] getTrendingBaseModalArray] filteredArrayUsingPredicate:predicate];
        
        NSArray *tempArray = [array filteredArrayUsingPredicate:predicate];
        
        
        self.displayTrendingModalArray = [NSMutableArray arrayWithArray:tempArray];
    }
    [self.searchtableView reloadData];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.view endEditing:YES];
}

#pragma mark - API Task

- (void)performSearchOnServerWithParam:(NSDictionary*)param isBanner:(BOOL)isBanner{
    
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_SearchQuery withCategory:@"" label:[param  objectForKey:kEY_keyword] value:nil];
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Search" label:[param  objectForKey:kEY_keyword]];
    keyWord = [param  objectForKey:kEY_keyword];
    if(isBanner) {
        if([param  objectForKey:kEY_keyword]) {
            self.searchBarView.text = [param  objectForKey:kEY_keyword];
        }
    }
    
    [self showProgress];
    [[GMOperationalHandler handler] search:param withSuccessBlock:^(id responceData) {
        
        [self removeProgress];
        
        GMSearchResultModal *searchResultModal = responceData;
        [self createCategoryModalFromSearchResult:searchResultModal];
        
        
        if (searchResultModal.categorysListArray.count == 0) {
            [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"noResultFound")];
            return;
        }
        
        keyWord = [keyWord stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.trendingName  MATCHES[c] %@",keyWord];
        GMSearchKeyWordSavedModal *searchKeyWordSavedModal = [GMSearchKeyWordSavedModal loadSavedTrendingModal];
        
        NSMutableArray * array = [[NSMutableArray alloc]init];
        if(searchKeyWordSavedModal) {
            array = [NSMutableArray arrayWithArray:[searchKeyWordSavedModal savedTrendingModalArray]];
        }else {
            searchKeyWordSavedModal = [[GMSearchKeyWordSavedModal alloc] initWithSavedTrendingModalArray:[NSMutableArray array]];
            [searchKeyWordSavedModal archiveavedTrendingModal];
        }
        
        NSArray *tempArray = [array filteredArrayUsingPredicate:predicate];
        
        if(tempArray.count==0){
//            self.displayTrendingModalArray = [NSMutableArray arrayWithArray:tempArray];
            GMSearchKeyWordSavedModal *searchKeyWordSavedModal = [GMSearchKeyWordSavedModal loadSavedTrendingModal];
            GMTrendingModal *trendingBaseModal = [[GMTrendingModal alloc]init];
            trendingBaseModal.trendingName = keyWord;
            trendingBaseModal.trendingId = @"-1";
            [searchKeyWordSavedModal.savedTrendingModalArray addObject:trendingBaseModal];
            [searchKeyWordSavedModal archiveavedTrendingModal];
            
        }
        
        
        [self.tabBarController setSelectedIndex:3];

        GMRootPageViewController *rootVC = [[GMRootPageViewController alloc] initWithNibName:@"GMRootPageViewController" bundle:nil];
        rootVC.pageData =(NSMutableArray *) searchResultModal.categorysListArray;
        if(NSSTRING_HAS_DATA(self.searchBarView.text)) {
        rootVC.navigationTitleString = self.searchBarView.text;
        } else if(NSSTRING_HAS_DATA(keyWord)) {
            rootVC.navigationTitleString = keyWord;
        }
        rootVC.rootControllerType = GMRootPageViewControllerTypeProductlistingCategory;
        rootVC.isFromSearch = YES;
        rootVC.productListingFromTypeForGA = GMProductListingFromTypeSearchGA;
        [self.navigationController pushViewController:rootVC animated:YES];

    } failureBlock:^(NSError *error) {
        [self removeProgress];
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
    }];
}

- (void)createCategoryModalFromSearchResult:(GMSearchResultModal *)searchModal {
    
    
    for (GMCategoryModal *catModal in searchModal.categorysListArray) {
        
        NSString *categoryId = catModal.categoryId;
        NSPredicate *pred = [NSPredicate predicateWithBlock:^BOOL(GMProductModal *evaluatedObject, NSDictionary *bindings) {
            
            NSArray *categoriesIdArr = evaluatedObject.categoryIdArray;
            if([categoriesIdArr containsObject:categoryId])
                return YES;
            else
                return NO;
        }];
        NSArray *productListArr = [searchModal.productsListArray filteredArrayUsingPredicate:pred];
        catModal.productListArray = productListArr;
        catModal.totalCount = productListArr.count;
    }
}






#pragma mark - UITableviewDelegate/DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.displayTrendingModalArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *LastCustomIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier: LastCustomIdentifier];
    if (cell== nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LastCustomIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    GMTrendingModal *trendingBaseModal = [self.displayTrendingModalArray objectAtIndex:indexPath.row];
    if(NSSTRING_HAS_DATA(trendingBaseModal.trendingName)){
        cell.textLabel.text = trendingBaseModal.trendingName;
    }else {
       cell.textLabel.text = @"";
    }
    return cell;
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    GMTrendingModal *trendingBaseModal = [self.displayTrendingModalArray objectAtIndex:indexPath.row];
    
    
    if(NSSTRING_HAS_DATA(trendingBaseModal.trendingName)) {
        self.searchBarView.text = trendingBaseModal.trendingName;
        NSMutableDictionary *localDic = [NSMutableDictionary new];
        [localDic setObject:trendingBaseModal.trendingName forKey:kEY_keyword];
        
        [self performSearchOnServerWithParam:localDic isBanner:NO];
    }
    
}
@end
