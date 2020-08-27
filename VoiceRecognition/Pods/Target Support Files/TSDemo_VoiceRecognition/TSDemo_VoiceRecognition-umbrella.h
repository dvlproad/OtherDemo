#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CJIFlyRecognizerNoViewManager.h"
#import "CJIFlyRecognizerViewManager.h"
#import "IATConfig.h"
#import "ISRDataHelper.h"
#import "CJIFlySpeechManager.h"
#import "TTSConfig.h"
#import "XunFeiModel.h"
#import "AppContext.h"
#import "VNConstants.h"
#import "NoteDetailController.h"
#import "NoteListCell.h"
#import "NoteListController.h"
#import "VNNote.h"
#import "VNNoteManager.h"

FOUNDATION_EXPORT double TSDemo_VoiceRecognitionVersionNumber;
FOUNDATION_EXPORT const unsigned char TSDemo_VoiceRecognitionVersionString[];

