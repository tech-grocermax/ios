//
//  GMShopByDealCell.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 17/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMShopByDealCell.h"
#import "GMShopByDealCollectionViewCell.h"

NSString *const shopByDealCollectionViewCell = @"GMShopByDealCollectionViewCell";

@interface GMShopByDealCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,weak)IBOutlet UICollectionView *categoryCollectionView;
@property (weak, nonatomic) IBOutlet UILabel *lbl_shopByDeal;

@property (nonatomic) NSIndexPath* tblIndexPath;

@property (nonatomic) NSArray* hotDealsArray;

@end

@implementation GMShopByDealCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.categoryCollectionView registerClass:[GMShopByDealCollectionViewCell class] forCellWithReuseIdentifier:shopByDealCollectionViewCell];
    [self.categoryCollectionView registerNib:[UINib nibWithNibName:@"GMShopByDealCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:shopByDealCollectionViewCell];
    
    self.categoryCollectionView.delegate = self;
    self.categoryCollectionView.dataSource = self;
    
//    NSString *string = @"Deals";
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
//    
//    float spacing = 3.0f;
//    [attributedString addAttribute:NSKernAttributeName
//                             value:@(spacing)
//                             range:NSMakeRange(0, [string length])];
//    
//    self.lbl_shopByDeal.attributedText = attributedString;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - Configure Cell

-(void) configureCellWithData:(id)data cellIndexPath:(NSIndexPath*)indexPath{
    self.hotDealsArray = data;
    if(self.hotDealsArray.count>0){
        self.lbl_shopByDeal.text = @"Deals";
//    self.hotDealsArray = data;
    self.tblIndexPath = indexPath;
    [self.categoryCollectionView reloadData];
    }else {
        self.lbl_shopByDeal.text = @"";
    }
}

#pragma mark - UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.hotDealsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GMShopByDealCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:shopByDealCollectionViewCell forIndexPath:indexPath];

    [cell configureCellWithData:self.hotDealsArray[indexPath.item] cellIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_SIZE.width, self.categoryCollectionView.bounds.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.delegate respondsToSelector:@selector(didSelectDealItemAtTableViewCellIndexPath:andCollectionViewIndexPath:)]) {
        [self.delegate didSelectDealItemAtTableViewCellIndexPath:self.tblIndexPath andCollectionViewIndexPath:indexPath];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_DealScroller withCategory:@"" label:nil value:nil];
}

@end
