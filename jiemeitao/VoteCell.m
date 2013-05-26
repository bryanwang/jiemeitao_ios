//
//  VoteCell.m
//  jiemeitao
//
//  Created by Bruce yang on 13-5-24.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "VoteCell.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "DetailTopicViewController.h"
#import "APNSMsgPresentViewController.h"

@interface VoteCell()
@property (retain, nonatomic) IBOutlet UIImageView *avatar;
@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *create_time;
    
@end

@implementation VoteCell
@synthesize topic = _topic;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.avatar.layer.borderColor = RGBCOLOR(255, 255, 255).CGColor;
    self.avatar.layer.borderWidth = 1.0f;
    self.avatar.layer.cornerRadius = 4.0f;
    self.avatar.layer.masksToBounds = YES;
//    self.avatar.layer.shadowOffset = CGSizeMake(3, 3);
//    self.avatar.layer.shadowColor = [[UIColor blackColor] CGColor];
//    self.avatar.layer.shadowRadius = 4.0f;
//    self.avatar.layer.shadowOpacity = 0.80f;
//    self.avatar.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.avatar.layer.bounds] CGPath];
    
//    UIView *selv = [[UIView alloc]initWithFrame:self.bounds];
//    selv.backgroundColor = RGBCOLOR(249, 209, 219);
//    self.selectedBackgroundView = selv;
}

- (void)likeButtonTapped: (UIButton*)button
{
//    NSString *topicid = self.topic[@"id"];
    NSLog(@"like");
    [TSMessage showNotificationInViewController:self.delegate
                                      withTitle:NSLocalizedString(@"vote succ", @"")
                                    withMessage:nil
                                       withType:TSMessageNotificationTypeSuccess
                                    withDuration:MESSAGE_DRU];
}

- (void)hateButtonTapped: (UIButton*)button
{
//    NSString *topicid = self.topic[@"id"];
    NSLog(@"hate");
    [TSMessage showNotificationInViewController:self.delegate
                                      withTitle:NSLocalizedString(@"vote succ", @"")
                                    withMessage:nil
                                       withType:TSMessageNotificationTypeSuccess
                                   withDuration:MESSAGE_DRU];
}

