

/**
 * 银行
 */

#import <Foundation/Foundation.h>

@interface Bank : NSObject

@property (nonatomic,copy)NSString *code;/**< 银行代码*/
@property (nonatomic,copy)NSString *name;/**< 银行名称*/


- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSString *)keyName;
+ (NSString *)keyCode;
@end

