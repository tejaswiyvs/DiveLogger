//
//  DiveMap.m
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DiveMap.h"

@implementation DiveMap

-(id) init {
    self = [super initWithNibName:@"DiveMap" bundle:nil];
    if(self) {
        [self setTitle:@"Map"];
        [self.tabBarItem setImage:[UIImage imageNamed:@"map-marker.png"]];
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
}

- (void) viewDidAppear:(BOOL)animated {
    UIAlertView *comingSoon = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Coming Soon!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [comingSoon show];
    [super viewDidAppear:animated];
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

@end
