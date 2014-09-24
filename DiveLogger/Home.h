//
//  Home.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//
#import "HomeCell.h"
#import <CoreData/CoreData.h>

@interface Home : UIViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) IBOutlet UITableView *divesList;
@property (nonatomic, strong) UILabel *emptyLabel;

- (id)init;
- (void)configureCell:(HomeCell *)cell atIndexPath:(NSIndexPath *)indexPath;

@end
