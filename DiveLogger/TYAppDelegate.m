//
//  TYAppDelegate.m
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import "TYAppDelegate.h"
#import "Home.h"
#import "DiveMap.h"
#import "SCAppUtils.h"
#import "Profile.h"
#import "Settings.h"

@interface TYAppDelegate (private)
-(TYUITabBarController *) createTabBar;
@end

@implementation TYAppDelegate

@synthesize window = _window;
@synthesize tabBar = _tabBar;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize facebook = _facebook;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tabBar = [self createTabBar];
    [self.window addSubview:self.tabBar.view];
    [self.window makeKeyAndVisible];
    
    // Setup Facebook
    _facebook = [[Facebook alloc] initWithAppId:@"250994151631017" andDelegate:self];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"FBAccessTokenKey"] 
            && [defaults objectForKey:@"FBExpirationDateKey"]) {
        _facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        _facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{

}

- (void)applicationDidEnterBackground:(UIApplication *)application
{

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{

}

#pragma mark - Helpers

-(TYUITabBarController *) createTabBar {
    Home *home = [[Home alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:home];
    [navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [SCAppUtils customizeNavigationController:navigationController];
    DiveMap *map = [[DiveMap alloc] init];
    Profile *profile = [[Profile alloc] init];
//    Settings *settings = [[Settings alloc] init];
    NSArray *viewControllers = [NSArray arrayWithObjects:navigationController, map, profile, nil];
    TYUITabBarController *tabBar = [[TYUITabBarController alloc] init];
    // UITabBarController *tabBar = [[UITabBarController alloc] init];
    [tabBar setViewControllers:viewControllers];
    return tabBar;
}

#pragma mark - Core Data

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

-(void) rollbackContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    [managedObjectContext rollback];
}

-(void) deleteObject:(Dive *) dive {
    NSManagedObjectContext *context = [self managedObjectContext];
    [context deleteObject:dive];
    NSError *err = nil;
    if(![context save:&err]) {
        DebugLog(@"Couldn't save context after deleting: %@", [err userInfo]);
    }
}

#pragma mark - Core Data stack

- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
        NSUndoManager *undoManager = [[NSUndoManager alloc] init];
        [__managedObjectContext setUndoManager:undoManager];
    }
    return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"DiveLogger" withExtension:@"momd"];
    if (!path) {
        path = [[NSBundle mainBundle] URLForResource:@"DiveLogger" withExtension:@"mom"];
    }
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:path];
    return __managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DiveLogger.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

-(NSMutableArray *) reloadFromDB {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *dive = [NSEntityDescription entityForName:@"Dive" 
                                            inManagedObjectContext:context];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:dive];
    
    NSError *error;
    NSArray *fetchResults = [context executeFetchRequest:fetchRequest error:&error];
    if(!fetchResults) {
        NSLog(@"%@", error);
    }
    NSMutableArray *mutableFetchResults = [NSMutableArray arrayWithArray:fetchResults];
    return mutableFetchResults;
}

#pragma mark - Application's Documents directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Facebook Delegate

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [_facebook handleOpenURL:url]; 
}

// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [_facebook handleOpenURL:url]; 
}

- (void)fbDidLogin {
    [TYGenericUtils displayAttentionAlert:@"Succesfully connected to Facebook!"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[_facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[_facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize]; 
}

-(void)fbDidNotLogin:(BOOL)cancelled {
    [TYGenericUtils displayAttentionAlert:@"Could not add your Facebook account. Please try again later"];
}
@end
