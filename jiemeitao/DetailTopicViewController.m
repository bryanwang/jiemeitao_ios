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
@property (strong, nonatomic) IBOutlet UIScrollView *baseScroll;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) NSDictionary *topic;
@property (strong,nonatomic) NSArray *items;
- (void)loadVisiblePage;

@end

@implementation DetailTopicViewController {
    float y;
}

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
    self.title = NSLocalizedString(@"topic detail", "");
    [self addCustomBackButton];
    [self generateMockDate];
    [self initSetting];
    
    [super viewDidLoad];
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
    [self setBaseScroll:nil];
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

        UIImageView *iv = [[UIImageView alloc]init];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        iv.clipsToBounds = YES;
        [iv setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:DEFAULT_BG];
        CGRect rect = {i * scroller.bounds.size.width, 0.0f, scroller.bounds.size.width, scroller.bounds.size.height};

        iv.frame = rect;
        [scroller addSubview:iv];
    }
    scroller.contentSize = CGSizeMake(scroller.bounds.size.width * count, scroller.frame.size.height);
    [self initAvatar:avatar];
    [self initLike];
    //从第一个开始
    [self changeViewByScroll:0];
//    [self initSmallAvata:_items[1]];
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
- (void)initLike
{
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
    
    
    [self.baseScroll addSubview:like];
    [self.baseScroll addSubview:unlike];
    
}

//like and unlike handler
- (IBAction)pageControlTapped:(UIPageControl *)sender {
    CGRect rect = CGRectMake([sender currentPage] * self.scrollView.frame.size.width, 0,
                             self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView scrollRectToVisible:rect animated:YES];
}

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
    y  = self.scrollView.frame.size.height +self.scrollView.frame.origin.y + 10.0f;
    float paddingLeft = 10.0f;
    float width = APP_CONTENT_WIDTH - 10.0f;
    float likeLength = (width-paddingLeft)/2;
    float capLeft = 10.0f;
    float capTop = 5.0f;
    
    //set background
    UIImage *img_bk = [UIImage imageNamed:@"detailpage-sortbar-bg.png"];
    UIImageView *iv_bk = [[UIImageView alloc] initWithImage:img_bk];
    iv_bk.frame = CGRectMake(0.0f, y, img_bk.size.width, img_bk.size.height*0.7);
    [self.baseScroll addSubview:iv_bk];

    UIImage *img1 = [UIImage imageNamed:@"detailpage-sortbar_01-sel.png"];
    UIImage *img2 = [UIImage imageNamed:@"detailpage-sortbar_02-nor.png"];

    likeLength = likeLength*(2*percent);
    img1=[img1 stretchableImageWithLeftCapWidth:capLeft topCapHeight:0];
    img2 = [img2 stretchableImageWithLeftCapWidth:capTop topCapHeight:0];
    UIImageView *iv1 = [[UIImageView alloc] initWithImage:img1];
    UIImageView *iv2 = [[UIImageView alloc] initWithImage:img2];
    iv1.frame = CGRectMake(paddingLeft, y, likeLength, img1.size.height);
    iv2.frame = CGRectMake(likeLength+paddingLeft, y, width-likeLength-paddingLeft, img2.size.height);
 
    [self.baseScroll addSubview:iv1];
    [self.baseScroll addSubview:iv2];
    
    iv1.tag = -1;
    iv2.tag = -1;
    
    //set text
    NSInteger per_i = percent*100;
//    CGRect t_rect = {36.0f, 328.0f, 250.0f, 20.0f};
//    UILabel *t_Bar = [[UILabel alloc] initWithFrame: t_rect];
    
    UILabel *t_Bar = [[UILabel alloc]init];
    t_Bar.numberOfLines = 0;
    t_Bar.backgroundColor = [UIColor clearColor];
    t_Bar.adjustsFontSizeToFitWidth = YES;
    t_Bar.textColor  = RGBCOLOR(100, 100, 100);
    t_Bar.font = [UIFont systemFontOfSize:18.0f];
    t_Bar.text =[NSString stringWithFormat:@"%i%%的人选择了这件", per_i, nil];
    [t_Bar sizeToFit];
    SET_VIEW_X(t_Bar, paddingLeft + capLeft);
    SET_VIEW_Y(t_Bar, y + capTop);
    [self.baseScroll addSubview:t_Bar];
    
    y = y + iv1.frame.size.height;
    self.baseScroll.contentSize = CGSizeMake(self.baseScroll.frame.size.width, y + 40.0f);
}

//init small avatar
- (void)initSmallAvata:(NSDictionary*)item
{
    y = y + 10.0f;
    NSArray *voteUsers = item[@"vote_users"];
    NSInteger count = voteUsers.count;
    NSInteger width = 28;
    NSInteger height = 28;
    double start_x = 10.0f;
    double separate = 7.0f;
    
    for (NSUInteger i = 0; i<count; i++) {
        NSString *avatar = voteUsers[i][@"avatar"];
        NSLog(@"%@", avatar);
        UIImageView *iv = [[UIImageView alloc]init];
        iv.contentMode = UIViewContentModeScaleAspectFill;
        [iv setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:DEFAULT_BG];
        CGRect rect = {i * (width+separate)+start_x, y, width, height};
        iv.frame = rect;
        iv.layer.cornerRadius = 4.0f;
        iv.clipsToBounds = YES;
        iv.tag = -1;
        [self.baseScroll addSubview:iv];
    }
    
    y = y + height;
    self.baseScroll.contentSize = CGSizeMake(self.baseScroll.frame.size.width, y + 40.0f);
}

//change data by item index
-(void)changeViewByScroll:(NSInteger)index
{
    //first clear
    for(UIView *subView in [self.baseScroll subviews]){
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



- (void)scrollViewDidEndDecelerating: (UIScrollView *)scrollView
{
    [self loadVisiblePage];
}


@end
