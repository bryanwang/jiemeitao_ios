//
//  Utils.m
//  jiemeitao
//
//  Created by tangyong on 13-5-23.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "Utils.h"
#import <objc/runtime.h>

@implementation Utils

@end

@implementation NSObject(JMT)

const char JMTObjectSingleObjectDictionary;

-(void)receiveObject:(void(^)(id object))sendObject withIdentifier:(NSString *)identifier
{
    NSAssert(identifier != nil, @"identifier can't be nil.");
    NSMutableDictionary *eventHandlerDictionary = objc_getAssociatedObject(self,&JMTObjectSingleObjectDictionary);
    if(eventHandlerDictionary == nil)
    {
        eventHandlerDictionary = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, &JMTObjectSingleObjectDictionary, eventHandlerDictionary, OBJC_ASSOCIATION_RETAIN);
    }
    
    [eventHandlerDictionary setObject:sendObject forKey:identifier];
}

-(void)sendObject:(id)object withIdentifier:(NSString *)identifier
{
    NSAssert(identifier != nil, @"identifier can't be nil.");
    
    NSDictionary *eventHandlerDictionary = objc_getAssociatedObject(self,&JMTObjectSingleObjectDictionary);
    if(eventHandlerDictionary == nil)
        return;
    
    void(^block)(id object) =  [eventHandlerDictionary objectForKey:identifier];
    block(object);
}

@end


@implementation NSString(JMT)

- (NSString *)RailsTimeToNiceTime
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *date = [dateFormatter dateFromString: self];
    return [date ToNiceTime];
}

- (NSString *)RailsTimeToFullDate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *date = [dateFormatter dateFromString: self];
    return [date ToFullDate];
}


@end

@implementation UIViewController (JMT)

- (void)setNavigationItemTitleColor:(UIColor*)color;
{
    UILabel *titleView = (UILabel *)self.navigationItem.titleView;
    if (!titleView) {
        NSString *title = self.navigationItem.title;
        titleView = [[UILabel alloc] initWithFrame:CGRectZero];
        titleView.backgroundColor = [UIColor clearColor];
        titleView.font = [UIFont boldSystemFontOfSize:22.0];
        titleView.textColor = color;
        self.navigationItem.titleView = titleView;
        titleView.text = title;
    }
    [titleView sizeToFit];
}
@end

@implementation JMTHttpClient

+ (JMTHttpClient *)shareIntance
{
    static JMTHttpClient *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    
    dispatch_once(&onceToken,^{
        sharedInstance = [[JMTHttpClient alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    });
    
    return sharedInstance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

@end


@implementation NSDate(JMT)


-(NSString*) ToFullDate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter stringFromDate:self];
}


- (NSString*) ToFullDateTime
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:self];
}

- (NSString*) ToFullTime
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    return [dateFormatter stringFromDate:self];
}

- (NSString*) ToShortDate
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    return [dateFormatter stringFromDate:self];
}

- (NSString*) ToShortDateTime
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    return [dateFormatter stringFromDate:self];
}
- (NSString*) ToShortTime
{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    return [dateFormatter stringFromDate:self];
}


- (NSString*)ToNiceTime
{
    NSDate* now = [[NSDate alloc]init];
    NSTimeInterval delta = [now timeIntervalSince1970] - [self timeIntervalSince1970];
    if (delta <= 60) {
        return@"刚刚";
    }else if (delta <= 60 * 60) {
        
        return [NSString stringWithFormat:@"%d 分钟前", div(delta, 60).quot];
        
    }else if (delta <= 60 * 60 * 24){
        
        return [NSString stringWithFormat:@"%d 小时前", div(delta, 60 * 60).quot];
        
    }else if (delta <= 60 * 60 * 24 * 3){
        
        return [NSString stringWithFormat:@"%d 天前", div(delta, 60 * 60 * 24).quot];
        
    }else {
        return [self ToShortDateTime];
        
    }
    
}

@end
