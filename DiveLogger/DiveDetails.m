//
//  DiveDetails.m
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import "DiveDetails.h"
#import "DiveLocationPicker.h"
#import "TYAppDelegate.h"
#import "Tank.h"

@implementation DiveDetails

static int kNumberOfSections = 3;
static float kEmptyLocation = -1000;

- (id)initWithDive:(Dive *)dive {
	self = [super initWithNibName:@"DiveDetails" bundle:nil];
	if (self) {
		if (!dive) {
			[self setTitle:@"Add a dive"];
			_newDive = YES;
            
			TYAppDelegate *appDelegate = (TYAppDelegate *)[[UIApplication sharedApplication] delegate];
			// Creating a new managed object context with the same persistent store coordinator.
			// This context is used as a scratchpad for all the changes and the context itself
			// is discarded if user clicks cancel. If the user clicks save however, the changes
			// are saved to the same persistent store and in the delegate methods of the home screen,
			// we just reload the data from the disk.
			_diveDetailsContext = [[NSManagedObjectContext alloc] init];
			_diveDetailsContext.persistentStoreCoordinator = appDelegate.managedObjectContext.persistentStoreCoordinator;
			NSEntityDescription *diveEntity = [NSEntityDescription entityForName:@"Dive" inManagedObjectContext:_diveDetailsContext];
			NSEntityDescription *tankEntity = [NSEntityDescription entityForName:@"Tank" inManagedObjectContext:_diveDetailsContext];
			dive = (Dive *)[[NSManagedObject alloc] initWithEntity:diveEntity insertIntoManagedObjectContext:_diveDetailsContext];
			Tank *tank = (Tank *)[[NSManagedObject alloc] initWithEntity:tankEntity insertIntoManagedObjectContext:_diveDetailsContext];
			tank.airComposition = @"";
			tank.airCompositionNotes = @"";
			tank.dive = dive;
			tank.startingPressure = nil;
			tank.endingPressure = nil;
			dive.tank = tank;
			dive.diveDate = [[NSDate alloc] init];
			dive.diveName = @"";
			dive.diveLocationX = @(kEmptyLocation);
			dive.diveLocationY = @(kEmptyLocation);
			dive.diveTime = @0;
			dive.visibility = nil;
			dive.airTemperature = nil;
			dive.waterTemperature = nil;
			dive.diveTime = nil;
		}
		else {
			_newDive = NO;
			[self setTitle:@"Dive Details"];
		}
		[self setDive:dive];
	}
	return self;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
	[self createNavBarButtons];
	[self createPostToFBButton];
	_appDelegate = (TYAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	[self.tableView reloadData];
}

- (void)viewDidUnload {
	[super viewDidUnload];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return kNumberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return 4;
	}
	else if (section == 1) {
		return 3;
	}
	else if (section == 2) {
		return 3;
	}
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 30.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return @"Dive Info";
	}
	else if (section == 1) {
		return @"Tank Info";
	}
	else if (section == 2) {
		return @"Conditions";
	}
	return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Dive Name
	if (indexPath.section == 0 && indexPath.row == 0) {
		UITableViewCell *cell = [self makeNewCell];
		[[cell textLabel] setText:@"Dive Name"];
		_diveNameTxt = [self makeTxtField];
		_diveNameTxt.placeholder = @"Dive Name";
		_diveNameTxt.keyboardType = UIKeyboardTypeNamePhonePad;
		_diveNameTxt.autocapitalizationType = UITextAutocapitalizationTypeWords;
		[cell addSubview:_diveNameTxt];
		if ([_dive diveName] && ![[_dive diveName] isEqualToString:@""]) {
			[_diveNameTxt setText:[_dive diveName]];
		}
		if (!_newDive) {
			[_diveNameTxt setEnabled:NO];
		}
		return cell;
	}
	// Dive Date
	else if (indexPath.section == 0 && indexPath.row == 1) {
		UITableViewCell *cell = [self makeNewCell];
		[[cell textLabel] setText:@"Dive Date"];
		_diveDateTxt = [self makeTxtField];
		_diveDateTxt.placeholder = @"Dive Date";
		_diveDateTxt.keyboardType = UIKeyboardTypeNamePhonePad;
		[cell addSubview:_diveDateTxt];
		[cell.textLabel setBackgroundColor:[UIColor clearColor]];
		if (![_dive diveDate]) {
			_dive.diveDate = [[NSDate alloc] init];
		}
		[_diveDateTxt setText:[TYGenericUtils stringFromDate:_dive.diveDate]];
		[_diveDateTxt setEnabled:NO];
		return cell;
	}
	// Dive Location
	else if (indexPath.section == 0 && indexPath.row == 2) {
		UITableViewCell *cell = [self makeNewCell];
		[[cell textLabel] setText:@"Dive Location"];
		// Dive Location does not exist or is Equal to Empty Location
		if ((_dive.diveLocationX == nil || _dive.diveLocationY == nil) || ([_dive.diveLocationX floatValue] == kEmptyLocation  && [_dive.diveLocationY floatValue] == kEmptyLocation)) {
			[[cell detailTextLabel] setText:@"Pick a Location"];
		}
		else {
			NSString *locationString = [NSString stringWithFormat:@"%.2f, %.2f", _dive.diveLocation.latitude, _dive.diveLocation.longitude];
			[[cell detailTextLabel] setText:locationString];
		}
		return cell;
	}
	else if (indexPath.section == 0 && indexPath.row == 3) {
		return [self makeDiveTimeCell];
	}
	else if (indexPath.section == 1 && indexPath.row == 0) {
		UITableViewCell *cell = [self makeNewCell];
		[[cell textLabel] setText:@"Starting Pressure"];
		_tankStartingPressureTxt = [self makeTxtField];
		_tankStartingPressureTxt.placeholder = @"Starting Pressure";
		_tankStartingPressureTxt.keyboardType = UIKeyboardTypeNumberPad;
		[cell addSubview:_tankStartingPressureTxt];
		if ([_dive.tank startingPressure]) {
			NSString *startingPressure = [NSString stringWithFormat:@"%.2f psi", [_dive.tank.startingPressure floatValue]];
			[_tankStartingPressureTxt setText:startingPressure];
		}
		return cell;
	}
	else if (indexPath.section == 1 && indexPath.row == 1) {
		UITableViewCell *cell = [self makeNewCell];
		[cell.textLabel setText:@"Ending Pressure"];
		_tankEndingPressureTxt = [self makeTxtField];
		_tankEndingPressureTxt.placeholder = @"Ending Pressure";
		_tankEndingPressureTxt.keyboardType = UIKeyboardTypeNumberPad;
		[cell addSubview:_tankEndingPressureTxt];
		if ([[_dive tank] endingPressure]) {
			NSString *endingPressure = [NSString stringWithFormat:@"%.2f psi", [_dive.tank.endingPressure floatValue]];
			[_tankEndingPressureTxt setText:endingPressure];
		}
		return cell;
	}
	else if (indexPath.section == 1 && indexPath.row == 2) {
		UITableViewCell *cell = [self makeNewCell];
		[[cell textLabel] setText:@"Air Composition"];
		_tankAirCompositionTxt = [self makeTxtField];
		_tankAirCompositionTxt.keyboardType = UIKeyboardTypeNamePhonePad;
		[_tankAirCompositionTxt setPlaceholder:@"Nitrox? Trimix? O2?"];
		[cell addSubview:_tankAirCompositionTxt];
		if ([_dive.tank airComposition]) {
			[_tankAirCompositionTxt setText:_dive.tank.airComposition];
		}
		return cell;
	}
	else if (indexPath.section == 2 && indexPath.row == 0) {
		return [self makeVisibilityCell];
	}
	else if (indexPath.section == 2 && indexPath.row == 1) {
		return [self makeAirTemperatureCell];
	}
	else if (indexPath.section == 2 && indexPath.row == 2) {
		return [self makeWaterTemperatureCell];
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// Location Picker
	if (indexPath.section == 0 && indexPath.row == 2) {
		DiveLocationPicker *locationPicker = [[DiveLocationPicker alloc] initWithDive:_dive];
		[[self navigationController] pushViewController:locationPicker animated:YES];
		[self animateDatePickerOut];
	}
	// Dive Date
	else if (indexPath.section == 0 && indexPath.row == 1) {
		// If the keyboard is being shown, remove it.
		[self resignFirstResponderForSubviewsOfView:self.view];
        
		// If the date picker hasn't been added already, animate it in.
		if (self.datePicker.superview == nil) {
			[self animateDatePickerIn];
		}
	}
	else {
		[self resignFirstResponderForSubviewsOfView:self.view];
	}
}

