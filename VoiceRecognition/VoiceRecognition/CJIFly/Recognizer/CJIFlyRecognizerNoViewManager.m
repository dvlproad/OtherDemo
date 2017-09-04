//
//  CJIFlyRecognizerNoViewManager.m
//  VoiceRecognition
//
//  Created by 李超前 on 2017/9/4.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "CJIFlyRecognizerNoViewManager.h"


#import "IATConfig.h"

#import "iflyMSC/iflyMSC.h"
#import "ISRDataHelper.h"

@class IFlySpeechRecognizer;
@class IFlyPcmRecorder;

@interface CJIFlyRecognizerNoViewManager () <IFlySpeechRecognizerDelegate, IFlyPcmRecorderDelegate> {
    
}
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象
@property (nonatomic, strong) IFlyPcmRecorder *pcmRecorder;//录音器，用于音频流识别的数据传入

@property (nonatomic, strong) NSString * result;
@property (nonatomic, assign) BOOL isCanceled;

@end



@implementation CJIFlyRecognizerNoViewManager

///合成服务单例
+ (instancetype)sharedInstance {
    static CJIFlyRecognizerNoViewManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];//单例模式，无UI的实例
        [self commonInit_iFlySpeechRecognizer:self.iFlySpeechRecognizer];
        
        
        self.pcmRecorder = [IFlyPcmRecorder sharedInstance];
        [self commonInit_IFlyPcmRecorder:self.pcmRecorder];
    }
    
    return self;
}


///初始化语音合成服务单例
- (void)commonInit_iFlySpeechRecognizer:(IFlySpeechRecognizer *)iFlySpeechRecognizer {
    IATConfig *instance = [IATConfig sharedInstance];
    
    if (iFlySpeechRecognizer == nil) {
        iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];//单例模式，无UI的实例
    }
    iFlySpeechRecognizer.delegate = self;
    
    [iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
    //设置听写模式
    [iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    
    //设置最长录音时间
    [iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
    //设置后端点
    [iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
    //设置前端点
    [iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
    //网络等待时间
    [iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
    
    //设置采样率，推荐使用16K
    [iFlySpeechRecognizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    //设置语言
    [iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
    //设置方言
    [iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
    
    //设置是否返回标点符号
    [iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
}

//初始化录音器
- (void)commonInit_IFlyPcmRecorder:(IFlyPcmRecorder *)pcmRecorder {
    if (pcmRecorder == nil)
    {
        pcmRecorder = [IFlyPcmRecorder sharedInstance];
    }
    pcmRecorder.delegate = self;
    
    [pcmRecorder setSample:[IATConfig sharedInstance].sampleRate];
    
    [pcmRecorder setSaveAudioPath:nil];    //不保存录音文件
}


/**
 *  取消听写
 */
- (void)cancelListening {
    self.isCanceled = YES;
    
    [self.iFlySpeechRecognizer cancel];
}

/**
 *  启动听写
 */
- (BOOL)startListening {
    [self.iFlySpeechRecognizer cancel];
    
    //设置音频来源为麦克风
    [self.iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [self.iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [self.iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [self.iFlySpeechRecognizer setDelegate:self];
    
    BOOL ret = [self.iFlySpeechRecognizer startListening];
    return ret;
}



#pragma mark - IFlySpeechRecognizerDelegate

/**
 停止录音回调
 ****/
- (void) onEndOfSpeech
{
    NSLog(@"onEndOfSpeech");
    
    [_pcmRecorder stop];
//    [_popUpView showText: @"停止录音"];
}


/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void) onError:(IFlySpeechError *) error
{
    NSString *text ;
    
    if (self.isCanceled) {
        text = @"识别取消";
        
    } else if (error.errorCode == 0 ) {
        if (_result.length == 0) {
            text = @"无识别结果";
        }else {
            text = @"识别成功";
            //清空识别结果
            _result = nil;
        }
    }else {
        //10111错误为未初始化
        text = [NSString stringWithFormat:@"发生错误：%d %@", error.errorCode,error.errorDesc];
        NSLog(@"%@",text);
    }
    NSLog(@"text = %@", text);
    
    
    /*
    if ([IATConfig sharedInstance].haveView == NO ) {
     
        //        if (self.isStreamRec) {
        //            //当音频流识别服务和录音器已打开但未写入音频数据时stop，只会调用onError不会调用onEndOfSpeech，导致录音器未关闭
        //            [_pcmRecorder stop];
        //            self.isStreamRec = NO;
        //            NSLog(@"error录音停止");
        //        }
        
     
        
    }else {
        [_popUpView showText:@"识别结束"];
        NSLog(@"errorCode:%d",[error errorCode]);
    }
    
    [_startRecBtn setEnabled:YES];
    [_audioStreamBtn setEnabled:YES];
    [_upWordListBtn setEnabled:YES];
    [_upContactBtn setEnabled:YES];
    */
    
}

/**
 无界面，听写结果回调
 results：听写结果
 isLast：表示最后一次
 ****/
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@", key];
    }
    //NSLog(@"resultString = %@", resultString);
    
    //*
    
    NSString *resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    NSLog(@"resultFromJson = %@", resultFromJson);
    
    if (self.recognizeResultBlock) {
        self.recognizeResultBlock(resultFromJson, isLast);
    }
    
    /*
    _result =[NSString stringWithFormat:@"%@%@", _textView.text,resultString];
    _textView.text = [NSString stringWithFormat:@"%@%@", _textView.text,resultFromJson];
    
    if (isLast){
        NSLog(@"听写结果(json)：%@测试",  self.result);
    }
    NSLog(@"_result=%@",_result);
    NSLog(@"resultFromJson=%@",resultFromJson);
    NSLog(@"isLast=%d,_textView.text=%@",isLast,_textView.text);
    */
}



#pragma mark - IFlyPcmRecorderDelegate

- (void) onIFlyRecorderBuffer: (const void *)buffer bufferSize:(int)size
{
    NSData *audioBuffer = [NSData dataWithBytes:buffer length:size];
    
    int ret = [self.iFlySpeechRecognizer writeAudio:audioBuffer];
    if (!ret)
    {
        [self.iFlySpeechRecognizer stopListening];
    }
}

- (void) onIFlyRecorderError:(IFlyPcmRecorder*)recoder theError:(int) error
{
    
}



@end
