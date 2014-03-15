//
//  Dive.m
//  DiveLogger
//
//  Created by Tejaswi Y on 11/14/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import "Dive.h"
#import "Tank.h"


@implementation Dive

@dynamic diveName;
@dynamic diveDate;
@dynamic diveLocationX;
@dynamic diveLocationY;
@dynamic visibility;
@dynamic airTemperature;
@dynamic waterTemperature;
@dynamic diveTime;
@dynamic tank;

- (CLLocationCoordinate2D)diveLocation {
	CLLocationDegrees latitude = [self.diveLocationX floatValue];
	CLLocationDegrees longitude = [self.diveLocationY floatValue];
	return CLLocationCoordinate2DMake(latitude, longitude);
}

@end
