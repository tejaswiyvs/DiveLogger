//
//  DiveMap.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface DiveMap : UIViewController
{
	NSMutableArray *_dives;
	MKMapView *_map;
}

@property (nonatomic, retain) NSMutableArray *dives;
@property (nonatomic, retain) IBOutlet MKMapView *map;

@end
