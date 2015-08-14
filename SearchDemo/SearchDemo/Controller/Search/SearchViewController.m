//
//  SearchViewController.m
//  Lee
//
//  Created by lichq on 14-12-3.
//  Copyright (c) 2014年 lichq. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end


@implementation SearchViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /**< 清除searchbar的背景*/
    //    for (UIView *subview in self.scBar.subviews) {
    //        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
    //            UIView *bg = [[UIView alloc] initWithFrame:subview.frame];
    //            bg.backgroundColor = [UIColor colorWithWhite:0.09 alpha:1];
    //            [self.scBar insertSubview:bg aboveSubview:subview];
    //            [subview removeFromSuperview];
    //            break;
    //        }
    //    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"Search 模糊搜索", nil);
    
    [self.tvSearch setAlpha:0];
    self.tvSearch.layer.cornerRadius = 3;
    self.tvSearch.layer.borderWidth = 1;
    self.tvSearch.layer.borderColor = [[UIColor redColor] CGColor];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"banks" ofType:@"txt"];
    NSArray *dataList = [NSArray arrayWithContentsOfFile:path];

    dataSearchHold = [NSArray arrayWithArray:dataList];
    dataSearchResult = dataSearchHold;
}



#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [dataSearchResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    NSDictionary *dic = [dataSearchResult objectAtIndex:indexPath.row];
    Bank *bank = [[Bank alloc] initWithDictionary:dic];
    cell.textLabel.text = bank.name;
    cell.detailTextLabel.text = bank.code;

    return cell;
}











- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
