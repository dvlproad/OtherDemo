//
//  FundDetail.m
//  YingYingLiCai
//
//  Created by JianYe on 13-5-2.
//  Copyright (c) 2013年 YingYing. All rights reserved.
//

#import "Bank.h"

@implementation Bank
@synthesize code = _code;
@synthesize name = _name;


- (id)initWithDictionary:(NSDictionary *)dictionary
{
//    LOG(@"bank ==  %@",dictionary);
    if (self = [super init]) {
        self.code = [dictionary objectForKey:@"code"];
        self.name = [dictionary objectForKey:@"name"];
    }
    return self;
}

+ (NSString *)keyName
{
    return @"name";
}

+ (NSString *)keyCode{
    return @"code";
}

@end


