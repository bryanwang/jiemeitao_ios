//
//  VoteCell.m
//  jiemeitao
//
//  Created by Bruce yang on 13-5-24.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "VoteCell.h"
#import <QuartzCore/QuartzCore.h>

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
    NSString *topicid = self.topic[@"id"];
    NSLog(@"like");
}

- (void)hateButtonTapped: (UIButton*)button
{
    NSString *topicid = self.topic[@"id"];
    NSLog(@"hate");
}

- (void) setTopic:(NSDictionary *)topic
{
    if (![_topic isEqualToDictionary:topic]) {
        _topic = topic;
        [self.avatar setImageWithURL:[NSURL URLWithString:topic[@"user"][@"avatar"]] placeholderImage:nil];
        self.name.text = topic[@"user"][@"name"];
        self.create_time.text = topic[@"create_time"];
        __block float height = MARGIN_HEIGHT;
        
        //images
        if (topic[@"image"] == nil || [topic[@"image"] count] == 0) return;
        if ([topic[@"image"] count] == 1) {
            NSDictionary *image = topic[@"image"][0];
            CGRect r1 = {{0.0f, MARGIN_HEIGHT}, {CELL_WIDTH, CELL_WIDTH}};
            UIView *v = [[UIView alloc]initWithFrame:r1];
            CGRect r2 = {{0.0f, 0.0f}, {CELL_WIDTH, CELL_WIDTH}};
            UIImageView *i = [[UIImageView alloc]initWithFrame:r2];
            i.contentMode = UIViewContentModeScaleAspectFill;
            i.clipsToBounds = YES;
            [i setImageWithURL:[NSURL URLWithString:image[@"url"]] placeholderImage:DEFAULT_BG];
            [v addSubview:i];
            
            //buttons
            CGRect b1 = {10.0f, 265.0f, 49.0f, 49.0f};
            UIButton *like = [UIButton buttonWithType:UIButtonTypeCustom];
            like.frame = b1;
            [like setBackgroundImage:[UIImage imageNamed:@"btn-choice-like-nor"] forState:UIControlStateNormal];
            [like addTarget:self action:@selector(likeButtonTapped:) forControlEvents:UIControlEventTouchDown];
            CGRect b2 = {262.0f, 265.0f, 49.0f, 49.0f};
            UIButton *hate = [UIButton buttonWithType:UIButtonTypeCustom];
            hate.frame = b2;
            [hate setBackgroundImage:[UIImage imageNamed:@"btn-choice-hate-nor"] forState:UIControlStateNormal];
            [hate addTarget:self action:@selector(hateButtonTapped:) forControlEvents:UIControlEventTouchDown];
            
            [v addSubview:like];
            [v addSubview:hate];
                    
            [self addSubview:v];
            [self sendSubviewToBack:v];
            
            height = height + CELL_WIDTH;
        }
        else {
            [topic[@"image"] enumerateObjectsUsingBlock:^(id image, NSUInteger index, BOOL *stop) {
                CGRect r1 = {{0.0f + (index % 2) * CELL_WIDTH / 2, MARGIN_HEIGHT + (index / 2) * (CELL_WIDTH / 2)}, {CELL_WIDTH / 2,  CELL_WIDTH / 2}};
                UIView *v = [[UIView alloc]initWithFrame:r1];
                //images
                CGRect r2 = {{0.0f, 0.0f}, {CELL_WIDTH / 2, CELL_WIDTH / 2}};
                UIImageView *i = [[UIImageView alloc]initWithFrame:r2];
                i.contentMode = UIViewContentModeScaleAspectFill;
                i.clipsToBounds = YES;
                [i setImageWithURL:[NSURL URLWithString:image[@"url"]] placeholderImage:DEFAULT_BG];
                [v addSubview:i];
                
                //buttons
                CGRect b1 = {10.0f, 105.0f, 49.0f, 49.0f};
                UIButton *like = [UIButton buttonWithType:UIButtonTypeCustom];
                like.frame = b1;
                [like setBackgroundImage:[UIImage imageNamed:@"btn-choice-like-nor"] forState:UIControlStateNormal];
                [like addTarget:self action:@selector(likeButtonTapped:) forControlEvents:UIControlEventTouchDown];
                [v addSubview:like];
                
                [self addSubview:v];
                [self sendSubviewToBack:v];
            }];
            
            height = height + ([topic[@"image"] count] + 2 - 1) / 2 * (CELL_WIDTH / 2);
        }
        
        //count
        CGRect r3 = {{0.0f, height}, {CELL_WIDTH, COUNT_VIEW_HEIGHT}};
        UIView *cv = [[UIView alloc]initWithFrame:r3];
        cv.backgroundColor = [UIColor clearColor];
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
        [self addSubview: cv];
        
        UIImage *arrow = [UIImage imageNamed:@"img-arrow"];
        UIImageView *arrowv = [[UIImageView alloc]initWithImage:arrow];
        arrowv.frame = CGRectMake(300.0f, 16.0f, arrow.size.width, arrow.size.height);
        [cv addSubview:arrowv];

        
        height = height + COUNT_VIEW_HEIGHT;
        
        //sep
        UIImage *img = [UIImage imageNamed:@"homepage-gap"];
        UIImageView *iv = [[UIImageView alloc] initWithImage:img];
        iv.frame = CGRectMake(0.0f, height, img.size.width, img.size.height);
        
        [self addSubview:iv];
    }
}

@end
