//
//  DiveMap.m
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import "DiveMap.h"
#import "Dive.h"
#import "DiveAnnotation.h"
#import "TYAppDelegate.h"

@interface DiveMap (private) 
-(void) populateTempData;
-(void) dropPins;
@end

@implementation DiveMap

@synthesize dives = _dives;
@synthesize map = _map;

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
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidAppear:(BOOL)animated {
    // [TYGenericUtils displayAttentionAlert:@"Coming Soon!"];
    TYAppDelegate *appDelegate = (TYAppDelegate *) [[UIApplication sharedApplication] delegate];
    _dives = [appDelegate reloadFromDB];
    [self dropPins];
    [super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Helpers

-(void) dropPins
{
    for (int i=0; i<[_dives count]; i++) {
        DiveAnnotation *annotation = [[DiveAnnotation alloc] initWithDive:[_dives objectAtIndex:i]];
        [_map addAnnotation:annotation];
        [_map setShowsUserLocation:YES];
    }
}

-(void) populateTempData {
    /* _dives = [[NSMutableArray alloc] init];
    Dive *dive1 = [[Dive alloc] init];
    [dive1 setDiveName:@"Some dive"];
    CLLocationCoordinate2D coordinates = CLLocationCoordinate2DMake(27.882177,-81.118927);
    [dive1 setDiveLocation:coordinates];
    [_dives addObject:dive1];
        
    Dive *dive2 = [[Dive alloc] init];
    [dive2 setDiveName:@"Some other dive"];
    CLLocationCoordinate2D coordinate2 = CLLocationCoordinate2DMake(29.88, -81.11);
    [dive2 setDiveLocation:coordinate2];
    [_dives addObject:dive2]; */
}

@end
