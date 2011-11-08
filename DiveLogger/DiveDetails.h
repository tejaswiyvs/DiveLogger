//
//  DiveDetails.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Dive.h"

@interface DiveDetails : PPKUIViewController {
    Dive *_dive
}

@property (nonatomic, retain) Dive *dive;

-(id) initWithDive:(Dive *) dive;

@end
