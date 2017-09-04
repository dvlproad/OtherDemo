//
//  CJIFlySpeechManager.m
//  VoiceRecognition
//
//  Created by 李超前 on 2017/9/3.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "CJIFlySpeechManager.h"

#import <iflyMSC/IFlySpeechConstant.h>
#import <iflyMSC/IFlySpeechSynthesizer.h>
#import <iflyMSC/IFlySpeechSynthesizerDelegate.h>

@interface CJIFlySpeechManager () <IFlySpeechSynthesizerDelegate> {
    
}
@property(nonatomic,strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

@end


@implementation CJIFlySpeechManager

static CJIFlySpeechManager *_sharedInstance = nil;

///合成服务单例
+ (instancetype)sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
        [self commonInit_IFlySpeechSynthesizer:self.iFlySpeechSynthesizer];
    }
    
    return self;
}


///初始化语音合成服务单例
- (void)commonInit_IFlySpeechSynthesizer:(IFlySpeechSynthesizer *)iFlySpeechSynthesizer {

//    iFlySpeechSynthesizer.delegate = manager;
    iFlySpeechSynthesizer.delegate = _sharedInstance;
    
    [iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD] forKey:[IFlySpeechConstant ENGINE_TYPE]];
    
    //语速,取值范围 0~100
    [iFlySpeechSynthesizer setParameter:@"70" forKey:[IFlySpeechConstant SPEED]];
    
    //音量;取值范围 0~100
    [iFlySpeechSynthesizer setParameter:@"99" forKey: [IFlySpeechConstant VOLUME]];
    
    //发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表
    [iFlySpeechSynthesizer setParameter:@"xiaoyan" forKey: [IFlySpeechConstant VOICE_NAME]];
    
    //音频采样率,目前支持的采样率有 16000 和 8000
    [iFlySpeechSynthesizer setParameter:@"8000" forKey: [IFlySpeechConstant SAMPLE_RATE]];
    
    //asr_audio_path保存录音文件路径，如不再需要，设置value为nil表示取消，默认目录是documents
    //[_iFlySpeechSynthesizer setParameter:@" tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
}

#pragma mark - IFlySpeechSynthesizerDelegate

- (void)onCompleted:(IFlySpeechError *)error {
    NSLog(@"讯飞语音完成播放内容");
}



#pragma mark - Public
/* 完整的描述请参见文件头部 */
- (void)speak:(NSString *)content {
    //先停止旧的，再播放新的
    [self.iFlySpeechSynthesizer stopSpeaking];
    [self.iFlySpeechSynthesizer startSpeaking:content];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//    });
}

- (void)stop {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.iFlySpeechSynthesizer stopSpeaking];
    });
}

@end
