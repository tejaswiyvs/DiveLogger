//
//  Home.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//
#import "DiveDetails.h"

@interface Home : UIViewController<UITableViewDelegate, UITableViewDataSource, TYDiveDetailsDelegate>
{
    NSMutableArray *_dives; // Holds a list of all the dives.
    UITableView *_divesList;
}

@property (nonatomic, retain) NSMutableArray *dives;
@property (nonatomic, retain) IBOutlet UITableView *divesList;

- (id) init;

@end
