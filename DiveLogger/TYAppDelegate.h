//
//  TYAppDelegate.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "TYUITabBarController.h"
#import "Dive.h"

@interface TYAppDelegate : UIResponder <UIApplicationDelegate>
{
    TYUITabBarController *_tabBar;
}

@property (nonatomic, retain) TYUITabBarController *tabBar;
@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
-(void) rollbackContext;
-(void) deleteObject:(Dive *) dive;
-(NSMutableArray *) reloadFromDB;
- (NSURL *)applicationDocumentsDirectory;

@end
