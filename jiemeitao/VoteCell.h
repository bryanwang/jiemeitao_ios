//
//  VoteCell.h
//  jiemeitao
//
//  Created by Bruce yang on 13-5-24.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef void (^ VoteCellTappedBlock )(id topic);

@interface VoteCell : UITableViewCell
@property (nonatomic, retain) NSDictionary *topic;
@property (nonatomic, strong) id delegate;
//@property (nonatomic, strong) VoteCellTappedBlock voteCellTappedBlock;

@end
