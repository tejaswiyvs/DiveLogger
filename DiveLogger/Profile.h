//
//  Profile.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/10/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYAppDelegate.h"

@interface Profile : UIViewController

@property (nonatomic, strong) NSMutableArray *dives;
@property (nonatomic, strong) IBOutlet UITableView *profileTableView;
@property (nonatomic, assign) TYAppDelegate *appDelegate;
@property (nonatomic, assign) NSUInteger totalDives;
@property (nonatomic, assign) NSUInteger totalMinutesSpentDiving;

@end
