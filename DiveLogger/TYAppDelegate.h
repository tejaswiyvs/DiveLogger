//
//  TYAppDelegate.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Dive.h"

@interface TYAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, retain) UITabBarController *tabBar;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (void)rollbackContext;
- (void)deleteObject:(Dive *)dive;
- (NSMutableArray *)reloadFromDB;
- (NSURL *)applicationDocumentsDirectory;

@end
