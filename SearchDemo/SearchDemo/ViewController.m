//
//  ViewController.m
//  SearchDemo
//
//  Created by lichq on 8/14/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "ViewController.h"
#import "SearchViewController.h"

@interface ViewController ()<SearchViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"首页", nil);
}

- (IBAction)goSearch:(id)sender{
    SearchViewController *vc = [[SearchViewController alloc]initWithNibName:@"SearchViewController" bundle:nil];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SearchViewControllerDelegate
- (void)searchViewController:(SearchViewController *)vc didSelectWithObject:(id)aObject{
    //TODO让警告框自动消失
    [[[UIAlertView alloc]initWithTitle:@"选择结果" message:aObject delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    
    [vc.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
