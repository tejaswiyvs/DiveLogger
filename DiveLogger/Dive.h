//
//  Dive.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Tank.h"

@interface Dive : NSObject
{
    NSString *diveName;
    NSDate *diveDate;
    CLLocationCoordinate2D diveLocation;
    Tank *tank;
    int visibility;
    int airTemperature;
    int waterTemperature;
    int diveTime;
}

@property (nonatomic, retain) NSString *diveName;
@property (nonatomic, retain) NSDate *diveDate;
@property (nonatomic, assign) CLLocationCoordinate2D diveLocation;
@property (nonatomic, retain) Tank *tank;
@property (nonatomic, assign) int visibility;
@property (nonatomic, assign) int airTemperature;
@property (nonatomic, assign) int waterTemperature;
@property (nonatomic, assign) int diveTime;

@end
