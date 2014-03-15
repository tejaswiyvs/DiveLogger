//
//  DiveAnnotation.m
//  DiveLogger
//
//  Created by Tejaswi Y on 11/9/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import "DiveAnnotation.h"

@implementation DiveAnnotation
@synthesize dive = _dive;

- (id)initWithDive:(Dive *)dive {
	self = [super init];
	if (self) {
		[self setDive:dive];
	}
	return self;
}

- (NSString *)title {
	return [_dive diveName];
}

- (CLLocationCoordinate2D)coordinate {
	return [_dive diveLocation];
}

@end
