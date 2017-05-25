//
//  GMSearchBarView.m
//  TestAutolayout
//
//  Created by Rahul Chaudhary on 27/09/15.
//  Copyright (c) 2015 Rahul Chaudhary. All rights reserved.
//

#import "GMSearchBarView.h"
#import "GMSearchResultModal.h"

@interface GMSearchBarView ()

@end

@implementation GMSearchBarView

+(GMSearchBarView*)searchBarObj {
    
    GMSearchBarView *searchBarview = [[[NSBundle mainBundle] loadNibNamed:@"GMSearchBarView" owner:nil options:nil] firstObject];
    searchBarview.frame = CGRectMake(0, 0, kScreenWidth, 40);
    searchBarview.searchBarView.delegate = searchBarview;
    searchBarview.searchBarView.barTintColor = [UIColor clearColor];
    searchBarview.searchBarView.backgroundImage = [UIImage new];
    searchBarview.searchBarView.backgroundColor = [UIColor clearColor];
    
    return searchBarview;
}

#pragma mark - Search bar Delegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self.searchBarView resignFirstResponder];
    
    if (!NSSTRING_HAS_DATA(self.searchBarView.text)) {
        [[GMSharedClass sharedClass] showErrorMessage:GMLocalizedString(@"plzEnterKeyword")];
        return;
    }
    
    [self performSearchOnServer];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [self.searchBarView resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(searchBarDidCancelSearching:)])
    {
        [self.delegate searchBarDidCancelSearching:self];
    }
}


#pragma mark - API Task

-(void)performSearchOnServer {

    UIViewController* delegateVC= self.delegate;
    
    NSMutableDictionary *localDic = [NSMutableDictionary new];
    [localDic setObject:self.searchBarView.text forKey:kEY_keyword];
    
    [delegateVC showProgress];
    [[GMOperationalHandler handler] search:localDic withSuccessBlock:^(id responceData) {
        
        [delegateVC removeProgress];
        
        GMSearchResultModal *searchResultModal = responceData;
        
        if ([self.delegate respondsToSelector:@selector(searchBarDidFinishSearching:withSearchResult:)])
        {
            [self.delegate searchBarDidFinishSearching:self withSearchResult:searchResultModal];
        }
        
    } failureBlock:^(NSError *error) {
        [delegateVC removeProgress];
        [[GMSharedClass sharedClass] showErrorMessage:error.localizedDescription];
        
        if ([self.delegate respondsToSelector:@selector(searchBarDidFailSearching:)])
        {
            [self.delegate searchBarDidFailSearching:self];
        }
    }];
}

@end
