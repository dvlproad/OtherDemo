//
//  ShakeOneShake.m
//  ShakeOneShake
//
//  Created by lichq on 8/15/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import "ShakeOneShake.h"

#define Noti_Shake @"shake"

@interface ShakeOneShake ()

@end

@implementation ShakeOneShake

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = NSLocalizedString(@"摇一摇", nil);
    
    // aiLoad.hidden=YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"glass" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
    
    // Erase the view when recieving a notification named "shake" from the NSNotificationCenter object
    // The "shake" nofification is posted by the PaintingWindow object when user shakes the device
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAnimations) name:Noti_Shake object:nil];
    
    
    self.imgVDown.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_Shake object:nil];
}

- (IBAction)testShake:(id)sender{ //用于模拟器无法摇动时候的测试，正常时候没这个
    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_Shake object:self];
}


#pragma mark - 摇一摇动画效果
- (void)addAnimations
{
    
    AudioServicesPlaySystemSound (soundID);
    
    /* //动画效果1:
    //让imgup上下移动
    CABasicAnimation *upPartTranslation = [CABasicAnimation animationWithKeyPath:@"position"];
    upPartTranslation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    upPartTranslation.fromValue = [NSValue valueWithCGPoint:CGPointMake(160, 170)];//(160, 170)指控件的中心位置
    upPartTranslation.toValue = [NSValue valueWithCGPoint:CGPointMake(160, 120)];
    upPartTranslation.duration = 0.4;
    upPartTranslation.repeatCount = 1;
    upPartTranslation.autoreverses = YES;
    [self.imgVUp.layer addAnimation:upPartTranslation forKey:@"translation2"];
    
    
    //让imagdown上下移动
    CABasicAnimation *downPartTranslation = [CABasicAnimation animationWithKeyPath:@"position"];
    downPartTranslation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    downPartTranslation.fromValue = [NSValue valueWithCGPoint:CGPointMake(160, 370)];
    downPartTranslation.toValue = [NSValue valueWithCGPoint:CGPointMake(160, 420)];
    downPartTranslation.duration = 0.4;
    downPartTranslation.repeatCount = 1;
    downPartTranslation.autoreverses = YES;
    [self.imgVDown.layer addAnimation:downPartTranslation forKey:@"translation"];
    
     
     //    [aiLoad stopAnimating];
     //    aiLoad.hidden=YES;
     //*/
    
    //*
    //动画效果2:
    CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    shake.fromValue = [NSNumber numberWithFloat:-M_PI/32];
    shake.toValue   = [NSNumber numberWithFloat:+M_PI/32];
    shake.duration = 0.1;
    shake.repeatCount = 4;
    shake.autoreverses = YES;
    [self.imgVUp.layer addAnimation:shake forKey:@"shakeAnimation"];
    
    self.imgVUp.alpha = 1.0;
    [UIView animateWithDuration:2.0 delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.imgVUp.alpha = 0.0;
                     } completion:nil];
    //*/
    
}

#pragma mark - 摇一摇的委托方法
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    //	if (motion == UIEventSubtypeMotionShake ){
    if (event.type == UIEventTypeMotion && event.subtype == UIEventSubtypeMotionShake) {
        // User was shaking the device. Post a notification named "shake".
        [[NSNotificationCenter defaultCenter] postNotificationName:Noti_Shake object:self];
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
