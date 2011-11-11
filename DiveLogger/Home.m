//
//  Home.m
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Home.h"
#import "DiveDetails.h"
#import "HomeCell.h"
#import "SCAppUtils.h"
#import "TYAppDelegate.h"

@interface Home (private)
-(void) createBarButtons;
-(void) createTempDives;
@end

@implementation Home

@synthesize dives = _dives, divesList = _divesList;

- (id) init {
    self = [super initWithNibName:@"Home" bundle:nil];
    [self setTitle:@"Dives"];
    [self.tabBarItem setImage:[UIImage imageNamed:@"shoebox.png"]];
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
    [self createBarButtons];
    [self createTempDives];
    [_divesList setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 10.0)]];
    [_divesList setBackgroundColor:[UIColor whiteColor]];
    TYAppDelegate *appDelegate = (TYAppDelegate *) [[UIApplication sharedApplication] delegate];
    if(!appDelegate.dives) {
        appDelegate.dives = [[NSMutableArray alloc] init];
    }
    _dives = appDelegate.dives;
    [_divesList reloadData];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_divesList reloadData];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dives count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Dive *dive = [_dives objectAtIndex:indexPath.row];
    DiveDetails *diveDetails = [[DiveDetails alloc] initWithDive:dive];
    [diveDetails setDelegate:self];
    [self.navigationController pushViewController:diveDetails animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseId = @"HomeCell";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if(!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil];
		for (id oneObject in nib) {
			if([oneObject isKindOfClass:[HomeCell class]])
				cell = (HomeCell *) oneObject;
		}
    }
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableViewCellBG.png"]];
    Dive *dive = [_dives objectAtIndex:indexPath.row];
    [cell.diveName setText:dive.diveName];
    [cell.diveDate setText:[TYGenericUtils stringFromDate:dive.diveDate]];
    return cell;
}

#pragma mark - Event Handlers

-(void) addButtonClicked:(id) sender {
    DiveDetails *diveDetails = [[DiveDetails alloc] initWithDive:nil];
    [diveDetails setDelegate:self];
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:diveDetails];
//    [SCAppUtils customizeNavigationController:navigationController];
    [self.navigationController pushViewController:diveDetails animated:YES];
//    [self presentModalViewController:navigationController animated:YES];
}

#pragma mark - DiveDetailsDelegate

-(void) didSaveDive:(Dive *) dive {
    for(int i=0; i<[_dives count]; i++) {
        Dive *temp = [_dives objectAtIndex:i];
        if([temp.diveName isEqualToString:dive.diveName]) {
            [_dives replaceObjectAtIndex:i withObject:dive];
            return;
        }
    }
    
    [_dives addObject:dive];
}

-(void) didDismissWithoutSaving {

}
#pragma mark - Helpers

-(void) createBarButtons {
//    UIBarButtonItem *addDive = [[UIBarButtonItem alloc] initWithTitle:@"Add Dive" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonClicked:)];
    UIBarButtonItem * addDive = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClicked:)];
    [[self navigationItem] setRightBarButtonItem:addDive];
}

-(void) createTempDives {
    Dive *dive1 = [[Dive alloc] init];
    dive1.diveName = @"Test Dive 1";
    dive1.diveDate = [[NSDate alloc] init];
    dive1.tank.startingPressure = 3000;
    dive1.tank.endingPressure = 1000;
    dive1.visibility = 200;
    dive1.airTemperature = 85;
    dive1.waterTemperature = 83;
    dive1.diveTime = 30;
    [_dives addObject:dive1];
    
    Dive *dive2 = [[Dive alloc] init];
    dive2.diveName = @"Test Dive 2";
    dive2.diveDate = [[NSDate alloc] init];
    dive2.tank.startingPressure = 2500;
    dive2.tank.endingPressure = 750;
    dive2.visibility = 80;
    dive2.airTemperature = 72;
    dive2.waterTemperature = 67;
    dive2.diveTime = 30;
    [_dives addObject:dive2];
}

@end
