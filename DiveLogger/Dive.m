//
//  Dive.m
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Dive.h"

@implementation Dive
@synthesize diveName, diveDate, diveLocation, tank, visibility, airTemperature, waterTemperature, diveTime;
-(id) init {
    self = [super init];
    if(self) {
        [self setDiveLocation:EmptyLocationCoordinate];
        self.tank = [[Tank alloc] init];
    }
    return self;
}
@end