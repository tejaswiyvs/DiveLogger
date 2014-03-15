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

@interface Profile ()

- (void)recalculateData;

@end

@implementation Profile

- (id)init {
	self = [super initWithNibName:@"Profile" bundle:nil];
	if (self) {
        [self setTitle:@"Profile"];
        [self.tabBarItem setImage:[UIImage imageNamed:@"profile-icon.png"]];
	}
	return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];

	_appDelegate = (TYAppDelegate *)[[UIApplication sharedApplication] delegate];
	[_profileTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 10.0)]];
	[_profileTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

	TYAppDelegate *appDelegate = (TYAppDelegate *)[[UIApplication sharedApplication] delegate];
	_dives = [appDelegate reloadFromDB];
	[self recalculateData];
	[_profileTableView reloadData];
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 25.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	CGRect frame = CGRectMake(0.0, 0.0, 320.0, 25.0);
	UIView *view = [[UIView alloc] initWithFrame:frame];
	UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(3.0, 0.0, 320.0, 25.0)];
	[headerLabel setText:@"Your Profile"];
	[headerLabel setTextColor:[UIColor themePrimaryColor]];
	[headerLabel setBackgroundColor:[UIColor clearColor]];
	[view addSubview:headerLabel];
	return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 75.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseId = @"ProfileCell";
	ProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
	if (!cell) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ProfileCell" owner:self options:nil];
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:[ProfileCell class]])
				cell = (ProfileCell *)oneObject;
		}
	}
    
	cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableViewCellBG.png"]];
    
	if (indexPath.row == 0) {
		[cell.img setImage:[UIImage imageNamed:@"line-chart.png"]];
		[cell.categoryName setText:@"Total Dives"];
		NSString *totalDives = [NSString stringWithFormat:@"%d", _totalDives];
		[cell.categoryDetail setText:totalDives];
	}
	else if (indexPath.row == 1) {
		[cell.img setImage:[UIImage imageNamed:@"clock.png"]];
		[cell.categoryName setText:@"Total Minutes"];
		[cell.categoryName setShadowOffset:CGSizeMake(0.0, 1.0)];
		NSString *totalMinutes = [NSString stringWithFormat:@"%d", _totalMinutesSpentDiving];
		[cell.categoryDetail setText:totalMinutes];
	}
    [cell.categoryName setTextColor:[UIColor themePrimaryColor]];
    
	return cell;
}

#pragma mark - Helpers

- (void)recalculateData {
	_totalDives = [_dives count];
	_totalMinutesSpentDiving = 0;
	for (int i = 0; i < [_dives count]; i++) {
		Dive *dive = _dives[i];
		_totalMinutesSpentDiving += [dive.diveTime intValue];
	}
	return;
}

@end
