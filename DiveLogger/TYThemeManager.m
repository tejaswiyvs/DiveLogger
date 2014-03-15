//
//  TYThemeManager.m
//  DiveLogger
//
//  Created by Tejaswi on 3/15/14.
//
//

#import "TYThemeManager.h"
#import "UIColor+ThemeColors.h"

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
    [[UINavigationBar appearance] setBarTintColor:[UIColor themePrimaryColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor themeSecondaryColor]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{
                                                           NSForegroundColorAttributeName: [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
                                                           }];
    [[UITabBar appearance] setTintColor:[UIColor themeSecondaryColor]];
    [[UITabBar appearance] setTintColor:[UIColor themePrimaryColor]];
}

@end
