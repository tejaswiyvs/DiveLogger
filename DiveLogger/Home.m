//
//  Home.m
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import "Home.h"
#import "DiveDetails.h"
#import "HomeCell.h"
#import "TYAppDelegate.h"

@interface Home (private)

- (void)createBarButtons;
- (void)createTempDives;
- (void)sortDives;
- (void)refreshBg;

@end

@implementation Home

@synthesize divesList = _divesList, fetchedResultsController, emptyLabel = _emptyLabel;

- (id)init {
	self = [super initWithNibName:@"Home" bundle:nil];
	[self setTitle:@"Dives"];
	[self.tabBarItem setImage:[UIImage imageNamed:@"home-icon.png"]];
	if (self) {
		// Load
	}
	return self;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
    
	[self createBarButtons];
	[_divesList setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 10.0)]];
    
	// Empty label text if the table is empty.
	_emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 50.0, 320.0, 100.0)];
	[_emptyLabel setHidden:YES];
	[_emptyLabel setBackgroundColor:[UIColor clearColor]];
	[_emptyLabel setNumberOfLines:0];
	[_emptyLabel setTextAlignment:NSTextAlignmentCenter];
	[_emptyLabel setShadowColor:[UIColor whiteColor]];
	[_emptyLabel setShadowOffset:CGSizeMake(0.0, -1.0)];
	[_emptyLabel setText:@"Hit the '+' button on the top right to get started."];
	[[self view] addSubview:_emptyLabel];
    
	// Fetch
	NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		[TYGenericUtils displayErrorAlert:@"Oh no! Something went horribly wrong. Please kill & restart the application"];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	// [self refreshBg];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 90.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [[fetchedResultsController sections] count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [fetchedResultsController sections][section];
	return [sectionInfo numberOfObjects];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	Dive *dive = [fetchedResultsController objectAtIndexPath:indexPath];
	DiveDetails *diveDetails = [[DiveDetails alloc] initWithDive:dive];
	[diveDetails setDelegate:self];
	[self.navigationController pushViewController:diveDetails animated:YES];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSString *reuseId = @"HomeCell";
	HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
	if (!cell) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil];
		for (id oneObject in nib) {
			if ([oneObject isKindOfClass:[HomeCell class]])
				cell = (HomeCell *)oneObject;
		}
	}
	[self configureCell:cell atIndexPath:indexPath];
	return cell;
}

- (void)configureCell:(HomeCell *)cell atIndexPath:(NSIndexPath *)indexPath {
	cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableViewCellBG.png"]];
	Dive *dive = [fetchedResultsController objectAtIndexPath:indexPath];
	[cell.diveName setText:dive.diveName];
	[cell.diveDate setText:[TYGenericUtils stringFromDate:dive.diveDate]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the managed object.
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
        
		NSError *error;
		if (![context save:&error]) {
			[TYGenericUtils displayAttentionAlert:@"Couldn't save dive. Please restart the app."];
		}
		[self refreshBg];
	}
}

#pragma mark - Event Handlers

- (void)addButtonClicked:(id)sender {
	DiveDetails *diveDetails = [[DiveDetails alloc] initWithDive:nil];
	[diveDetails setDelegate:self];
	[self.navigationController pushViewController:diveDetails animated:YES];
}

#pragma mark - DiveDetailsDelegate

- (void)didSaveDive:(Dive *)dive inContext:(NSManagedObjectContext *)managedObjectContext {
	DDLogInfo(@"A dive was edited / saved. Reloading data. %@", dive.diveName);
	NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
	[dnc addObserver:self selector:@selector(addControllerContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
    
	NSError *error;
	if (![managedObjectContext save:&error]) {
		// Update to handle the error appropriately.
		[TYGenericUtils displayAttentionAlert:@"Couldn't save dive. Please restart the app."];
	}
	[dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
	[_divesList reloadData];
}

- (void)didDismissWithoutSaving {
	DDLogInfo(@"The Add / edit dive screen was cancelled");
}

- (void)addControllerContextDidSave:(NSNotification *)saveNotification {
	TYAppDelegate *appDelegate = (TYAppDelegate *)[[UIApplication sharedApplication] delegate];
	NSManagedObjectContext *context = [appDelegate managedObjectContext];
	// Merging changes causes the fetched results controller to update its results
	[context mergeChangesFromContextDidSaveNotification:saveNotification];
}

#pragma mark -
#pragma mark Fetched results controller

/**
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController {
	TYAppDelegate *appDelegate = (TYAppDelegate *)[[UIApplication sharedApplication] delegate];
	if (fetchedResultsController != nil) {
		return fetchedResultsController;
	}
    
	// Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setReturnsObjectsAsFaults:NO];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Dive" inManagedObjectContext:appDelegate.managedObjectContext];
	[fetchRequest setEntity:entity];
    
	// Create the sort descriptors array.
	NSSortDescriptor *diveDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"diveDate" ascending:NO];
	NSArray *sortDescriptors = @[diveDateDescriptor];
	[fetchRequest setSortDescriptors:sortDescriptors];
    
	// Create and initialize the fetch results controller.
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:appDelegate.managedObjectContext sectionNameKeyPath:nil cacheName:@"DiveListCache"];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
	return fetchedResultsController;
}

/**
 Delegate methods of NSFetchedResultsController to respond to additions, removals and so on.
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller is about to start sending change notifications, so prepare the table view for updates.
	[_divesList beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	UITableView *tableView = _divesList;
    
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
            
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
            
		case NSFetchedResultsChangeUpdate:
			[self configureCell:((HomeCell *)[tableView cellForRowAtIndexPath:indexPath]) atIndexPath:indexPath];
			break;
            
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo> )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	switch (type) {
		case NSFetchedResultsChangeInsert:
			[_divesList insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
            
		case NSFetchedResultsChangeDelete:
			[_divesList deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	// The fetch controller has sent all current change notifications, so tell the table view to process all updates.
	[_divesList endUpdates];
}

#pragma mark - Helpers

- (void)refreshBg {
	id <NSFetchedResultsSectionInfo> sectionInfo = [fetchedResultsController sections][0];
	int count = [sectionInfo numberOfObjects];
    
	if (!fetchedResultsController || count == 0) {
		[_divesList setHidden:YES];
	}
	else {
		[_emptyLabel setHidden:YES];
		[_divesList setHidden:NO];
	}
}

- (void)createBarButtons {
	UIBarButtonItem *addDive = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClicked:)];
	[[self navigationItem] setRightBarButtonItem:addDive];
}

@end
