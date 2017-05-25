//
//  GMRootPageViewController.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 18/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMRootPageViewController.h"
#import "GMRootPageModelController.h"
#import "GMStateBaseModal.h"

CGFloat originY = 0.0; //for all btn
CGFloat btnHeight = 40.0; //same as scrollview

@interface GMRootPageViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSMutableArray *btnsArray;
@property (strong , nonatomic) UIView *selectedStripView;
@property (nonatomic) NSInteger currentPageIndex;
@property (strong, nonatomic) GMRootPageModelController *modelController;

@end

@implementation GMRootPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //*******
#warning Remove "ALL" Tab - 28/10/2015
    
    if (!self.isFromSearch && self.pageData.count>0){
        [self.pageData removeObjectAtIndex:0];
    }
    
    // ****End
    
    self.modelController = [[GMRootPageModelController alloc] init];
    self.modelController.modelPageData = self.pageData;
    self.modelController.rootControllerType = self.rootControllerType;
    self.modelController.rootPageViewController = self;
    self.modelController.productListingFromTypeForGA = self.productListingFromTypeForGA;
//    self.title = [self.modelController titleNameFormModal:self.pageData[0]];// title of VC
    self.title = self.navigationTitleString;
    
//    self.cartModal = [GMCartModal loadCart];
//    if(!self.cartModal)
//        self.cartModal = [[GMCartModal alloc] initWithCartItems:[NSMutableArray array]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5* NSEC_PER_SEC), dispatch_get_main_queue(), ^{
       
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self setUpTopBar];
            [self configureView];
        });
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.cartModal = [GMCartModal loadCart];
    if(!self.cartModal)
        self.cartModal = [[GMCartModal alloc] initWithCartItems:[NSMutableArray array]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.topScrollView.contentOffset = CGPointZero;
}

#pragma mark - SetUp View

-(void)configureView{
        
    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;

    NSArray *viewControllers = @[[self.modelController viewControllerAtIndex:0]];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [[self.pageViewController view] setFrame:CGRectMake(0, btnHeight, kScreenWidth, kScreenHeight - 64 - btnHeight - 49)];
    
    [self.pageViewController didMoveToParentViewController:self];
    
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}

-(void)setUpTopBar{
    
    self.btnsArray = [NSMutableArray new];
    self.selectedStripView = [UIView new];
    self.selectedStripView.backgroundColor = [UIColor whiteColor];
    self.currentPageIndex = 0;
    
    CGFloat originX = 0;
    
    UIColor *rdColor = [UIColor clearColor];//[UIColor colorFromHexString:@"#EE2D09"];
    self.topScrollView.backgroundColor = [UIColor colorFromHexString:@"#EE2D09"];
    
    for(int i = 0 ;i<self.pageData.count;i++)
    {
        NSString *title = @"";//@"All"; Remove ALL Tab - 28/10/2015
//        if(self.isFromSearch)
//            title = [self.modelController titleNameFormModal:self.pageData[i]];
//        if (i != 0 ) //Remove ALL Tab - 28/10/2015
        
        title = [self.modelController titleNameFormModal:self.pageData[i]];
        
        CGFloat width = [self getBoundingWidthOfText:title];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(originX, originY, width, btnHeight);
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorFromHexString:@"#fab0a2"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [button.titleLabel setFont:FONT_REGULAR(16)];
        [button addTarget:self action:@selector(segmentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        button.backgroundColor = rdColor;
        [self.topScrollView addSubview:button];
        
        [self.btnsArray addObject:button];
        
        originX += width;
    }
    
    // 4/10/2015
//    if (originX < kScreenWidth) {
//        
//        CGFloat extraPaddingInEachBtn = (kScreenWidth - originX)/self.pageData.count;
//        
//        originX = 0;
//        
//        for (UIButton *btn in self.btnsArray) {
//            CGRect oldFrm = btn.frame;
//            oldFrm.origin.x = originX;
//            oldFrm.size.width += extraPaddingInEachBtn;
//            btn.frame = oldFrm;
//            
//            originX += oldFrm.size.width;
//        }
//    }
    
    self.topScrollView.delegate = self;
    [self.topScrollView setContentSize:CGSizeMake(originX, self.topScrollView.frame.size.height)];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self selectedSection:0];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.modelController indexOfViewController:viewController];
    
    if (index != NSNotFound) {
        [self selectedSection:index];
    }
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    
    
    
    
    if(self.rootControllerType == GMRootPageViewControllerTypeProductlisting) {
        GMCityModal *cityModal = [GMCityModal selectedLocation];
        NSString *title = @"";
        title = [self.modelController titleNameFormModal:self.pageData[index]];
            [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"L3" label:title];
    }
    return [self.modelController viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self.modelController indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    [self selectedSection:index];
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    
    if(self.rootControllerType == GMRootPageViewControllerTypeProductlisting) {
        GMCityModal *cityModal = [GMCityModal selectedLocation];
        NSString *title = @"";
        title = [self.modelController titleNameFormModal:self.pageData[index]];
        [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"L3" label:title];
    }
    
    return [self.modelController viewControllerAtIndex:index];
}

#pragma mark - UIPageViewController delegate methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation {
    // Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
    UIViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = @[currentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.pageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView setContentOffset: CGPointMake(scrollView.contentOffset.x, 0)];
}

