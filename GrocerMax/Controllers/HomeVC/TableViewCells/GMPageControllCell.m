//
//  GMPageControllCell.m
//  GrocerMax
//
//  Created by Rahul Chaudhary on 16/09/15.
//  Copyright (c) 2015 Deepak Soni. All rights reserved.
//

#import "GMPageControllCell.h"
#import "GMHomeBannerModal.h"
#import "GMStateBaseModal.h"

@interface GMPageControllCell ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,weak)IBOutlet UICollectionView *itemsCollectionView;
@property(nonatomic,weak)IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *bannersListArray;
@property (nonatomic) NSIndexPath* tblIndexPath;

@end

@implementation GMPageControllCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.itemsCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    self.itemsCollectionView.delegate = self;
    self.itemsCollectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Configure Cell

-(void) configureCellWithData:(id)data cellIndexPath:(NSIndexPath*)indexPath{
    
    self.tblIndexPath = indexPath;
    self.bannersListArray = (NSArray*)data;
    [self.itemsCollectionView reloadData];
    self.pageControl.numberOfPages = self.bannersListArray.count;
}

#pragma mark - UICollectionView Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.bannersListArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    GMHomeBannerModal *mdl = self.bannersListArray[indexPath.item];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView setImageWithURL:[NSURL URLWithString:mdl.imageUrl] placeholderImage:[UIImage placeHolderImage]];
    imageView.contentMode = UIViewContentModeScaleToFill;
    cell.backgroundView = imageView;
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.itemsCollectionView.bounds.size;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{    
    if ([self.delegate respondsToSelector:@selector(didSelectItemAtTableViewCellIndexPath:andCollectionViewIndexPath:)]) {
        [self.delegate didSelectItemAtTableViewCellIndexPath:self.tblIndexPath andCollectionViewIndexPath:indexPath];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.itemsCollectionView.frame.size.width;
    self.pageControl.currentPage = (self.itemsCollectionView.contentOffset.x + pageWidth / 2) / pageWidth;
    [[GMSharedClass sharedClass] trakeEventWithName:kEY_GA_Event_BannerScroller withCategory:@"" label:nil value:nil];
    
    GMCityModal *cityModal = [GMCityModal selectedLocation];
    [[GMSharedClass sharedClass] trakeEventWithName:cityModal.cityName withCategory:@"Banner Scroll" label:@""];
}

@end
