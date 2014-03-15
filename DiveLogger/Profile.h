//
//  Profile.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/10/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYAppDelegate.h"

@interface Profile : UIViewController {
	NSMutableArray *_dives;
	UITableView *_profileTableView;
	__unsafe_unretained TYAppDelegate *_appDelegate;
	int _totalDives;
	int _totalMinutesSpentDiving;
}

@property (nonatomic, strong) NSMutableArray *dives;
@property (nonatomic, strong) IBOutlet UITableView *profileTableView;
@property (nonatomic, assign) TYAppDelegate *appDelegate;
@property (nonatomic, assign) int totalDives;
@property (nonatomic, assign) int totalMinutesSpentDiving;

@end
