//
//  Home.m
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import "Profile.h"
#import "DiveDetails.h"
#import "ProfileCell.h"
#import "SCAppUtils.h"

@interface Profile (private)
-(void) createBarButtons;
-(void) createTempDives;
-(void) recalculateData;
@end

@implementation Profile

@synthesize dives = _dives, 
            profileTableView = _profileTableView, 
            appDelegate = _appDelegate,
            totalDives = _totalDives,
            totalMinutesSpentDiving = _totalMinutesSpentDiving;

- (id) init {
    self = [super initWithNibName:@"Profile" bundle:nil];
    [self setTitle:@"Profile"];
    [self.tabBarItem setImage:[UIImage imageNamed:@"user.png"]];
    if(self) {
        // Load 
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _appDelegate = (TYAppDelegate *) [[UIApplication sharedApplication] delegate];
    if(!_appDelegate.dives) {
        _appDelegate.dives = [[NSMutableArray alloc] init];
    }
    _dives = _appDelegate.dives;
    [_profileTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 10.0)]];
    [_profileTableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background_retinadisplay.png"]]];
    [_profileTableView reloadData];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self recalculateData];
    [_profileTableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect frame = CGRectMake(0.0, 0.0, 320.0, 30.0);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"UITableViewHeader.png"]]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(3.0, 0.0, 320.0, 30.0)];
    [headerLabel setText:@"Your Profile"];
    [headerLabel setTextColor:[UIColor whiteColor]];
    [headerLabel setShadowColor:[UIColor blackColor]];
    [headerLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [view addSubview:headerLabel];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseId = @"ProfileCell";
    ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if(!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:self options:nil];
		for (id oneObject in nib) {
			if([oneObject isKindOfClass:[ProfileCell class]])
				cell = (ProfileCell *) oneObject;
		}
    }
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableViewCellBG.png"]];
    
    if(indexPath.row == 0) {
        [cell.img setImage:[UIImage imageNamed:@"line-chart.png"]];
        [cell.categoryName setText:@"Total Dives"];
        [[cell categoryName] setShadowColor:[UIColor whiteColor]];
        [cell.categoryName setShadowOffset:CGSizeMake(0.0, 1.0)];
        NSString *totalDives = [NSString stringWithFormat:@"%d", _totalDives];
        [cell.categoryDetail setText:totalDives];
    }
    else if(indexPath.row == 1) {
        [cell.img setImage:[UIImage imageNamed:@"clock.png"]];
        [cell.categoryName setText:@"Total Minutes"];
        [[cell categoryName] setShadowColor:[UIColor whiteColor]];
        [cell.categoryName setShadowOffset:CGSizeMake(0.0, 1.0)];
        NSString *totalMinutes = [NSString stringWithFormat:@"%d", _totalMinutesSpentDiving];
        [cell.categoryDetail setText:totalMinutes];
    }

    return cell;
}

#pragma mark - Helpers

-(void) recalculateData {
    _totalDives = [_dives count];
    _totalMinutesSpentDiving = 0;
    for (int i=0; i < [_dives count]; i++) {
        Dive *dive = [_dives objectAtIndex:i];
        _totalMinutesSpentDiving += [dive.diveTime intValue];
    }
    return;
}

@end
