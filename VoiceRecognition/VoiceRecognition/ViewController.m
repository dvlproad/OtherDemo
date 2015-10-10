//
//  ViewController.m
//  VoiceRecognition
//
//  Created by lichq on 8/15/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "ViewController.h"
#import "VoiceRecognition.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)goVoiceRecognition:(id)sender{
    UIStoryboard *sboard = [UIStoryboard storyboardWithName:@"VoiceRecognition" bundle:nil];
    VoiceRecognition *vc = [sboard instantiateViewControllerWithIdentifier:@"VoiceRecognition"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