#pragma mark -

-(CGFloat)getBoundingWidthOfText:(NSString*)str{
    
    NSDictionary *attributes = @{NSFontAttributeName: FONT_BOLD(16)};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, btnHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    
    return (rect.size.width + 20);// padding 20
}

-(void)segmentButtonAction:(UIButton *)button {
    
    [self selectedSection:button.tag];
    __weak typeof(self) weakSelf = self;

    NSInteger tempIndex = self.currentPageIndex;
    if(button.tag == self.currentPageIndex) {
        return;
    }
    
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    
    NSString *title = @"";
    
    
    switch (self.rootControllerType) {
        case  GMRootPageViewControllerTypeProductlisting:
        {
            title = [self.modelController titleNameFormModal:self.pageData[button.tag]];
            [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"L3" label:title];
        }
            break;
        case GMRootPageViewControllerTypeOffersByDealTypeListing:
        {
            title = [self.modelController titleNameFormModal:self.pageData[button.tag]];
            title = [NSString stringWithFormat:@"%@-%@",self.navigationTitleString,title];
            
            [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Category Deals" label:title];
        }
            break;
        case GMRootPageViewControllerTypeDealCategoryTypeListing:
        {
            title = [self.modelController titleNameFormModal:self.pageData[button.tag]];
            title = [NSString stringWithFormat:@"%@-%@",title,self.navigationTitleString];
            if(self.isFromDrawerDeals) {
                [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Drawer - Deal Category L2" label:title];
            } else {
                [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Deal Category L2" label:title];
            }
        }
            break;
            
        default:
            break;
    }
    

    
    
    
    if (button.tag > tempIndex) {
        
        [self.pageViewController setViewControllers:@[[self.modelController viewControllerAtIndex:button.tag]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
            if (finished) {
                weakSelf.currentPageIndex = button.tag;
            }
        }];
        
//         scroll through all the Views between the two points
//        for (int i = (int)tempIndex+1; i<=button.tag; i++) {
//            [self.pageViewController setViewControllers:@[[self.modelController viewControllerAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
//                if (finished) {
//                    weakSelf.currentPageIndex = i;
//                }
//            }];
//        }
        
    }else{
        
        [self.pageViewController setViewControllers:@[[self.modelController viewControllerAtIndex:button.tag]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
            if (finished) {
                weakSelf.currentPageIndex = button.tag;
            }
        }];

//        for (int i = (int)tempIndex-1; i >= button.tag; i--) {
//            [self.pageViewController setViewControllers:@[[self.modelController viewControllerAtIndex:i]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL finished) {
//                if (finished) {
//                    weakSelf.currentPageIndex = i;
//                }
//            }];
//        }
    }
}

- (void)selectedSection:(NSInteger)index {
    
    for (UIButton *btn in self.btnsArray) {
        [btn setSelected:NO];
    }
    
    UIButton *btn = self.btnsArray[index];
    [btn setSelected:YES];
    CGRect frm = btn.bounds;
    frm.origin.y = frm.size.height - 5;
    frm.size.height = 5;
    self.selectedStripView.frame = frm;
    
    [btn addSubview:self.selectedStripView];
    
    CGRect visibleFrm = btn.frame;
    
//    visibleFrm.origin.x = visibleFrm.origin.x - (kScreenWidth - visibleFrm.size.width)/2;
//    visibleFrm.size.width = visibleFrm.size.width + (kScreenWidth - visibleFrm.size.width)/2;
    
//    CGFloat offX = visibleFrm.origin.x + (kScreenWidth - visibleFrm.size.width)/2;
//    [self.topScrollView setContentOffset:CGPointMake(offX, 0) animated:YES];

    [self.topScrollView scrollRectToVisible:visibleFrm animated:YES];
}

@end
