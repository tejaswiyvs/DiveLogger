//
//  Dive.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/14/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tank;
@interface Dive : NSManagedObject

@property (nonatomic, strong) NSString *diveName;
@property (nonatomic, strong) NSDate *diveDate;
@property (nonatomic, strong) NSNumber *diveLocationX;
@property (nonatomic, strong) NSNumber *diveLocationY;
@property (nonatomic, strong) NSNumber *visibility;
@property (nonatomic, strong) NSNumber *airTemperature;
@property (nonatomic, strong) NSNumber *waterTemperature;
@property (nonatomic, strong) NSNumber *diveTime;
@property (nonatomic, strong) Tank *tank;

- (CLLocationCoordinate2D)diveLocation;

@end
