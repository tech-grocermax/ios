//
//  GMSearchBarView.h
//  TestAutolayout
//
//  Created by Rahul Chaudhary on 27/09/15.
//  Copyright (c) 2015 Rahul Chaudhary. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GMSearchBarView;

@protocol GMSearchBarViewDelegate <NSObject>

- (void)searchBarDidCancelSearching:(GMSearchBarView*)searchView;
- (void)searchBarDidFinishSearching:(GMSearchBarView*)searchView withSearchResult:(id)data;
- (void)searchBarDidFailSearching:(GMSearchBarView*)searchView;

@end

@interface GMSearchBarView : UIView<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBarView;
@property (weak, nonatomic) id<GMSearchBarViewDelegate> delegate;

+(GMSearchBarView*)searchBarObj;

@end
