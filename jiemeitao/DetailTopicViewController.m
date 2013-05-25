//
//  DetailTopicViewController.m
//  jiemeitao
//
//  Created by Y.CORP.YAHOO.COM\yangshuo on 5/25/13.
//  Copyright (c) 2013 bruce yang. All rights reserved.
//


//view tag == -1 means need to be update.

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

    [self setNavigationItemTitle:NSLocalizedString(@"topic detail", @"") withColor:RGBCOLOR(232, 96, 130)];
    [self addCustomBackButton];
    [self generateMockDate];
    [self initSetting];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    
    self.scrollView.delegate = self;
    
    
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
    //从第一个开始
    [self changeViewByScroll:0];
    [self initSmallAvata:_items[1]];
}

//init avatar
- (void)initAvatar:(NSString *) url
{
    self.avatarImageView.layer.borderColor = RGBCOLOR(0, 0, 0).CGColor;
    self.avatarImageView.layer.borderWidth = 1.0f;
    self.avatarImageView.layer.cornerRadius = 4.0f;
    self.avatarImageView.layer.masksToBounds = YES;
    [self.avatarImageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:nil];
    
}

//init like and unlike
- (void)initLike{
    CGRect b1 = {10.0f, 200.0f + MARGIN_HEIGHT, 49.0f, 49.0f};
    CGRect b2 = {260.0f, 200.0f + MARGIN_HEIGHT, 49.0f, 49.0f};
    UIButton *like = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *unlike = [UIButton buttonWithType:UIButtonTypeCustom];
    like.frame = b1;
    unlike.frame = b2;
    [like setBackgroundImage:[UIImage imageNamed:@"btn-choice-like-nor"] forState:UIControlStateNormal];
    [unlike setBackgroundImage:[UIImage imageNamed:@"btn-choice-hate-nor"] forState:UIControlStateNormal];
   
    [like addTarget:self action:@selector(likeButtonTapped:) forControlEvents:UIControlEventTouchDown];
    [unlike addTarget:self action:@selector(hateButtonTapped:) forControlEvents:UIControlEventTouchDown];
    
    
    [self.view addSubview:like];
    [self.view addSubview:unlike];
    
}

//like and unlike handler

- (void)likeButtonTapped: (UIButton*)button
{
    NSLog(@"like");
}

- (void)hateButtonTapped: (UIButton*)button
{
    NSLog(@"hate");
}


//init progress bar
- (void)initProgressBar:(double)percent
{    
    
    //TODO : set background

    UIImage *img1 = [UIImage imageNamed:@"sort-bar_01-sel@2x.png"];
    UIImage *img2 = [UIImage imageNamed:@"sort-bar_03-nor@2x.png"];
    double likeLength = img1.size.width;
    double unlikeLength = img2.size.width*0.8;
    
    likeLength = likeLength*(2*percent);
    unlikeLength = unlikeLength*(2*(1-percent));
    
    UIImageView *iv1 = [[UIImageView alloc] initWithImage:img1];
    UIImageView *iv2 = [[UIImageView alloc] initWithImage:img2];
    iv1.frame = CGRectMake(10.0f, 320.0f, likeLength, img1.size.height*0.6);
    iv2.frame = CGRectMake(likeLength, 320.0f, unlikeLength-10.0f, img2.size.height*0.6);
 
    [self.view addSubview:iv1];
    [self.view addSubview:iv2];
    
    iv1.tag = -1;
    iv2.tag = -1;
    
    //set text
    NSInteger per_i = percent*100;
    CGRect t_rect = {36.0f, 330.0f, 250.0f, 20.0f};
    UILabel *t_Bar = [[UILabel alloc] initWithFrame: t_rect];
    t_Bar.numberOfLines = 0;
    t_Bar.backgroundColor = [UIColor clearColor];
    t_Bar.adjustsFontSizeToFitWidth = YES;
    t_Bar.textColor  = RGBCOLOR(100, 100, 100);
    t_Bar.font = [UIFont systemFontOfSize:18.0f];
    t_Bar.text =[NSString stringWithFormat:@"%i 的人选择了这件", per_i, nil];
    [self.view addSubview:t_Bar];

}

//init small avatar
- (void)initSmallAvata:(NSDictionary*)item
{
    NSArray *voteUsers = item[@"vote_users"];
    NSInteger count = voteUsers.count;
    NSInteger width = 32;
    NSInteger height = 32;
    double start_x = 10.0f;
    double start_y = 360.0f;
    double separate = 7.0f;
    
    for (NSUInteger i = 0; i<count; i++) {
        NSString *avatar = voteUsers[i][@"avatar"];
        NSLog(@"%@", avatar);
        UIImageView *iv = [[UIImageView alloc]init];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        [iv setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:DEFAULT_BG];
        CGRect rect = {i * (width+separate)+start_x, start_y, width, height};
        NSLog(@"%@", NSStringFromCGRect(rect));
        iv.frame = rect;
        iv.tag = -1;
        [self.view addSubview:iv];
    }
}

//change data by item index
-(void)changeViewByScroll:(NSInteger)index
{
    //first clear
    for(UIView *subView in [self.view subviews]){
        if(subView.tag == -1){
         [subView removeFromSuperview];
        }
    }
    
    NSDictionary *item = _items[index];
    
    [self initProgressBar:[item[@"percent"] floatValue]];
    [self initSmallAvata:item];
    
}

//add for page control
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGSize PagedScrollViewSize = self.scrollView.frame.size;
    self.scrollView.contentSize = CGSizeMake(PagedScrollViewSize.width * self.getScrollerImageCount, PagedScrollViewSize.height);
}

- (void)loadVisiblePage
{
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x - pageWidth/2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    [self changeViewByScroll:page];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self loadVisiblePage];
}


@end
