//
//  TYAppDelegate.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface TYAppDelegate : UIResponder <UIApplicationDelegate>
{
    UITabBarController *_tabBar;
}

@property (nonatomic, retain) UITabBarController *tabBar;
@property (strong, nonatomic) UIWindow *window;

@end
