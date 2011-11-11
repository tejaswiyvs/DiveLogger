//
//  TYAppDelegate.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TYUITabBarController.h"

@interface TYAppDelegate : UIResponder <UIApplicationDelegate>
{
    TYUITabBarController *_tabBar;
    NSMutableArray *_dives;
}

@property (nonatomic, retain) TYUITabBarController *tabBar;
@property (nonatomic, retain) NSMutableArray *dives;
@property (strong, nonatomic) UIWindow *window;

@end
