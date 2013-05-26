//
//  APNSMsgPresentViewController.m
//  jiemeitao
//
//  Created by Bruce Yang on 5/25/13.
//  Copyright (c) 2013 bruce yang. All rights reserved.
//

#import "APNSMsgPresentViewController.h"
#import "AppDelegate.h"
#import "DetailTopicViewController.h"

@implementation APNSMsgManager

static APNSMsgManager *instance = nil;
+ (APNSMsgManager *)sharedInstance
{
    @synchronized(self) {
        if (instance == nil) {
            instance = [[self alloc] init]; // assignment not done here
        }
    }
    return instance;
}

- (void) presentModalViewControllerWith:(NSString *)topic_id
{
    APNSMsgPresentViewController *ac = [[APNSMsgPresentViewController alloc]initWithNibName:@"APNSMsgPresentViewController" bundle:nil];
    UIViewController *root =  ((AppDelegate *)[UIApplication sharedApplication].delegate).window.rootViewController;
    ac.topic_id = topic_id;
    [root presentModalViewController:ac animated:YES];
}

@end

@interface APNSMsgPresentViewController ()

@property (strong, nonatomic) DetailTopicViewController *dc;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

@end

@implementation APNSMsgPresentViewController

- (IBAction)dismiss:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dc = [[DetailTopicViewController alloc]initWithNibName:@"DetailTopicViewController" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.toolbar setBackgroundImage:[UIImage imageNamed:@"navigation-bar"]  forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = RGBCOLOR(255, 248, 248);
    UIButton *imageButton = [UIButton  buttonWithType:UIButtonTypeCustom];
    imageButton.frame = CGRectMake(0,0,38,32);
    [imageButton setImage:[UIImage imageNamed:@"nav-bar-btn-back"] forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:imageButton];
    
    UIBarButtonItem *seperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    seperator.width = -10.0f;
    
    [self.toolbar setItems:@[seperator, barItem]];
    
    CGRect frame = {0.0f, self.toolbar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height};
    self.dc.topic_id = self.topic_id;
    self.dc.view.frame = frame;
    [self.view addSubview:self.dc.view];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setToolbar:nil];
    [super viewDidUnload];
}
@end
