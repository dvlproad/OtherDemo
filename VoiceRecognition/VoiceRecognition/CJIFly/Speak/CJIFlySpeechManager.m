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

#import "TTSConfig.h"

@interface CJIFlySpeechManager () <IFlySpeechSynthesizerDelegate> {
    
}
@property (nonatomic,strong) IFlySpeechSynthesizer *iFlySpeechSynthesizer;

@property (nonatomic, assign) BOOL isCanceled;
@property (nonatomic, assign) BOOL hasError;


@property (nonatomic, strong) NSString *uriPath;
//@property (nonatomic, strong) PcmPlayer *audioPlayer;

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
    /*
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
    */
    TTSConfig *instance = [TTSConfig sharedInstance];
    if (instance == nil) {
        return;
    }
    
    //合成服务单例
    if (iFlySpeechSynthesizer == nil) {
        iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    iFlySpeechSynthesizer.delegate = self;
    
    //设置语速1-100
    [iFlySpeechSynthesizer setParameter:instance.speed forKey:[IFlySpeechConstant SPEED]];
    
    //设置音量1-100
    [iFlySpeechSynthesizer setParameter:instance.volume forKey:[IFlySpeechConstant VOLUME]];
    
    //设置音调1-100
    [iFlySpeechSynthesizer setParameter:instance.pitch forKey:[IFlySpeechConstant PITCH]];
    
    //设置采样率
    [iFlySpeechSynthesizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    //设置发音人
    [iFlySpeechSynthesizer setParameter:instance.vcnName forKey:[IFlySpeechConstant VOICE_NAME]];
    
    //设置文本编码格式
    [iFlySpeechSynthesizer setParameter:@"unicode" forKey:[IFlySpeechConstant TEXT_ENCODING]];
}


#pragma mark - Public
/* 完整的描述请参见文件头部 */
- (void)speak:(NSString *)content {
    if ([content isEqualToString:@""]) {
        NSLog(@"无效的文本信息");
        //[_popUpView showText:@"无效的文本信息"];
        return;
    }
    
//    if (_audioPlayer != nil && _audioPlayer.isPlaying == YES) {
//        [_audioPlayer stop];
//    }
    
    _synType = NomalType;
    
    self.hasError = NO;
    [NSThread sleepForTimeInterval:0.05];
    
    NSLog(@"正在缓冲...");
//    [_inidicateView setText: @"正在缓冲..."];
    
    self.isCanceled = NO;
    
    self.iFlySpeechSynthesizer.delegate = self;
    
    [self.iFlySpeechSynthesizer startSpeaking:content];
    if (self.iFlySpeechSynthesizer.isSpeaking) {
        self.state = Playing;
    }
    
//    先停止旧的，再播放新的
//    [self.iFlySpeechSynthesizer stopSpeaking];
//    [self.iFlySpeechSynthesizer startSpeaking:content];
    //[NSThread isMainThread]
    dispatch_async(dispatch_get_main_queue(), ^{
        

    });
}


/**
 开始uri合成
 ****/
- (void)uriSynthesizeSpeak:(NSString *)content {
    
    if ([content isEqualToString:@""]) {
        NSLog(@"无效的文本信息");
        //[_popUpView showText:@"无效的文本信息"];
        return;
    }
    
//    if (_audioPlayer != nil && _audioPlayer.isPlaying == YES) {
//        [_audioPlayer stop];
//    }
    
    _synType = UriType;
    
    self.hasError = NO;
    
    [NSThread sleepForTimeInterval:0.05];
//    [_inidicateView setText: @"正在缓冲..."];
//    [_inidicateView show];
//    
//    [_popUpView removeFromSuperview];
    
    self.isCanceled = NO;
    
    self.iFlySpeechSynthesizer.delegate = self;
    
    [self.iFlySpeechSynthesizer synthesize:content toUri:_uriPath];
    if (self.iFlySpeechSynthesizer.isSpeaking) {
        _state = Playing;
    }
}

- (void)stop {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.iFlySpeechSynthesizer stopSpeaking];
    });
}


/**
 取消合成
 注：
 1、取消通用合成，并停止播放；
 2、uri合成取消时会保存已经合成的pcm；
 ****/
- (void)cancelSpeak {
//    [_inidicateView hide];
    [self.iFlySpeechSynthesizer stopSpeaking];
    
}

/**
 暂停播放
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void)pauseSpeaking {
    [_iFlySpeechSynthesizer pauseSpeaking];
}

/**
 恢复播放
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (IBAction)resumeSpeaking {
    [_iFlySpeechSynthesizer resumeSpeaking];
}


#pragma mark - 合成回调 IFlySpeechSynthesizerDelegate

/**
 开始播放回调
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void)onSpeakBegin
{
//    [_inidicateView hide];
    self.isCanceled = NO;
    if (_state  != Playing) {
        NSLog(@"开始播放");
//        [_popUpView showText:@"开始播放"];
    }
    _state = Playing;
}



/**
 缓冲进度回调
 
 progress 缓冲进度
 msg 附加信息
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void)onBufferProgress:(int) progress message:(NSString *)msg
{
    NSLog(@"buffer progress %2d%%. msg: %@.", progress, msg);
}




/**
 播放进度回调
 
 progress 缓冲进度
 
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos
{
    NSLog(@"speak progress %2d%%.", progress);
}


/**
 合成暂停回调
 注：
 对通用合成方式有效，
 对uri合成无效
 ****/
- (void)onSpeakPaused
{
    NSString *string = @"播放暂停";
    NSLog(@"string = %@", string);
//    [_inidicateView hide];
//    [_popUpView showText:string];
    
    _state = Paused;
}

/**
 合成结束（完成）回调
 
 对uri合成添加播放的功能
 ****/
- (void)onCompleted:(IFlySpeechError *) error
{
    NSLog(@"%s,error=%d",__func__,error.errorCode);
//    NSLog(@"讯飞语音完成播放内容");
    
    if (error.errorCode != 0) {
        NSString *errorMessage = [NSString stringWithFormat:@"错误码:%d",error.errorCode];
        NSLog(@"errorMessage = %@", errorMessage);
//        [_inidicateView hide];
//        [_popUpView showText:errorMessage];
        return;
    }
    
    NSString *text ;
    if (self.isCanceled) {
        text = @"合成已取消"; //合成因取消而结束
    }else if (error.errorCode == 0) {
        text = @"合成结束";
    }else {
        text = [NSString stringWithFormat:@"发生错误：%d %@",error.errorCode,error.errorDesc];
        self.hasError = YES;
        NSLog(@"%@",text);
    }
    
//    [_inidicateView hide];
//    [_popUpView showText:text];
    
    _state = NotStart;
    
    if (_synType == UriType) {//Uri合成类型
        
//        NSFileManager *fm = [NSFileManager defaultManager];
//        if ([fm fileExistsAtPath:_uriPath]) {
//            [self playUriAudio];//播放合成的音频
//        }
    }
}



@end
