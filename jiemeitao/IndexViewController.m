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
@property (strong, nonatomic) NSArray *topics;

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

//- (NSArray *)topics
//{
//    if (_topics == nil) {
//        _topics = [NSArray array];
//    }
//    
//    return _topics;
//}
//
- (void)setTopics:(NSArray *)topics
{
    if (![_topics isEqualToArray:topics]) {
        _topics = topics;
        [self.tableview reloadData];
    }
}

- (void)generateMockData
{
    NSError *error = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock_votes" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    NSArray *json = (NSArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
    self.topics = json;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage: [UIImage imageNamed:@"nav-bar-logo"]];
    self.tableview.backgroundColor = RGBCOLOR(255, 248, 248);
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self generateMockData];
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
    if (topic[@"image"] == nil || [topic[@"image"] count] == 0)
        return INIT_HEIGHT;
    else if ([topic[@"image"] count] == 1)
        return MARGIN_HEIGHT + CELL_WIDTH + SEP_HEIGHT + COUNT_VIEW_HEIGHT;
    else
        return MARGIN_HEIGHT + SEP_HEIGHT + COUNT_VIEW_HEIGHT + (CELL_WIDTH / 2) * (int)(([topic[@"image"] count] + 2 -1) / 2);
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
