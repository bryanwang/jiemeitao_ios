//
//  ReceivedInvitationsTableViewController.h
//  jiemeitao
//
//  Created by Bruce Yang on 5/25/13.
//  Copyright (c) 2013 bruce yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ InvitationItemTappedBlock )(id invitation);

@interface ReceivedInvitationsTableViewController : UITableViewController

@property (nonatomic, strong) InvitationItemTappedBlock invitationItemTappedBlock;

@end
