//
//  IndexViewController.m
//  jiemeitao
//
//  Created by tangyong on 13-5-23.
//  Copyright (c) 2013年 bruce yang. All rights reserved.
//

#import "IndexViewController.h"
#import "VoteCell.h"

@interface IndexViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong, nonatomic) NSMutableArray *topics;

@end

@implementation IndexViewController
@synthesize  topics = _topics;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setTopics:(NSMutableArray *)topics
{
    if (![_topics isEqualToArray:topics]) {
        NSMutableArray *array = [NSMutableArray array];
        
        [topics enumerateObjectsUsingBlock:^(id topic, NSUInteger index, BOOL *stop) {
            NSMutableDictionary *dic = [topic mutableCopy];
            
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
            NSDate *date = [dateFormatter dateFromString: topic[@"create_time"]];
            NSString *create_time_ex = [date ToNiceTime];
            dic[@"create_item_ex"] = create_time_ex;
            
            [array addObject:dic];
        }];
        
        _topics = array;
        [self.tableview reloadData];
    }
}

//- (void)generateMockData
//{
//    NSError *error = nil;
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock_votes" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
//    NSMutableArray *json = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
//    self.topics = json;
//}

- (void)fetchData
{
    [[JMTHttpClient shareIntance] getPath:TOPIC_ALL_INTERFACE parameters:nil success:^(AFHTTPRequestOperation *operation, id JSON) {
        self.topics = (NSMutableArray *)JSON;
    } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error..");
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"nav-bar-logo"]];
    self.tableview.backgroundColor = RGBCOLOR(255, 248, 248);
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    [self generateMockData];
    [self fetchData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.topics.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *topic = [self.topics objectAtIndex:indexPath.row];
    NSArray *items = topic[@"items"];
    if (items == nil || items.count == 0)
        return INIT_HEIGHT;
    else if (items.count == 1)
        return MARGIN_HEIGHT + CELL_WIDTH + SEP_HEIGHT + COUNT_VIEW_HEIGHT;
    else
        return MARGIN_HEIGHT + SEP_HEIGHT + COUNT_VIEW_HEIGHT + (CELL_WIDTH / 2) * (int)((items.count + 2 -1) / 2);
}

- (VoteCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"VoteCell_%d", indexPath.row, nil];
    VoteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (VoteCell *)[[NSBundle mainBundle]loadNibNamed:@"VoteCell" owner:self options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.topic = [self.topics objectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc {

}
- (void)viewDidUnload {
    [self setTableview:nil];
    [super viewDidUnload];
}
@end
