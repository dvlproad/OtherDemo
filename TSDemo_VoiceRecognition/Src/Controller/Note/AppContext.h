//
//  AppContext.h
//  Voice2Note
//
//  Created by ciyouzen on 14-6-30.
//  Copyright (c) 2014年 dvlproad. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppContext : NSObject

+ (instancetype)appContext;

@property (nonatomic, assign) BOOL hasUploadAddressBook;

@end
