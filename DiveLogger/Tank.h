//
//  Tank.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kTYAirCompositionNitrox1,
    kTYAirCompositionNitrox2,
    kTYAirCompositionOther
} TYAirComposition;

@interface Tank : NSObject {
    NSString *airCompositionNotes; // Optional field that holds notes on air composition if a custom blend was used.
    int startingPressure;
    int endingPressure;
    TYAirComposition airComposition;
}

@property (nonatomic, retain) NSString *airCompositionNotes;
@property (nonatomic, assign) int startingPressure;
@property (nonatomic, assign) int endingPressure;
@property (nonatomic, assign) TYAirComposition airComposition;

@end
