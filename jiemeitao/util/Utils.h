//
//  Utils.h
//  jiemeitao
//
//  Created by tangyong on 13-5-23.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

@end

@interface NSObject(JMT)

- (void)receiveObject:(void(^)(id object))sendObject withIdentifier:(NSString *)identifier;
- (void)sendObject:(id)object withIdentifier:(NSString *)identifier;

@end

@interface UIViewController (JMT)
- (void)setNavigationItemTitle: (NSString *)title withColor:(UIColor*)color;
@end


@interface JMTHttpClient : AFHTTPClient

+ (JMTHttpClient *)shareIntance;

@end

@interface NSDate(JMT)

- (NSString*) ToFullDate;
- (NSString*) ToFullDateTime;
- (NSString*) ToFullTime;
- (NSString*) ToShortDate;
- (NSString*) ToShortDateTime;
- (NSString*) ToShortTime;
- (NSString*) ToNiceTime;

@end


