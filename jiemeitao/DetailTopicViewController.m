//
//  DetailTopicViewController.m
//  jiemeitao
//
//  Created by Y.CORP.YAHOO.COM\yangshuo on 5/25/13.
//  Copyright (c) 2013 bruce yang. All rights reserved.
//

#import "DetailTopicViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"

@interface DetailTopicViewController ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSDictionary *topic;
@property (strong,nonatomic) NSArray *items;
- (void)loadVisiblePage;

@end

@implementation DetailTopicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self generateMockDate];
    [self initSetting];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setScrollView:nil];
    [self setPageControl:nil];
    [self setAvatarImageView:nil];
    [self setName:nil];
    [self setCreateTime:nil];
    [self setName:nil];
    [super viewDidUnload];
}

//get mock data
- (void)generateMockDate
{
    NSError *error = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock_detail" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    NSDictionary *json = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
    self.topic = json;
    self.items = self.topic[@"items"];
}


//get image count
-(NSInteger)getScrollerImageCount{
    return _items.count;
}

//init
- (void)initSetting
{
    UIPageControl *pageControl = self.pageControl;
    UIScrollView *scrollView = self.scrollView;
   
    scrollView.pagingEnabled = YES;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    pageControl.currentPage = 0;
    pageControl.numberOfPages = [self getScrollerImageCount];
    [self addImageToScollerView:scrollView];
}


//add images
- (void)addImageToScollerView:(UIScrollView *) scroller
{
    NSInteger count = self.items.count;
    NSString *avatar = _topic[@"user"][@"avatar"];
    self.name.text =_topic[@"user"][@"name"];
    self.createTime.text = _topic[@"create_time"];
    NSUInteger i;
    for (i = 0; i<count; i++) {
        NSString *imageUrl = _items[i][@"image"][0][@"url"];
        NSLog(@"%@", imageUrl);
        UIImageView *iv = [[UIImageView alloc]init];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.clipsToBounds = YES;
        [iv setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:DEFAULT_BG];
        CGRect rect = {i * scroller.bounds.size.width, 0.0f, scroller.bounds.size.width, scroller.bounds.size.height};
        NSLog(@"%@", NSStringFromCGRect(rect));
        iv.frame = rect;
        [scroller addSubview:iv];
    }
    scroller.contentSize = CGSizeMake(scroller.bounds.size.width * count, scroller.frame.size.height);
    [self initAvatar:avatar];
    [self initLike];
}

//init avatar
- (void)initAvatar:(NSString *) url
{
    self.avatarImageView.layer.borderColor = RGBCOLOR(255, 255, 255).CGColor;
    self.avatarImageView.layer.borderWidth = 1.0f;
    self.avatarImageView.layer.cornerRadius = 4.0f;
    self.avatarImageView.layer.masksToBounds = YES;
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    
}

//init like and unlike
- (void)initLike{
    CGRect b1 = {10.0f, 245.0f + MARGIN_HEIGHT, 49.0f, 49.0f};
    CGRect b2 = {260.0f, 245.0f + MARGIN_HEIGHT, 49.0f, 49.0f};
    UIButton *like = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *unlike = [UIButton buttonWithType:UIButtonTypeCustom];
    like.frame = b1;
    unlike.frame = b2;
    [like setBackgroundImage:[UIImage imageNamed:@"btn-choice-like-nor"] forState:UIControlStateNormal];
    [unlike setBackgroundImage:[UIImage imageNamed:@"btn-choice-hate-nor"] forState:UIControlStateNormal];
    
    [self.view addSubview:like];
    [self.view addSubview:unlike];
    
}

//add for page control
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    CGSize PagedScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(PagedScrollViewSize.width * self.getScrollerImageCount, PagedScrollViewSize.height);
}

- (void)loadVisiblePage{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x - pageWidth/2) / pageWidth) + 1; self.pageControl.currentPage = page;
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{ // 在屏幕上加载特定页面
    [self loadVisiblePage];
}


@end
