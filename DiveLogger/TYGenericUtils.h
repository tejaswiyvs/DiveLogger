//
//  TYGenericUtils.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/8/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import <Foundation/Foundation.h>

// Collection of some generic utils that I keep using in all my classes. Included the #import statement in the .pch file so they get auto imported.
#define kSCNavBarImageTag 6183746
#define kSCNavBarColor [UIColor colorWithRed:0.54 green:0.18 blue:0.03 alpha:1.0]

@interface TYGenericUtils : NSObject


+(void) displayAttentionAlert:(NSString *) message;
+(void) displayErrorAlert:(NSString *) message;
+(NSString *) stringFromDate:(NSDate *) date;
+(NSDate *) dateFromString:(NSString *) dateString;
+ (void)customizeNavigationController:(UINavigationController *)navController;
@end
