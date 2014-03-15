//
//  TYThemeManager.m
//  DiveLogger
//
//  Created by Tejaswi on 3/15/14.
//
//

#import "TYThemeManager.h"

@implementation TYThemeManager

+ (TYThemeManager *)sharedInstance {
    static dispatch_once_t onceToken;
    static TYThemeManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[TYThemeManager alloc] init];
    });
    return instance;
}

- (void)applyTheme {
    [[UINavigationBar appearance] setBackgroundColor:[UIColor blueColor]];
}

@end
