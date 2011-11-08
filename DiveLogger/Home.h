//
//  Home.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@interface Home : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *dives; // Holds a list of all the dives.
    UITableView *divesList;
}

@property (nonatomic, retain) NSMutableArray *dives;
@property (nonatomic, retain) UITableView *divesList;

- (id) init;

@end
