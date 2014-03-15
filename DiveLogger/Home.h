//
//  Home.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//
#import "DiveDetails.h"
#import "HomeCell.h"

@interface Home : UIViewController <NSFetchedResultsControllerDelegate, TYDiveDetailsDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) IBOutlet UITableView *divesList;
@property (nonatomic, retain) UILabel *emptyLabel;

- (id)init;
- (void)configureCell:(HomeCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
