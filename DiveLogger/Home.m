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
#import "SCAppUtils.h"
#import "TYAppDelegate.h"

@interface Home (private)
-(void) createBarButtons;
-(void) createTempDives;
-(void) sortDives;
-(void) refreshBg;
@end

@implementation Home

@synthesize divesList = _divesList, fetchedResultsController;

- (id) init {
    self = [super initWithNibName:@"Home" bundle:nil];
    [self setTitle:@"Dives"];
    [self.tabBarItem setImage:[UIImage imageNamed:@"home-icon.png"]];
    if(self) {
        // Load 
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self createBarButtons];
    [_divesList setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 10.0)]];
//    [self.view setBackgroundColor:[UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:226.0/255.0 alpha:1.0]];
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    TYAppDelegate *appDelegate = (TYAppDelegate *) [[UIApplication sharedApplication] delegate];
//    _dives = [appDelegate reloadFromDB];
//    [self sortDives];
    [self refreshBg];
//    [_divesList reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[fetchedResultsController sections] count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    Dive *dive = [fetchedResultsController objectAtIndexPath:indexPath];
    DiveDetails *diveDetails = [[DiveDetails alloc] initWithDive:dive];
    [diveDetails setDelegate:self];
    [self.navigationController pushViewController:diveDetails animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseId = @"HomeCell";
    HomeCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if(!cell) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"HomeCell" owner:self options:nil];
		for (id oneObject in nib) {
			if([oneObject isKindOfClass:[HomeCell class]])
				cell = (HomeCell *) oneObject;
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


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(editingStyle == UITableViewCellEditingStyleDelete) {
		// Delete the managed object.
		NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
		[context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
		
		NSError *error;
		if (![context save:&error]) {
			// Update to handle the error appropriately.
			NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
			exit(-1);  // Fail
		}
        [self refreshBg];
    }
}


#pragma mark - Event Handlers

-(void) addButtonClicked:(id) sender {
    DiveDetails *diveDetails = [[DiveDetails alloc] initWithDive:nil];
    [diveDetails setDelegate:self];
    [self.navigationController pushViewController:diveDetails animated:YES];
}

#pragma mark - DiveDetailsDelegate

-(void) didSaveDive:(Dive *) dive inContext:(NSManagedObjectContext *) managedObjectContext {
    DebugLog(@"A dive was edited / saved. Reloading data. %@", dive.diveName);
    NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
    [dnc addObserver:self selector:@selector(addControllerContextDidSave:) name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    [dnc removeObserver:self name:NSManagedObjectContextDidSaveNotification object:managedObjectContext];
    /*NSError *error;
    if (![managedObjectContext save:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    _dives = [appDelegate reloadFromDB];*/
//    [self sortDives];
    [_divesList reloadData];
}

-(void) didDismissWithoutSaving {
    /* TYAppDelegate *delegate = (TYAppDelegate *) [[UIApplication sharedApplication] delegate];
    [delegate.managedObjectContext reset];
    [_divesList reloadData]; */
    DebugLog(@"The Add / edit dive screen was cancelled");
}

- (void)addControllerContextDidSave:(NSNotification*)saveNotification {
	TYAppDelegate *appDelegate = (TYAppDelegate *) [[UIApplication sharedApplication] delegate];
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
    TYAppDelegate *appDelegate = (TYAppDelegate *) [[UIApplication sharedApplication] delegate];
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
	// Create and configure a fetch request with the Book entity.
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setReturnsObjectsAsFaults:NO];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Dive" inManagedObjectContext:appDelegate.managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Create the sort descriptors array.
	NSSortDescriptor *diveDateDescriptor = [[NSSortDescriptor alloc] initWithKey:@"diveDate" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:diveDateDescriptor, nil];
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
    
	switch(type) {
			
		case NSFetchedResultsChangeInsert:
			[tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeDelete:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
			
		case NSFetchedResultsChangeUpdate:
			[self configureCell:((HomeCell *) [tableView cellForRowAtIndexPath:indexPath]) atIndexPath:indexPath];
			break;
			
		case NSFetchedResultsChangeMove:
			[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	
	switch(type) {
			
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

-(void) refreshBg {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
	int count = [sectionInfo numberOfObjects];

    if(!fetchedResultsController || count == 0) {
        [_divesList setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"EmptyBG.png"]]];
    }
    else {
        [_divesList setBackgroundColor:[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0]];
    }
}

-(void) createBarButtons {
//    UIBarButtonItem *addDive = [[UIBarButtonItem alloc] initWithTitle:@"Add Dive" style:UIBarButtonItemStylePlain target:self action:@selector(addButtonClicked:)];
    UIBarButtonItem * addDive = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClicked:)];
    [[self navigationItem] setRightBarButtonItem:addDive];
}

@end
