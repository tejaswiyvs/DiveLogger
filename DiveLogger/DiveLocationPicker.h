//
//  DiveLocationPicker.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/9/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Dive.h"

@interface DiveLocationPicker : UIViewController<MKMapViewDelegate>
{
    MKMapView *_map;
    Dive *_dive;
}

@property (nonatomic, retain) IBOutlet MKMapView *map;
@property (nonatomic, retain) Dive *dive;

-(id) initWithDive:(Dive *) dive;

@end