#pragma mark - Event Handlers

- (void)doneButtonClicked:(id)sender {
	NSDate *diveDate = [_datePicker date];
	[_dive setDiveDate:diveDate];
	NSIndexPath *dateIndexPath = [NSIndexPath indexPathForRow:1
	                                                inSection:0];
	[self.tableView reloadRowsAtIndexPaths:@[dateIndexPath]
	                  withRowAnimation:UITableViewRowAnimationFade];
	[self animateDatePickerOut];
}

- (IBAction)saveButtonClicked:(id)sender {
	[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
	if (_delegate) {
		if (_newDive) {
			[_delegate didSaveDive:_dive inContext:_diveDetailsContext];
		}
		else {
			[_delegate didSaveDive:_dive inContext:_dive.managedObjectContext];
		}
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButtonClicked:(id)sender {
	[self animateDatePickerOut];
	if (_delegate) {
		[_delegate didDismissWithoutSaving];
	}
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)postToFBClicked:(id)sender {
	DDLogInfo(@"Clicked post to Facebook");    
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
	if (textField == _diveNameTxt) {
		if (![_diveNameTxt.text isEqualToString:@""]) {
			[_dive setDiveName:_diveNameTxt.text];
		}
	}
	else if (textField == _diveDateTxt) {
		// Verify if it's a valid date
		[_dive setDiveDate:[TYGenericUtils dateFromString:_diveDateTxt.text]];
	}
	else if (textField == _diveAirTempTxt) {
		NSScanner *intScanner = [NSScanner scannerWithString:[_diveAirTempTxt text]];
		BOOL isFloat = [intScanner scanFloat:nil];
		if (isFloat) {
			[_dive setAirTemperature:@([_diveAirTempTxt.text floatValue])];
		}
	}
	else if (textField == _diveTimeTxt) {
		NSScanner *intScanner = [NSScanner scannerWithString:[_diveTimeTxt text]];
		BOOL isFloat = [intScanner scanFloat:nil];
		if (isFloat) {
			[_dive setDiveTime:@([_diveTimeTxt.text floatValue])];
		}
	}
	else if (textField == _diveVisibilityTxt) {
		NSScanner *intScanner = [NSScanner scannerWithString:[_diveVisibilityTxt text]];
		BOOL isFloat = [intScanner scanFloat:nil];
		if (isFloat) {
			[_dive setVisibility:@([_diveVisibilityTxt.text floatValue])];
		}
	}
	else if (textField == _diveWaterTempTxt) {
		NSScanner *intScanner = [NSScanner scannerWithString:[_diveWaterTempTxt text]];
		BOOL isFloat = [intScanner scanFloat:nil];
		if (isFloat) {
			[_dive setWaterTemperature:@([_diveWaterTempTxt.text floatValue])];
		}
	}
	else if (textField == _tankAirCompositionTxt) {
		[_dive.tank setAirComposition:_tankAirCompositionTxt.text];
	}
	else if (textField == _tankEndingPressureTxt) {
		NSScanner *intScanner = [NSScanner scannerWithString:[_tankEndingPressureTxt text]];
		BOOL isFloat = [intScanner scanFloat:nil];
		if (isFloat) {
			[_dive.tank setEndingPressure:@([_tankEndingPressureTxt.text floatValue])];
		}
	}
	else if (textField == _tankStartingPressureTxt) {
		NSScanner *intScanner = [NSScanner scannerWithString:[_tankStartingPressureTxt text]];
		BOOL isFloat = [intScanner scanFloat:nil];
		if (isFloat) {
			[_dive.tank setStartingPressure:@([_tankStartingPressureTxt.text floatValue])];
		}
	}
}

#pragma mark - Helpers

- (void)animateDatePickerOut {
	// Animate out the datepicker
	CGRect datePickerFrame = _datePicker.frame;
	datePickerFrame.origin.y = self.view.window.bounds.size.height;
    
	// Slide up the tableView to make space
	CGRect newFrame = self.tableView.frame;
	newFrame.size.height += _datePicker.frame.size.height;
    
	[UIView animateWithDuration:0.25
	                      delay:0.0
	                    options:UIViewAnimationOptionCurveEaseIn
	                 animations: ^{
                         _datePicker.frame = datePickerFrame;
                         self.tableView.frame = newFrame;
                     }
     
	                 completion: ^(BOOL finished) {
                         if (finished) {
                             [_datePicker removeFromSuperview];
                         }
                     }];
	[self.navigationItem setRightBarButtonItem:_saveButton];
}

- (void)animateDatePickerIn {
	CGSize pickerSize = [_datePicker sizeThatFits:CGSizeZero];
	_datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, self.view.window.bounds.size.height, pickerSize.width, pickerSize.height)];
	[_datePicker setDatePickerMode:UIDatePickerModeDate];
	[_datePicker setDate:[[NSDate alloc] init]];
	[self.view.window addSubview:_datePicker];
	// Animate in the datepicker
	CGRect pickerRect = CGRectMake(0.0,
	                               self.view.window.bounds.size.height - _datePicker.frame.size.height,
	                               _datePicker.frame.size.width,
	                               _datePicker.frame.size.height);
	// Slide up the tableView to make space
	CGRect tableViewFrame = self.tableView.frame;
	tableViewFrame.size.height -= _datePicker.frame.size.height;
	tableViewFrame.size.height += self.tabBarController.tabBar.frame.size.height;
    
	[UIView animateWithDuration:0.25
	                      delay:0.0
	                    options:UIViewAnimationOptionCurveEaseIn
	                 animations: ^{
                         _datePicker.frame = pickerRect;
                         self.tableView.frame = tableViewFrame;
                     }
     
	                 completion:nil];
	[self.navigationItem setRightBarButtonItem:_doneButton];
}

- (void)resignFirstResponderForSubviewsOfView:(UIView *)aView {
	for (UIView *subview in[aView subviews]) {
		if ([subview isKindOfClass:[UITextField class]] || [subview isKindOfClass:[UITextView class]])
			[(id)subview resignFirstResponder];
        
		[self resignFirstResponderForSubviewsOfView:subview];
	}
}

- (UITextField *)makeTxtField {
	UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(140, 12, 165, 30)];
	textField.adjustsFontSizeToFitWidth = NO;
	textField.textColor = [self darkBlueTextColor];
	textField.returnKeyType = UIReturnKeyNext;
	textField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
	textField.autocapitalizationType = UITextAutocapitalizationTypeWords; // no auto capitalization support
	textField.textAlignment = NSTextAlignmentRight;
	textField.delegate = self;
	[textField setBackgroundColor:[UIColor clearColor]];
	textField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
	[textField setEnabled:YES];
	return textField;
}

