//
//  Home.m
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Home.h"
#import "DiveDetails.h"

@interface Home (private)
-(void) createBarButtons;
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dives count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - Event Handlers

-(void) addButtonClicked:(id) sender {
    DiveDetails *diveDetails = [[DiveDetails alloc] initWithDive:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:diveDetails];
    [self presentModalViewController:navigationController animated:YES];
}

#pragma mark - DiveDetailsDelegate

-(void) didSaveDive:(Dive *) dive {
    
}

-(void) didUpdateDive:(Dive *) dive {

}

-(void) didDismissWithoutSaving {

}
#pragma mark - Helpers

-(void) createBarButtons {
    UIBarButtonItem *addDive = [[UIBarButtonItem alloc] initWithTitle:@"Add Dive" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonClicked:)];
    [[self navigationItem] setRightBarButtonItem:addDive];
}

@end
