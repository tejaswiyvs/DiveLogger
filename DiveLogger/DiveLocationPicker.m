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
- (void)handleLongPress:(id)sender;
- (void)dropPinAtCurrentLocation;
@end

@implementation DiveLocationPicker

@synthesize map = _map;
@synthesize dive = _dive;

static float kEmptyLocation = -1000;

- (id)initWithDive:(Dive *)dive {
	self = [super initWithNibName:@"DiveLocationPicker" bundle:nil];
	if (self) {
		[self setTitle:@"Pick a location"];
		[self setDive:dive];
	}
	return self;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	// Listen to long press. Drop a pin.
	UILongPressGestureRecognizer *gestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
	[gestureRecognizer setMinimumPressDuration:1.2];
	[_map addGestureRecognizer:gestureRecognizer];
	[_map setShowsUserLocation:YES];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
    
	if ((_dive.diveLocationX == nil || _dive.diveLocationY == nil) || ([_dive.diveLocationX floatValue] == kEmptyLocation  && [_dive.diveLocationY floatValue] == kEmptyLocation)) {
		[TYGenericUtils displayAttentionAlert:@"To drop a pin, touch and hold at the location you'd like till the pin appears"];
	}
	else {
		// Dive has valid coordinates
		[self dropPinAtCurrentLocation];
	}
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

#pragma mark - Event Handlers

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer {
	// Drop a pin.
	if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
		return;
    
	CGPoint touchPoint = [gestureRecognizer locationInView:_map];
	CLLocationCoordinate2D touchMapCoordinate =
    [_map convertPoint:touchPoint toCoordinateFromView:_map];
	[_dive setDiveLocationX:[NSNumber numberWithFloat:touchMapCoordinate.latitude]];
	[_dive setDiveLocationY:[NSNumber numberWithFloat:touchMapCoordinate.longitude]];
	DiveAnnotation *annot = [[DiveAnnotation alloc] initWithDive:_dive];
	[_map removeAnnotations:[_map annotations]];
	[_map addAnnotation:annot];
}

#pragma mark - Helpers

- (void)dropPinAtCurrentLocation {
	DiveAnnotation *annotation = [[DiveAnnotation alloc] initWithDive:_dive];
	[_map removeAnnotations:[_map annotations]];
	[_map addAnnotation:annotation];
}

@end
