//
//  CJIFlyRecognizerViewManager.h
//  VoiceRecognition
//
//  Created by 李超前 on 2017/9/5.
//  Copyright © 2017年 ciyouzen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CJIFlyRecognizerViewManager : NSObject {
    
}
@property (nonatomic, copy) void(^recognizeResultBlock)(NSString *resultString, BOOL isLast);


+ (instancetype)sharedInstance;

#pragma mark - 有效的初始方法为
- (void)initIFlyRecognizerViewWithOrigin:(CGPoint)origin;

- (void)initIFlyRecognizerViewWithCenter:(CGPoint)center;



- (BOOL)startListening;

- (void)cancelListening;

@end