- (void)showdetail
{
    DetailTopicViewController *vc = [[DetailTopicViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    vc.topic_id = [NSString stringWithFormat: @"%@",  self.topic[@"id"]];
    [((UIViewController *)self.delegate).navigationController pushViewController:vc animated:YES];
}

- (void) setTopic:(NSDictionary *)topic
{
    if (![_topic isEqualToDictionary:topic]) {
        _topic = topic;
        [self.avatar setImageWithURL:[NSURL URLWithString:topic[@"user"][@"avatar"]] placeholderImage:nil];
        self.name.text = topic[@"user"][@"name"];
        self.create_time.text = topic[@"create_time_ex"];
        __block float height = MARGIN_HEIGHT;
        
        //images
        NSArray *items = topic[@"items"];
        if (items == nil || items.count == 0) return;
        if (items.count == 1) {
            NSDictionary *item = items[0];
            CGRect r1 = {{0.0f, MARGIN_HEIGHT}, {CELL_WIDTH, CELL_WIDTH}};
            UIView *v = [[UIView alloc]initWithFrame:r1];
            CGRect r2 = {{0.0f, 0.0f}, {CELL_WIDTH, CELL_WIDTH}};
            UIImageView *i = [[UIImageView alloc]initWithFrame:r2];
            i.contentMode = UIViewContentModeScaleAspectFill;
            i.clipsToBounds = YES;
            [i setImageWithURL:[NSURL URLWithString:item[@"image"]] placeholderImage:DEFAULT_BG];
            [v addSubview:i];
            
            //buttons
            CGRect b1 = {10.0f, 265.0f + MARGIN_HEIGHT, 49.0f, 49.0f};
            UIButton *like = [UIButton buttonWithType:UIButtonTypeCustom];
            like.frame = b1;
            [like setBackgroundImage:[UIImage imageNamed:@"btn-choice-like-nor"] forState:UIControlStateNormal];
            CGRect b2 = {262.0f, 265.0f + MARGIN_HEIGHT, 49.0f, 49.0f};
            UIButton *hate = [UIButton buttonWithType:UIButtonTypeCustom];
            hate.frame = b2;
            [hate setBackgroundImage:[UIImage imageNamed:@"btn-choice-hate-nor"] forState:UIControlStateNormal];
            
            [like addTarget:self action:@selector(likeButtonTapped:) forControlEvents:UIControlEventTouchDown];
            [hate addTarget:self action:@selector(hateButtonTapped:) forControlEvents:UIControlEventTouchDown];

            [self addSubview:v];
            [self sendSubviewToBack:v];
            [self addSubview:like];
            [self addSubview:hate];

            height = height + CELL_WIDTH;
        }
        else {
            [items enumerateObjectsUsingBlock:^(id item, NSUInteger index, BOOL *stop) {
                CGRect r1 = {{0.0f + (index % 2) * CELL_WIDTH / 2, MARGIN_HEIGHT + (index / 2) * (CELL_WIDTH / 2)}, {CELL_WIDTH / 2,  CELL_WIDTH / 2}};
                UIView *v = [[UIView alloc]initWithFrame:r1];
                //images
                CGRect r2 = {{0.0f, 0.0f}, {CELL_WIDTH / 2, CELL_WIDTH / 2}};
                UIImageView *i = [[UIImageView alloc]initWithFrame:r2];
                i.contentMode = UIViewContentModeScaleAspectFill;
                i.clipsToBounds = YES;
                [i setImageWithURL:[NSURL URLWithString:item[@"image"]] placeholderImage:DEFAULT_BG];
                [v addSubview:i];
                
                //buttons
                CGRect b1 = {10.0f + (index % 2) * CELL_WIDTH / 2, 105.0f + MARGIN_HEIGHT + (index / 2) * (CELL_WIDTH / 2),  49.0f, 49.0f};
                UIButton *like = [UIButton buttonWithType:UIButtonTypeCustom];
                like.frame = b1;
                [like setBackgroundImage:[UIImage imageNamed:@"btn-choice-like-nor"] forState:UIControlStateNormal];
                [like addTarget:self action:@selector(likeButtonTapped:) forControlEvents:UIControlEventTouchDown];

                [self addSubview:v];
                [self sendSubviewToBack:v];
                [self addSubview:like];
            }];
            
            height = height + (items.count + 2 - 1) / 2 * (CELL_WIDTH / 2);
        }
        
    
        //count
        CGRect r3 = {{0.0f, height}, {CELL_WIDTH, COUNT_VIEW_HEIGHT - 1}};
        UIView *cv = [[UIView alloc]initWithFrame:r3];
        CALayer *border = [CALayer layer];
        border.frame = CGRectMake(0.0f, 0.0f, cv.frame.size.width, 1.0f);
        border.backgroundColor = RGBCOLOR(150, 99, 109).CGColor;
        [cv.layer addSublayer:border];
        
        CGRect r4 = {36.0f, 14.0f, 250.0f, 20.0f};
        UIImage *check = [UIImage imageNamed:@"img-check"];
        UIImageView *checkv = [[UIImageView alloc]initWithImage:check];
        checkv.frame = CGRectMake(10.0f, 14.0f, check.size.width, check.size.height);
        [cv addSubview:checkv];
        
        UILabel *l = [[UILabel alloc] initWithFrame: r4];
        l.numberOfLines = 0;
        l.backgroundColor = [UIColor clearColor];
        l.adjustsFontSizeToFitWidth = YES;
        l.textColor  = RGBCOLOR(100, 100, 100);
        l.font = [UIFont systemFontOfSize:18.0f];
        l.text =[NSString stringWithFormat:@"%@ 张投票", [topic objectForKey:@"par_count"], nil];
        [cv addSubview:l];
        
        UIImage *arrow = [UIImage imageNamed:@"img-arrow"];
        UIImageView *arrowv = [[UIImageView alloc]initWithImage:arrow];
        arrowv.frame = CGRectMake(300.0f, 16.0f, arrow.size.width, arrow.size.height);
        [cv addSubview:arrowv];
        [self addSubview: cv];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showdetail)];
        tap.numberOfTapsRequired = 1;
        cv.userInteractionEnabled = YES;
        [cv addGestureRecognizer:tap];

        height = height + COUNT_VIEW_HEIGHT;
        
        //sep
        UIImage *img = [UIImage imageNamed:@"homepage-gap"];
        UIImageView *iv = [[UIImageView alloc] initWithImage:img];
        iv.frame = CGRectMake(0.0f, height, img.size.width, img.size.height);
        
        [self addSubview:iv];
    }
}

@end
