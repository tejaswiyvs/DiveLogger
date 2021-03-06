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
- (void)populateTempData;
- (void)dropPins;
@end

@implementation DiveMap

- (id)init {
	self = [super initWithNibName:@"DiveMap" bundle:nil];
	if (self) {
		[self setTitle:@"Map"];
		[self.tabBarItem setImage:[UIImage imageNamed:@"map-marker.png"]];
	}
	return self;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	TYAppDelegate *appDelegate = (TYAppDelegate *)[[UIApplication sharedApplication] delegate];
	_dives = [appDelegate reloadFromDB];
	[self dropPins];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

#pragma mark - Helpers

- (void)dropPins {
	for (int i = 0; i < [_dives count]; i++) {
		DiveAnnotation *annotation = [[DiveAnnotation alloc] initWithDive:_dives[i]];
		[_map addAnnotation:annotation];
	}
}

@end
