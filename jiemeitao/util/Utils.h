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

@interface JMTHttpClient : AFHTTPClient

+ (JMTHttpClient *)shareIntance;

@end
