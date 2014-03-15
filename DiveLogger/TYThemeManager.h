//
//  TYThemeManager.h
//  DiveLogger
//
//  Created by Tejaswi on 3/15/14.
//
//

#import <Foundation/Foundation.h>

@interface TYThemeManager : NSObject

+ (TYThemeManager *)sharedInstance;
- (void)applyTheme;

@end
