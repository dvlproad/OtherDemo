//
//  SearchViewController.h
//  Lee
//
//  Created by lichq on 14-12-3.
//  Copyright (c) 2014年 lichq. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Bank.h"

@class SearchViewController;
@protocol SearchViewControllerDelegate <NSObject>

@optional //标记为可选的，使得不一定要在程序中实现该方法
- (void)searchViewController:(SearchViewController *)vc didSelectWithObject:(id)aObject;
- (void)searchViewController_DidCanceled:(SearchViewController *)vc;

@end





@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate>{
    NSArray *dataSearchHold;
    NSArray *dataSearchResult;
    
}
@property (nonatomic,strong) IBOutlet UISearchBar *scBar;
@property (nonatomic,strong) IBOutlet UITextField *tf;
@property (nonatomic,strong) IBOutlet UITableView *tvSearch;

@property (nonatomic,weak)id<SearchViewControllerDelegate> delegate;

@end







