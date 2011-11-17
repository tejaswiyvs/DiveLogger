//
//  Dive.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tank;

@interface Dive : NSManagedObject

@property (nonatomic, retain) NSString * diveName;
@property (nonatomic, retain) NSDate * diveDate;
@property (nonatomic, retain) NSNumber * diveLocationX;
@property (nonatomic, retain) NSNumber * diveLocationY;
@property (nonatomic, retain) NSNumber * visibility;
@property (nonatomic, retain) NSNumber * airTemperature;
@property (nonatomic, retain) NSNumber * waterTemperature;
@property (nonatomic, retain) NSNumber * diveTime;
@property (nonatomic, retain) Tank *tank;

-(CLLocationCoordinate2D) diveLocation;

@end
