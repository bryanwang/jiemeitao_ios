//
//  DetailTopicViewController.m
//  jiemeitao
//
//  Created by Y.CORP.YAHOO.COM\yangshuo on 5/25/13.
//  Copyright (c) 2013 bruce yang. All rights reserved.
//

#import "DetailTopicViewController.h"

@interface DetailTopicViewController ()
 @property (strong, nonatomic) NSDictionary *topic;
 @property (strong,nonatomic) NSArray *items;
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
    [super viewDidUnload];
}

//get mock data
- (void)generateMockDate
{
    NSError *error = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock_detail" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    NSArray *json = (NSArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
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
   
    
    pageControl.currentPage = 0;
    pageControl.numberOfPages = [self getScrollerImageCount];
    scrollView.frame = CGRectMake(0, 0, 320, 420);//TODO
    
    [self addImageToScollerView:scrollView];
    
}


//add images
- (void)addImageToScollerView:(UIScrollView *) scroller
{
    NSUInteger i;
    for (i = 0; i<self.getScrollerImageCount;i++) {
        
        NSString *imageUrl = _items[i][@"image"][0][@"url"];
        UIImageView *iv = [[UIImageView alloc]init];
        [iv setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:DEFAULT_BG];
        CGRect rect = iv.frame;
        rect.size.height = scroller.frame.size.height;
        rect.size.width = scroller.frame.size.width;
        iv.frame = rect;
        [scroller addSubview:iv];
    }
}


@end
