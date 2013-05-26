//
//  PersonalViewController.m
//  jiemeitao
//
//  Created by tangyong on 13-5-23.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "PersonalViewController.h"
#import <AKSegmentedControl.h>
#import "ReceivedInvitationsTableViewController.h"
#import "DetailTopicViewController.h"

@interface PersonalViewController () {
    UITableView *tableivew;
}
@property (strong, nonatomic) ReceivedInvitationsTableViewController  *receivedInvitationsTableViewController;
@end

@implementation PersonalViewController

- (ReceivedInvitationsTableViewController *)receivedInvitationsTableViewController
{
    if (_receivedInvitationsTableViewController == nil) {
        _receivedInvitationsTableViewController = [[ReceivedInvitationsTableViewController alloc]init];
        
        __block PersonalViewController *pc = self;
        _receivedInvitationsTableViewController.invitationItemTappedBlock = ^(id invitation) {
            DetailTopicViewController *vc = [[DetailTopicViewController alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            vc.topic_id = invitation[@"id"];
            [pc.navigationController pushViewController:vc animated:YES];
        };
    }
    
    return _receivedInvitationsTableViewController;
}

- (void)addTableViewToSelfView: (UITableView *)tableview
{
    if (tableivew == nil) return;
    CGRect f = {0.0f, 0.0f, GET_VIEW_WIDTH(self.view), GET_VIEW_HEIGHT(self.view)};
    tableivew.frame = f;
    [self.view addSubview:tableivew];
}

- (void) segmentedControlValueChanged: (AKSegmentedControl *)sender
{
    NSUInteger index =  [sender.selectedIndexes lastIndex];
    if (tableivew != nil) {
        [tableivew removeFromSuperview];
        tableivew = nil;
    }
    switch (index) {
            case 0:
                break;
            case 1:
                break;
        case 2:
                tableivew = self.receivedInvitationsTableViewController.tableView;
    }
    
    [self addTableViewToSelfView:tableivew];
}

- (void)registerTableViewMessage
{
    if (tableivew == nil) return;
    [tableivew receiveObject:^(id obj) {
        NSLog(@"%@", obj);
    } withIdentifier: SHOW_INVITATION_MSG];
}

- (void)generateSegmentedControl
{

    CGRect b = {0.0f, 0.0f, 86.0f, 30.0f};
    CGRect r = {0.0f, 0.0f, 258.0f, 30.0f};
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:b];
    [btn1 setTitle:NSLocalizedString(@"my initiated votes", "") forState:UIControlStateNormal];
    [btn1 setTitleColor: RGBCOLOR(227, 78, 99) forState:UIControlStateNormal];
    [btn1 setTitleColor: RGBCOLOR(255, 255, 255) forState:UIControlStateHighlighted];
    [btn1 setTitleColor: RGBCOLOR(255, 255, 255) forState:UIControlStateSelected];
    [btn1.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [btn1 setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"sort-bar_01-nor"] forState:UIControlStateNormal];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"sort-bar_01-sel"] forState:UIControlStateSelected];
    [btn1 setBackgroundImage:[UIImage imageNamed:@"sort-bar_01-sel"] forState:UIControlStateHighlighted];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:b];
    [btn2 setTitle:NSLocalizedString(@"my received votes", "") forState:UIControlStateNormal];
    [btn2 setTitleColor: RGBCOLOR(227, 78, 99) forState:UIControlStateNormal];
    [btn2 setTitleColor: RGBCOLOR(255, 255, 255) forState:UIControlStateHighlighted];
    [btn2 setTitleColor: RGBCOLOR(255, 255, 255) forState:UIControlStateSelected];
    [btn2.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [btn2 setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 0.0)];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"sort-bar_02-nor"] forState:UIControlStateNormal];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"sort-bar_02-sel"] forState:UIControlStateSelected];
    [btn2 setBackgroundImage:[UIImage imageNamed:@"sort-bar_02-sel"] forState:UIControlStateHighlighted];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:b];
    [btn3 setTitle:NSLocalizedString(@"my received invitations", "") forState:UIControlStateNormal];
    [btn3 setTitleColor: RGBCOLOR(227, 78, 99) forState:UIControlStateNormal];
    [btn3 setTitleColor: RGBCOLOR(255, 255, 255) forState:UIControlStateHighlighted];
    [btn3 setTitleColor: RGBCOLOR(255, 255, 255) forState:UIControlStateSelected];
    [btn3.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [btn3 setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 2.0, 0.0, 2.0)];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"sort-bar_03-nor"] forState:UIControlStateNormal];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"sort-bar_03-sel"] forState:UIControlStateSelected];
    [btn3 setBackgroundImage:[UIImage imageNamed:@"sort-bar_03-sel"] forState:UIControlStateHighlighted];
    
    AKSegmentedControl *segmentedControl = [[AKSegmentedControl alloc] initWithFrame:r];
    segmentedControl.separatorImage = [[UIImage alloc] init];
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setSegmentedControlMode:AKSegmentedControlModeSticky];
    segmentedControl.buttonsArray = @[btn1, btn2, btn3];
    self.navigationItem.titleView = segmentedControl;
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [segmentedControl setSelectedIndex:2];
    
    tableivew = self.receivedInvitationsTableViewController.tableView;
    [self addTableViewToSelfView:tableivew];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self generateSegmentedControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
