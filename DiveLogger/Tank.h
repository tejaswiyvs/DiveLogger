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

@property (nonatomic, retain) NSNumber * startingPressure;
@property (nonatomic, retain) NSNumber * endingPressure;
@property (nonatomic, retain) NSString * airComposition;
@property (nonatomic, retain) NSString * airCompositionNotes;
@property (nonatomic, retain) Dive *dive;

@end
