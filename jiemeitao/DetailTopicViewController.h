//
//  DetailTopicViewController.h
//  jiemeitao
//
//  Created by Y.CORP.YAHOO.COM\yangshuo on 5/25/13.
//  Copyright (c) 2013 bruce yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTopicViewController : JMTViewController <UIScrollViewDelegate>
@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) NSString *topic_id;
@end
