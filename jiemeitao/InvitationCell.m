//
//  InvitationCell.m
//  jiemeitao
//
//  Created by Bruce Yang on 5/25/13.
//  Copyright (c) 2013 bruce yang. All rights reserved.
//

#import "InvitationCell.h"
#import <QuartzCore/QuartzCore.h>

@interface InvitationCell()
@property (strong, nonatomic) IBOutlet UIImageView *avatar;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *create_at;

@end

@implementation InvitationCell

- (void)awakeFromNib
{
    self.avatar.layer.borderColor = RGBCOLOR(255, 255, 255).CGColor;
    self.avatar.layer.borderWidth = 1.0f;
    self.avatar.layer.cornerRadius = 4.0f;
    self.avatar.layer.masksToBounds = YES;
    
    self.name.highlightedTextColor = self.name.textColor;
    self.create_at.highlightedTextColor = self.create_at.textColor;
}

- (void)setInvitation:(NSDictionary *)invitation
{
    if (![_invitation isEqualToDictionary:invitation]) {
        [self.avatar setImageWithURL:[NSURL URLWithString:invitation[@"user"][@"avatar"]] placeholderImage:nil];
        self.name.text = invitation[@"user"][@"name"];
    }
}

@end
