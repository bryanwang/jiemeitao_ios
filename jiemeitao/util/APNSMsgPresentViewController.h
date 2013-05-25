//
//  APNSMsgPresentViewController.h
//  jiemeitao
//
//  Created by Bruce Yang on 5/25/13.
//  Copyright (c) 2013 bruce yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APNSMsgManager: NSObject

+ (APNSMsgManager *)sharedInstance;
- (void)presentModalViewControllerWith: (NSString *)topic_id;

@end


@interface APNSMsgPresentViewController : UIViewController
@property (strong, nonatomic) NSString *topic_id;
@end
