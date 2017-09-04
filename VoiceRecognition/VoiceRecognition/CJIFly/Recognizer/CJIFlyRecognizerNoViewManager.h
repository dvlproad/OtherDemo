//
//  CJIFlyRecognizerNoViewManager.h
//  VoiceRecognition
//
//  Created by 李超前 on 2017/9/4.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJIFlyRecognizerNoViewManager : NSObject {
    
}
@property (nonatomic, copy) void(^recognizeResultBlock)(NSString *resultString, BOOL isLast);


+ (instancetype)sharedInstance;

- (BOOL)startListening;

- (void)cancelListening;

@end