- (BOOL)validateAndSave {
	NSDate *diveDate = [TYGenericUtils dateFromString:[_diveDateTxt text]];
	if (!diveDate && ![_diveDateTxt.text isEqualToString:@""]) {
		[TYGenericUtils displayErrorAlert:@"Dive Date doesn't look valid. Please check."];
		return NO;
	}
	[_dive setDiveDate:diveDate];
    
	if (_diveVisibilityTxt.text && ![_diveVisibilityTxt.text isEqualToString:@""]) {
		NSScanner *intScanner = [NSScanner scannerWithString:[_diveVisibilityTxt text]];
		BOOL isFloat = [intScanner scanFloat:nil];
		if (!isFloat) {
			[TYGenericUtils displayErrorAlert:@"Please enter a number for the dive visibility"];
			return NO;
		}
		DDLogInfo(@"%f", [_diveVisibilityTxt.text floatValue]);
		[_dive setVisibility:@([_diveVisibilityTxt.text floatValue])];
	}
    
	if (_diveAirTempTxt.text && ![_diveAirTempTxt.text isEqualToString:@""]) {
		NSScanner *intScanner = [NSScanner scannerWithString:[_diveAirTempTxt text]];
		BOOL isFloat = [intScanner scanFloat:nil];
		if (!isFloat) {
			[TYGenericUtils displayErrorAlert:@"Please enter a number for the air temperature"];
			return NO;
		}
		[_dive setAirTemperature:@([_diveAirTempTxt.text floatValue])];
	}
    
	if (_diveWaterTempTxt.text && ![_diveWaterTempTxt.text isEqualToString:@""]) {
		NSScanner *intScanner = [NSScanner scannerWithString:[_diveWaterTempTxt text]];
		BOOL isFloat = [intScanner scanFloat:nil];
		if (!isFloat) {
			[TYGenericUtils displayErrorAlert:@"Please enter a number for the water temperature"];
			return NO;
		}
		[_dive setWaterTemperature:@([_diveWaterTempTxt.text floatValue])];
	}
    
	if (_diveTimeTxt.text && ![_diveTimeTxt.text isEqualToString:@""]) {
		NSScanner *intScanner = [NSScanner scannerWithString:[_diveTimeTxt text]];
		BOOL isFloat = [intScanner scanFloat:nil];
		if (!isFloat) {
			[TYGenericUtils displayErrorAlert:@"Please enter a number for the dive time."];
			return NO;
		}
		[_dive setDiveTime:@([_diveTimeTxt.text floatValue])];
	}
    
	[_dive.tank setAirComposition:_tankAirCompositionTxt.text];
    
	if (_tankEndingPressureTxt.text && ![_tankEndingPressureTxt.text isEqualToString:@""]) {
		NSScanner *intScanner = [NSScanner scannerWithString:[_tankEndingPressureTxt text]];
		BOOL isFloat = [intScanner scanFloat:nil];
		if (!isFloat) {
			[TYGenericUtils displayErrorAlert:@"Please enter a number for the ending pressure. Units in psi."];
			return NO;
		}
		[_dive setDiveTime:@([_tankEndingPressureTxt.text floatValue])];
	}
    
	if (_tankStartingPressureTxt.text && ![_tankStartingPressureTxt.text isEqualToString:@""]) {
		NSScanner *intScanner = [NSScanner scannerWithString:[_tankStartingPressureTxt text]];
		BOOL isFloat = [intScanner scanFloat:nil];
		if (!isFloat) {
			[TYGenericUtils displayErrorAlert:@"Please enter a number for the starting pressure. Units in psi."];
			return NO;
		}
		[_dive setDiveTime:@([_tankStartingPressureTxt.text floatValue])];
	}
    
	return YES;
}

