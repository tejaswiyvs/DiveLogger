//
//  Tank.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/14/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Dive;
@interface Tank : NSManagedObject

@property (nonatomic, strong) NSNumber *startingPressure;
@property (nonatomic, strong) NSNumber *endingPressure;
@property (nonatomic, strong) NSString *airComposition;
@property (nonatomic, strong) NSString *airCompositionNotes;
@property (nonatomic, strong) Dive *dive;

@end
