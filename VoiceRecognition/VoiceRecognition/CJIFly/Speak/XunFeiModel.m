//
//  XunFeiModel.m
//  BangBangxingDriver
//
//  Created by ypf on 16/4/19.
//  Copyright © 2016年 bbxpc.com. All rights reserved.
//

#import "XunFeiModel.h"

@implementation XunFeiModel

+(instancetype)shareManager
{
    static XunFeiModel * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[XunFeiModel alloc] init];
        
        manager.iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
        
        manager.iFlySpeechSynthesizer.delegate = manager;
        
        [manager.iFlySpeechSynthesizer setParameter:[IFlySpeechConstant TYPE_CLOUD] forKey:[IFlySpeechConstant ENGINE_TYPE]];
        
        
        //语速,取值范围 0~100
        [manager.iFlySpeechSynthesizer setParameter:@"70" forKey:[IFlySpeechConstant SPEED]];
        //音量;取值范围 0~100
        [manager.iFlySpeechSynthesizer setParameter:@"99" forKey: [IFlySpeechConstant VOLUME]];
        
        //发音人,默认为”xiaoyan”;可以设置的参数列表可参考个 性化发音人列表
        [manager.iFlySpeechSynthesizer setParameter:@"xiaoyan" forKey: [IFlySpeechConstant VOICE_NAME]];
        
        //音频采样率,目前支持的采样率有 16000 和 8000
        [manager.iFlySpeechSynthesizer setParameter:@"8000" forKey: [IFlySpeechConstant SAMPLE_RATE]];
        
        //asr_audio_path保存录音文件路径，如不再需要，设置value为nil表示取消，默认目录是documents
//        [_iFlySpeechSynthesizer setParameter:@" tts.pcm" forKey: [IFlySpeechConstant TTS_AUDIO_PATH]];
        
    });
    return manager;
}


/**
 *  结束回调
 *  当整个合成结束之后会回调此函数
 *
 *  @param error 错误码
 */
- (void) onCompleted:(IFlySpeechError*) error
{
    NSLog(@"播放完成");
    
    
}


/**
 *  开始合成回调
 */
- (void) onSpeakBegin
{
}


/**
 *  缓冲进度回调
 *
 *  @param progress 缓冲进度，0-100
 *  @param msg      附件信息，此版本为nil
 */
- (void) onBufferProgress:(int) progress message:(NSString *)msg
{
}


/**
 *  播放进度回调
 *
 *  @param progress 当前播放进度，0-100
 *  @param beginPos 当前播放文本的起始位置，0-100
 *  @param endPos 当前播放文本的结束位置，0-100
 */
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos
{
}


/**
 *  暂停播放回调
 */
- (void) onSpeakPaused
{
}


/**
 *  恢复播放回调
 */
- (void) onSpeakResumed
{
}


/**
 *  正在取消回调
 * 当调用`cancel`之后会回调此函数
 */
- (void) onSpeakCancel
{
}


/**
 *  扩展事件回调
 *  根据事件类型返回额外的数据
 *
 *  @param eventType 事件类型，具体参见IFlySpeechEventType枚举。目前只支持EVENT_TTS_BUFFER也就是实时返回合成音频。
 *  @param arg0      arg0
 *  @param arg1      arg1
 *  @param eventData 事件数据
 */
- (void) onEvent:(int)eventType arg0:(int)arg0 arg1:(int)arg1 data:(NSData *)eventData
{
}



+ (void)speak:(NSString *)content
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[XunFeiModel shareManager].iFlySpeechSynthesizer stopSpeaking];
        
        [[XunFeiModel shareManager].iFlySpeechSynthesizer startSpeaking:content];        
    });
}

+ (void)speakToast:(NSString *)content
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [[XunFeiModel shareManager].iFlySpeechSynthesizer stopSpeaking];
        
        [[XunFeiModel shareManager].iFlySpeechSynthesizer startSpeaking:content];
        
//        [[UIApplication sharedApplication].keyWindow showWitrhText:content];
    });
}



@end
