//
//  JMTViewController.m
//  jiemeitao
//
//  Created by tangyong on 13-5-23.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "JMTViewController.h"

@interface JMTViewController ()

@end

@implementation JMTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation-bar"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = RGBCOLOR(255, 248, 248);
    [self setNavigationItemTitleColor:RGBCOLOR(232, 96, 130)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

@end
