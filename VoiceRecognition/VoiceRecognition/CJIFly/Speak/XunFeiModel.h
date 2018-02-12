//
//  XunFeiModel.h
//  BangBangxingDriver
//
//  Created by ypf on 16/4/19.
//  Copyright © 2016年 bbxpc.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iflyMSC/IFlySpeechConstant.h>
#import <iflyMSC/IFlySpeechSynthesizer.h>
#import <iflyMSC/IFlySpeechSynthesizerDelegate.h>

@interface XunFeiModel : NSObject<IFlySpeechSynthesizerDelegate>

@property(nonatomic,strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

+(instancetype)shareManager;


+ (void)speak:(NSString *)content;

+ (void)speakToast:(NSString *)content;


@end
