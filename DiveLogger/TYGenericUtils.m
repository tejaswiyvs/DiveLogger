//
//  TYGenericUtils.m
//  DiveLogger
//
//  Created by Tejaswi Y on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TYGenericUtils.h"

@implementation TYGenericUtils

+(void) displayAttentionAlert:(NSString *) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

+(void) displayErrorAlert:(NSString *) message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

+(NSString *) stringFromDate:(NSDate *) date {
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM/dd/YYYY"];
    return [dateFormatter stringFromDate:date];
}

+(NSDate *) dateFromString:(NSString *) dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"MM/dd/YYYY"];
    return [dateFormatter dateFromString:dateString];
}
@end