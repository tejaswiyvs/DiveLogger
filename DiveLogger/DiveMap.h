//
//  DiveMap.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface DiveMap : UIViewController

@property (nonatomic, strong) NSMutableArray *dives;
@property (nonatomic, strong) IBOutlet MKMapView *map;

@end
