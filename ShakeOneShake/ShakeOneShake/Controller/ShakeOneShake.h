//
//  ShakeOneShake.h
//  ShakeOneShake
//
//  Created by lichq on 8/15/15.
//  Copyright (c) 2015 ciyouzen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <QuartzCore/QuartzCore.h>

@interface ShakeOneShake : UIViewController{
    SystemSoundID soundID;
    //IBOutlet UIActivityIndicatorView *aiLoad;
}
@property(nonatomic, strong) IBOutlet UIImageView *imgVUp;
@property(nonatomic, strong) IBOutlet UIImageView *imgVDown;

@end
