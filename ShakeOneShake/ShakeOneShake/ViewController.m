//
//  ViewController.m
//  ShakeOneShake
//
//  Created by lichq on 8/15/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "ViewController.h"
#import "ShakeOneShake.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)goShakeOneShake:(id)sender{
    UIStoryboard *sboard = [UIStoryboard storyboardWithName:@"ShakeOneShake" bundle:nil];
    ShakeOneShake *vc = [sboard instantiateViewControllerWithIdentifier:@"ShakeOneShake"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
