//
//  TYGenericUtils.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

// Collection of some generic utils that I keep using in all my classes. Included the #import statement in the .pch file so they get auto imported.

@interface TYGenericUtils : NSObject

+(void) displayAttentionAlert:(NSString *) message;
+(void) displayErrorAlert:(NSString *) message;
+(NSString *) stringFromDate:(NSDate *) date;
+(NSDate *) dateFromString:(NSString *) dateString;
@end