- (void)createNavBarButtons {
	_doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClicked:)];
    
	_saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonClicked:)];
	[[self navigationItem] setRightBarButtonItem:_saveButton];
    
	_cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked:)];
	[[self navigationItem] setLeftBarButtonItem:_cancelButton];
}

- (void)createPostToFBButton {
	UIView *holderView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 60.0)];
	[holderView setBackgroundColor:[UIColor clearColor]];
    
	UIButton *postToFB = [UIButton buttonWithType:UIButtonTypeCustom];
	[postToFB setFrame:CGRectMake(10.0, 7.0, 300.0, 45.0)];
	[postToFB setBackgroundColor:[UIColor clearColor]];
	[postToFB setBackgroundImage:[UIImage imageNamed:@"post_to_fb.png"]
	                    forState:UIControlStateNormal];
    
	[postToFB  addTarget:self
	              action:@selector(postToFBClicked:)
	    forControlEvents:UIControlEventTouchUpInside];
    
	[holderView addSubview:postToFB];
	[self.tableView setTableFooterView:holderView];
}

- (UIColor *)darkBlueTextColor {
	return [UIColor colorWithRed:0.22f green:0.33f blue:0.53f alpha:1.0f];
}

- (UITableViewCell *)makeVisibilityCell {
	UITableViewCell *cell = [self makeNewCell];
	[[cell textLabel] setText:@"Visibility (ft)"];
	_diveVisibilityTxt = [self makeTxtField];
	_diveVisibilityTxt.keyboardType = UIKeyboardTypeNumberPad;
	[cell addSubview:_diveVisibilityTxt];
	if ([_dive visibility]) {
		NSString *visibility = [NSString stringWithFormat:@"%.2f", [_dive.visibility floatValue]];
		[_diveVisibilityTxt setText:visibility];
	}
	return cell;
}

