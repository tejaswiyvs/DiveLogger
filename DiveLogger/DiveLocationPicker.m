//
//  DiveLocationPicker.m
//  DiveLogger
//
//  Created by Tejaswi Y on 11/9/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import "DiveLocationPicker.h"
#import "DiveAnnotation.h"

@interface DiveLocationPicker (private)
-(void) handleLongPress:(id) sender;
-(void) dropPinAtCurrentLocation;
@end

@implementation DiveLocationPicker

@synthesize map = _map;
@synthesize dive = _dive;

-(id) initWithDive:(Dive *) dive
{
    self = [super initWithNibName:@"DiveLocationPicker" bundle:nil];
    if(self) {
        [self setTitle:@"Pick a location"];
        [self setDive:dive];
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
    // Listen to long press. Drop a pin.
    UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [gestureRecognizer setMinimumPressDuration:2];
    [_map addGestureRecognizer:gestureRecognizer];
    [_map setShowsUserLocation:YES];
    
    if(!(_dive.diveLocation.latitude == EmptyLocationCoordinate.latitude && _dive.diveLocation.latitude == EmptyLocationCoordinate.latitude)) {
        // Dive has valid coordinates
        [self dropPinAtCurrentLocation];
    }
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

#pragma mark - Event Handlers

-(void) handleLongPress:(UIGestureRecognizer *) gestureRecognizer {
    // Drop a pin.
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:_map];   
    CLLocationCoordinate2D touchMapCoordinate = 
    [_map convertPoint:touchPoint toCoordinateFromView:_map];
    [_dive setDiveLocation:touchMapCoordinate];
    DiveAnnotation *annot = [[DiveAnnotation alloc] initWithDive:_dive];
    [_map removeAnnotations:[_map annotations]];
    [_map addAnnotation:annot];
}

#pragma mark - Helpers

-(void) dropPinAtCurrentLocation {
    DiveAnnotation *annotation = [[DiveAnnotation alloc] initWithDive:_dive];
    [_map removeAnnotations:[_map annotations]];
    [_map addAnnotation:annotation];
}

@end
