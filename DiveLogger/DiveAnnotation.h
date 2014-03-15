//
//  DiveAnnotation.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/9/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Dive.h"

@interface DiveAnnotation : NSObject <MKAnnotation> {
	Dive *_dive;
}

@property (nonatomic, strong) Dive *dive;
- (id)initWithDive:(Dive *)dive;
@end