- (UITableViewCell *)makeAirTemperatureCell {
	UITableViewCell *cell = [self makeNewCell];
	[[cell textLabel] setText:@"Air Temperature (°F)"];
	_diveAirTempTxt = [self makeTxtField];
	_diveAirTempTxt.keyboardType = UIKeyboardTypeNumberPad;
	[cell addSubview:_diveAirTempTxt];
	if ([_dive airTemperature]) {
		NSString *airTemperature = [NSString stringWithFormat:@"%.2f", [_dive.airTemperature floatValue]];
		[_diveAirTempTxt setText:airTemperature];
	}
	return cell;
}

- (UITableViewCell *)makeWaterTemperatureCell {
	UITableViewCell *cell = [self makeNewCell];
	[[cell textLabel] setText:@"Water temperature (°F)"];
	_diveWaterTempTxt = [self makeTxtField];
	_diveWaterTempTxt.keyboardType = UIKeyboardTypeNumberPad;
	[cell addSubview:_diveWaterTempTxt];
	if ([_dive waterTemperature]) {
		NSString *waterTemperature = [NSString stringWithFormat:@"%.2f", [_dive.waterTemperature floatValue]];
		[_diveWaterTempTxt setText:waterTemperature];
	}
	return cell;
}

- (UITableViewCell *)makeDiveTimeCell {
    _diveTimeTxt = [self makeTxtField];
	_diveTimeTxt.keyboardType = UIKeyboardTypeNumberPad;
    
	UITableViewCell *cell = [self tableViewCellWithLabelText:@"Dive Time" textField:_diveTimeTxt];

	if ([_dive diveTime]) {
		NSString *diveTime = [NSString stringWithFormat:@"%.2f", [_dive.diveTime floatValue]];
		[_diveTimeTxt setText:diveTime];
	}
	return cell;
}

- (UITableViewCell *)makeNewCell {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableViewCell Default.png"]];
	[cell.textLabel setShadowColor:[UIColor whiteColor]];
	[cell.textLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
	[cell.textLabel setBackgroundColor:[UIColor clearColor]];
	[cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
	return cell;
}

- (UITableViewCell *)tableViewCellWithLabelText:(NSString *)labelTxt textField:(UITextField *)textField {
    UITableViewCell *cell = [self makeNewCell];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 20.0f)];
    [textLabel setText:labelTxt];
    [cell addSubview:textField];
    [cell addSubview:textLabel];
    
    NSArray *constraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V|-[textLabel]-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:NSDictionaryOfVariableBindings(textLabel, textField)];
    
    NSArray *constraints3 = [NSLayoutConstraint constraintsWithVisualFormat:@"V|-[textField]-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:NSDictionaryOfVariableBindings(textLabel, textField)];
    
    NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[textLabel]-[textField]-|"
                                                                   options:0
                                                                   metrics:nil
                                                                     views:NSDictionaryOfVariableBindings(textLabel, textField)];
    [cell addConstraints:constraints];
    [cell addConstraints:constraints2];
    [cell addConstraints:constraints3];
    return cell;
}

@end
