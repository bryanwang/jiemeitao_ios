//
//  ReceivedInvitationsTableViewController.m
//  jiemeitao
//
//  Created by Bruce Yang on 5/25/13.
//  Copyright (c) 2013 bruce yang. All rights reserved.
//

#import "ReceivedInvitationsTableViewController.h"
#import "InvitationCell.h"

@interface ReceivedInvitationsTableViewController ()
@property (strong, nonatomic) NSMutableArray *invitations;
@property (strong, nonatomic) NSMutableArray *dates;
@end

@implementation ReceivedInvitationsTableViewController

- (void) setInvitations:(NSMutableArray *)invitations
{
    if (![_invitations isEqual:invitations]) {
        _invitations = invitations;
        [self.tableView reloadData];
    }
}

- (void) generateDateAndInvitations: (NSArray *)invitations
{
    NSArray *dates = [invitations valueForKeyPath:@"create_time"];
    NSSet *uniqueDates = [NSSet setWithArray:dates];

    NSMutableArray *array = [NSMutableArray array];
    self.dates = [[uniqueDates allObjects] mutableCopy];
    [self.dates enumerateObjectsUsingBlock:^(id date, NSUInteger index, BOOL *stop) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(create_time like %@)", date];
        NSArray *temp = [invitations filteredArrayUsingPredicate:predicate];
        [array addObject:temp];
    }];
    
    self.invitations = array;
}

- (void)generateMockData
{
    NSError *error = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mock_invitations" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:filePath]];
    NSArray *json = (NSArray *)[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &error];
    [self generateDateAndInvitations: json];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.backgroundColor = RGBCOLOR(150, 99, 109);
    self.tableView.separatorColor = RGBCOLOR(150, 99, 109);
    
    [self generateMockData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dates.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGRect  r = {0.0f, 0.0f, tableView.bounds.size.width, SECTION_HEIGHT};
	UIView* customView = [[UIView alloc] initWithFrame:r];
    customView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg-section.png"]];
	UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, tableView.bounds.size.width - 20.0f, 23.0f)];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.opaque = NO;
	headerLabel.textColor = RGBCOLOR(232, 96, 130);
	headerLabel.font = [UIFont boldSystemFontOfSize:14];
	headerLabel.text = [self.dates objectAtIndex:section];
	[customView addSubview:headerLabel];
	
	return customView;
}

- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return SECTION_HEIGHT;
}

- (float)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.0f;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [self.invitations objectAtIndex:section];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InvitationCell";
    InvitationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (InvitationCell *)[[[NSBundle mainBundle]loadNibNamed:@"InvitationCell" owner:self options:nil] lastObject];
    }
    
    NSArray *invitations = [self.invitations objectAtIndex:indexPath.section];
    NSDictionary *invitation = [invitations objectAtIndex:indexPath.row];
    cell.invitation = invitation;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *invitation = [[self.invitations objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if (self.invitationItemTappedBlock)
        self.invitationItemTappedBlock(invitation);
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell forRowAtIndexPath: (NSIndexPath*)indexPath
{
    UIView *nor = [[UIView alloc]initWithFrame:cell.bounds];
    nor.backgroundColor = RGBCOLOR(255, 248, 248);
    cell.backgroundView  = nor;
    
    UIView *sel = [[UIView alloc]initWithFrame:cell.bounds];
    sel.backgroundColor = RGBCOLOR(255, 221, 230);
    cell.selectedBackgroundView = sel;
}

@end
