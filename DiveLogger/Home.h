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

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) IBOutlet UITableView *divesList;
@property (nonatomic, strong) UILabel *emptyLabel;

- (id)init;
- (void)configureCell:(HomeCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
