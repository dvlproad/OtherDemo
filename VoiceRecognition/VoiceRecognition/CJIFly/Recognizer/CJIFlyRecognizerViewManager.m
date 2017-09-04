//
//  CJIFlyRecognizerViewManager.m
//  VoiceRecognition
//
//  Created by 李超前 on 2017/9/5.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import "CJIFlyRecognizerViewManager.h"

#import "iflyMSC/iflyMSC.h"
#import "IATConfig.h"

@interface CJIFlyRecognizerViewManager () <IFlyRecognizerViewDelegate> {
    
}
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;//带界面的识别对象


@end



@implementation CJIFlyRecognizerViewManager

///合成服务单例
+ (instancetype)sharedInstance {
    static CJIFlyRecognizerViewManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    return _sharedInstance;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        //错误方法：不能使用Init方法，而应该使用initWithCenter 和 initWithOrigin方法
        //self.iflyRecognizerView = [[IFlyRecognizerView alloc] init]; //错误
        //[self commonInit_IFlyRecognizerView:self.iflyRecognizerView];
    }
    
    return self;
}

- (void)initIFlyRecognizerViewWithCenter:(CGPoint)center {
    self.iflyRecognizerView = [[IFlyRecognizerView alloc] initWithCenter:center];
    [self commonInit_IFlyRecognizerView:self.iflyRecognizerView];
}

- (void)initIFlyRecognizerViewWithOrigin:(CGPoint)origin {
    self.iflyRecognizerView = [[IFlyRecognizerView alloc] initWithOrigin:origin];
    [self commonInit_IFlyRecognizerView:self.iflyRecognizerView];
}


- (void)commonInit_IFlyRecognizerView:(IFlyRecognizerView *)iflyRecognizerView {
    //单例模式，UI的实例
    if (iflyRecognizerView == nil) {
        //UI显示剧中
        //iflyRecognizerView= [[IFlyRecognizerView alloc] initWithCenter:self.view.center];
        iflyRecognizerView= [[IFlyRecognizerView alloc] init];
        [iflyRecognizerView setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        
        //设置听写模式
        [iflyRecognizerView setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        
    }
    iflyRecognizerView.delegate = self;
    
    if (iflyRecognizerView != nil) {
        IATConfig *instance = [IATConfig sharedInstance];
        //设置最长录音时间
        [iflyRecognizerView setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [iflyRecognizerView setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [iflyRecognizerView setParameter:instance.vadBos forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [iflyRecognizerView setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [iflyRecognizerView setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        if ([instance.language isEqualToString:[IATConfig chinese]]) {
            //设置语言
            [iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //设置方言
            [iflyRecognizerView setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
        }else if ([instance.language isEqualToString:[IATConfig english]]) {
            //设置语言
            [iflyRecognizerView setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
        }
        //设置是否返回标点符号
        [iflyRecognizerView setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
        
    }
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
    if (error.errorCode == 0 ) {
        text = @"识别成功";
        
    }else {
        text = [NSString stringWithFormat:@"发生错误：%d %@", error.errorCode,error.errorDesc];
        NSLog(@"%@",text);
    }
}


/**
 有界面，听写结果回调
 resultArray：听写结果
 isLast：表示最后一次
 ****/
- (void)onResult:(NSArray *)resultArray isLast:(BOOL)isLast
{
    NSMutableString *result = [[NSMutableString alloc] init];
    NSDictionary *dic = [resultArray objectAtIndex:0];
    
    for (NSString *key in dic) {
        [result appendFormat:@"%@",key];
    }
    NSLog(@"result = %@", result);
    
    if (self.recognizeResultBlock) {
        self.recognizeResultBlock(result, isLast);
    }
    
    /*
     _textView.text = [NSString stringWithFormat:@"%@%@",_textView.text,result];
     */
}


- (BOOL)startListening {
    //设置音频来源为麦克风
    [self.iflyRecognizerView setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [self.iflyRecognizerView setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [self.iflyRecognizerView setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    BOOL ret = [self.iflyRecognizerView start];
    return ret;
}

- (void)cancelListening {
    
}

@end
