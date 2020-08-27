//
//  CJIFlySpeechManager.h
//  VoiceRecognition
//
//  Created by 李超前 on 2017/9/3.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
在使用讯飞语音SDK中遇到错误：用户校验失败10407。原因是一个应用申请的Appid和对应下载的SDK（包括jar和本地库）具有一致性，SDK不通用。

另外吐槽一下，讯飞开放平台里只能添加应用，不能删除，强迫症不能忍。

在使用人脸鉴别时需要建立组，并且在参数里需要设置SpeechConstant.AUTH_ID（逻辑上有点奇怪，建立组还需要auth_id?），否则就会出11005无效的用户名错误。

Android版本如果想同时使用语音唤醒和离线合成功能，需要注意SDK应该使用语音唤醒里的版本。
*/


typedef NS_OPTIONS(NSInteger, Status) {
    NotStart            = 0,
    Playing             = 2, //高异常分析需要的级别
    Paused              = 4,
};

typedef NS_OPTIONS(NSInteger, SynthesizeType) {
    NomalType           = 5,//普通合成
    UriType             = 6, //uri合成
};


@interface CJIFlySpeechManager : NSObject {
    
}
@property (nonatomic, assign) Status state;
@property (nonatomic, assign) SynthesizeType synType;

/* //常见问题来回切换播放突然没声音了
 如果出现一列[IFLYTEK] wait=58，请检查是否最后还有[IFlyTTSService sessionBegin][OUT],wait=60,errorCode=10111,sid=0这样的错误提示，这样的错误提示代表未初始化
 */



///合成服务单例
+ (instancetype)sharedInstance;


/**
 *  语音播报
 *
 *  @param content 语音播报的内容
 */
- (void)speak:(NSString *)content;

/**
 *  停止播报(一般在退出界面时候使用)
 */
- (void)stop;

@end
