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

@interface DiveDetails (private)
-(void) createNavBarButtons;
-(void) dismissKeyboard;
-(void) validateDive;
-(BOOL) validateAndSave;
-(UIColor *) darkBlueTextColor;
-(UITableViewCell *) makeVisibilityCell;
-(UITableViewCell *) makeAirTemperatureCell;
-(UITableViewCell *) makeWaterTemperatureCell;
-(UITableViewCell *) makeDiveTimeCell;
@end

@implementation DiveDetails

@synthesize dive = _dive;
@synthesize delegate = _delegate;
@synthesize newDive = _newDive;
@synthesize tableHeaders = _tableHeaders;
@synthesize tableView = _tableView;

@synthesize diveAirTempTxt = _diveAirTempTxt, diveDateTxt = _diveDateTxt, diveLocTxt = _diveLocTxt, diveNameTxt = _diveNameTxt, diveTimeTxt = _diveTimeTxt, diveVisibilityTxt = _diveVisibilityTxt, diveWaterTempTxt = _diveWaterTempTxt;

@synthesize tankAirCompositionTxt = _tankAirCompositionTxt, tankEndingPressureTxt = _tankEndingPressureTxt, tankStartingPressureTxt = _tankStartingPressureTxt;

static int kNumberOfSections = 3;

-(id) initWithDive:(Dive *) dive {
    self = [super initWithNibName:@"DiveDetails" bundle:nil];
    if(self) {
        if(!dive) {
            [self setTitle:@"Add a dive"];
            _newDive = YES;
            TYAppDelegate *appDelegate = (TYAppDelegate *) [[UIApplication sharedApplication] delegate];
            dive = (Dive *) [NSEntityDescription insertNewObjectForEntityForName:@"Dive" inManagedObjectContext:[appDelegate managedObjectContext]];
            Tank *tank = (Tank *) [NSEntityDescription insertNewObjectForEntityForName:@"Tank" inManagedObjectContext:[appDelegate managedObjectContext]];
            tank.airComposition = @"";
            tank.airCompositionNotes = @"";
            tank.dive = dive;
            tank.startingPressure = nil;
            tank.endingPressure = nil;
            dive.tank = tank;
            dive.diveDate = [[NSDate alloc] init];
            dive.diveName = @"";
            dive.diveLocationX = nil;
            dive.diveLocationY = nil;
            dive.diveTime = [NSNumber numberWithInt:0];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableHeaders = [[NSMutableArray alloc] init];
    [_tableHeaders addObject:@"Dive Info"];
    [_tableHeaders addObject:@"Tank Info"];
    [_tableHeaders addObject:@"Conditions"];
        
    [self createNavBarButtons];
}

-(void) viewDidAppear:(BOOL) animated {
    [super viewDidAppear:animated];
    [_tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kNumberOfSections;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 4;
    }
    else if(section == 1) {
        return 3;
    }
    else if(section == 2) {
        return 3;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect frame = CGRectMake(0.0, 0.0, 320.0, 30.0);
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"UITableViewHeader.png"]]];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(3.0, 0.0, 320.0, 30.0)];
    [headerLabel setText:[_tableHeaders objectAtIndex:section]];
    [headerLabel setTextColor:[UIColor whiteColor]];
    [headerLabel setShadowColor:[UIColor blackColor]];
    [headerLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    [view addSubview:headerLabel];
    return view;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Dive Name
    if(indexPath.section == 0 && indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableViewCell Default.png"]];

        _diveNameTxt = [[UITextField alloc] initWithFrame:CGRectMake(140, 12, 165, 30)];
        _diveNameTxt.adjustsFontSizeToFitWidth = NO;
        _diveNameTxt.textColor = [self darkBlueTextColor];
        _diveNameTxt.placeholder = @"Dive Name";
        _diveNameTxt.keyboardType = UIKeyboardTypeNamePhonePad;
        _diveNameTxt.returnKeyType = UIReturnKeyNext;
        _diveNameTxt.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        _diveNameTxt.autocapitalizationType = UITextAutocapitalizationTypeWords; // no auto capitalization support
        _diveNameTxt.textAlignment = UITextAlignmentRight;
        _diveNameTxt.delegate = self;
        [_diveNameTxt setBackgroundColor:[UIColor clearColor]];
        //playerTextField.delegate = self;
        
        _diveNameTxt.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
        [_diveNameTxt setEnabled: YES];
        
        [cell addSubview:_diveNameTxt];
        [[cell textLabel] setText:@"Dive Name"];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setShadowColor:[UIColor whiteColor]];
        [cell.textLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
        
        if ([_dive diveName] && ![[_dive diveName] isEqualToString:@""]) {
            [_diveNameTxt setText:[_dive diveName]];
        }
        
        if(!_newDive) {
            [_diveNameTxt setEnabled:NO];
        }
        return cell;
    }
    // Dive Date
    else if(indexPath.section == 0 && indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableViewCell Default.png"]];
        _diveDateTxt = [[UITextField alloc] initWithFrame:CGRectMake(140, 12, 165, 30)];
        _diveDateTxt.adjustsFontSizeToFitWidth = NO;
        _diveDateTxt.textColor = [self darkBlueTextColor];
        _diveDateTxt.placeholder = @"Dive Name";
        _diveDateTxt.keyboardType = UIKeyboardTypeNamePhonePad;
        _diveDateTxt.returnKeyType = UIReturnKeyNext;
        _diveDateTxt.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        _diveDateTxt.autocapitalizationType = UITextAutocapitalizationTypeWords; // no auto capitalization support
        _diveDateTxt.textAlignment = UITextAlignmentRight;
        _diveDateTxt.delegate = self;
        [_diveDateTxt setBackgroundColor:[UIColor clearColor]];
        //playerTextField.delegate = self;
        
        _diveDateTxt.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
        [_diveDateTxt setEnabled: YES];
        
        [cell addSubview:_diveDateTxt];

        [[cell textLabel] setText:@"Dive Date"];
        if(![_dive diveDate]) {
            _dive.diveDate = [[NSDate alloc] init];
        }
        [_diveDateTxt setText:[TYGenericUtils stringFromDate:_dive.diveDate]];
        return cell;    
    }
    // Dive Location
    else if(indexPath.section == 0 && indexPath.row == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableViewCell Default.png"]];
        [[cell textLabel] setText:@"Dive Location"];
        if(_dive.diveLocation.latitude == EmptyLocationCoordinate.latitude && _dive.diveLocation.longitude == EmptyLocationCoordinate.longitude) {
            [[cell detailTextLabel] setText:@"Pick a Location"];
        }
        else {
            NSString *locationString = [NSString stringWithFormat:@"%f, %f", _dive.diveLocation.latitude, _dive.diveLocation.longitude];
            [[cell detailTextLabel] setText:locationString];
        }
        [cell.textLabel setShadowColor:[UIColor whiteColor]];
        [cell.textLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        return cell;
    }
    else if(indexPath.section == 0 && indexPath.row == 3) {
        return [self makeDiveTimeCell];
    }
    else if(indexPath.section == 1 && indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableViewCell Default.png"]];
        [[cell textLabel] setText:@"Starting Pressure"];
        _tankStartingPressureTxt = [[UITextField alloc] initWithFrame:CGRectMake(170, 12, 135, 30)];
        _tankStartingPressureTxt.adjustsFontSizeToFitWidth = NO;
        _tankStartingPressureTxt.textColor = [self darkBlueTextColor];
//        startingPressureTxt.placeholder = @"Pressure in psi";
        _tankStartingPressureTxt.keyboardType = UIKeyboardTypeNumberPad;
        _tankStartingPressureTxt.returnKeyType = UIReturnKeyNext;
        _tankStartingPressureTxt.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        _tankStartingPressureTxt.autocapitalizationType = UITextAutocapitalizationTypeWords; // no auto capitalization support
        _tankStartingPressureTxt.textAlignment = UITextAlignmentRight;
        _tankStartingPressureTxt.tag = 1;
        _tankStartingPressureTxt.delegate = self;
        //playerTextField.delegate = self;
        
        _tankStartingPressureTxt.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
        [_tankStartingPressureTxt setEnabled: YES];
        
        [cell addSubview:_tankStartingPressureTxt];
        if ([_dive.tank startingPressure]) {
            NSString *startingPressure = [NSString stringWithFormat:@"%f psi", [[_dive tank] startingPressure]];
            [_tankStartingPressureTxt setText:startingPressure];
        }
        [cell.textLabel setShadowColor:[UIColor whiteColor]];
        [cell.textLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        return cell;
    }
    else if(indexPath.section == 1 && indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableViewCell Default.png"]];
        [[cell textLabel] setText:@"Ending Pressure"];
        UITextField *endingPressureTxt = [[UITextField alloc] initWithFrame:CGRectMake(170, 12, 135, 30)];
        endingPressureTxt.adjustsFontSizeToFitWidth = NO;
        endingPressureTxt.textColor = [self darkBlueTextColor];
//        endingPressureTxt.placeholder = @"Pressure in psi";
        endingPressureTxt.keyboardType = UIKeyboardTypeNumberPad;
        endingPressureTxt.returnKeyType = UIReturnKeyNext;
        endingPressureTxt.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        endingPressureTxt.autocapitalizationType = UITextAutocapitalizationTypeWords; // no auto capitalization support
        endingPressureTxt.textAlignment = UITextAlignmentRight;
        endingPressureTxt.tag = 2;
        endingPressureTxt.delegate = self;
        
        endingPressureTxt.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
        [endingPressureTxt setEnabled: YES];
        
        [cell addSubview:endingPressureTxt];
        
        if ([[_dive tank] endingPressure]) {
            NSString *endingPressure = [NSString stringWithFormat:@"%f psi", [[_dive tank] endingPressure]];
            [endingPressureTxt setText:endingPressure];
        }
        [cell.textLabel setShadowColor:[UIColor whiteColor]];
        [cell.textLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        return cell;
    }
    else if(indexPath.section == 1 && indexPath.row == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableViewCell Default.png"]];
        [[cell textLabel] setText:@"Air Composition"];
        
        _tankAirCompositionTxt = [[UITextField alloc] initWithFrame:CGRectMake(170, 12, 135, 30)];
        _tankAirCompositionTxt.adjustsFontSizeToFitWidth = NO;
        _tankAirCompositionTxt.textColor = [self darkBlueTextColor];
        //        endingPressureTxt.placeholder = @"Pressure in psi";
        _tankAirCompositionTxt.keyboardType = UIKeyboardTypeNamePhonePad;
        _tankAirCompositionTxt.returnKeyType = UIReturnKeyNext;
        _tankAirCompositionTxt.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        _tankAirCompositionTxt.autocapitalizationType = UITextAutocapitalizationTypeWords; // no auto capitalization support
        _tankAirCompositionTxt.textAlignment = UITextAlignmentRight;
        _tankAirCompositionTxt.tag = 2;
        _tankAirCompositionTxt.delegate = self;
        
        _tankAirCompositionTxt.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
        [_tankAirCompositionTxt setEnabled: YES];
        
        [cell addSubview:_tankAirCompositionTxt];

        
        if([_dive.tank airComposition]) {
            [_tankAirCompositionTxt setText:_dive.tank.airComposition];
        }
        [cell.textLabel setShadowColor:[UIColor whiteColor]];
        [cell.textLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        return cell;
    }
    else if(indexPath.section == 2 && indexPath.row == 0) {
        return [self makeVisibilityCell];
    }
    else if(indexPath.section == 2 && indexPath.row == 1) {
        return [self makeAirTemperatureCell];    
    }
    else if(indexPath.section == 2 && indexPath.row == 2) {
        return [self makeWaterTemperatureCell];
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Date of dive picke4
    /* if(indexPath.section == 0 && indexPath.row == 1) {
        UIDatePicker *pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 164.0, 320, 216)];
        [pickerView setDatePickerMode:UIDatePickerModeDate];
        [pickerView setMaximumDate:[[NSDate alloc] init]];
        [pickerView setDate:[[NSDate alloc] init]];
        [self.view addSubview:pickerView];
    } */
    // Location Picker
    if(indexPath.section == 0 && indexPath.row == 2) {
        DiveLocationPicker *locationPicker = [[DiveLocationPicker alloc] initWithDive:_dive];
        [[self navigationController] pushViewController:locationPicker animated:YES];
    }
    // Air Composition Picker
    /* else if(indexPath.section == 1 && indexPath.row == 2) {
        [_airCompositionPicker setHidden:NO];
    } */
}

#pragma mark - Event Handlers

-(IBAction) saveButtonClicked:(id) sender {   
    if([self validateAndSave]) {
        if(_delegate) {
            [_delegate didSaveDive:_dive];
        }   
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)cancelButtonClicked:(id)sender {
    if(_delegate) {
        [_delegate didDismissWithoutSaving];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) datePicked:(NSDate *) date {
    NSLog(@"%@", date);
}

#pragma mark - Helpers

-(BOOL) validateAndSave {
    if([_diveNameTxt.text isEqualToString:@""]) {
        [TYGenericUtils displayErrorAlert:@"Dive Name Cannot be empty"];
        return NO;
    }
    [_dive setDiveName:_diveNameTxt.text];
    
    NSDate *diveDate = [TYGenericUtils dateFromString:[_diveDateTxt text]];
    if(!diveDate && ![_diveDateTxt.text isEqualToString:@""]) {
        [TYGenericUtils displayErrorAlert:@"Dive Date doesn't look valid. Please check."];
        return NO;
    }
    [_dive setDiveDate:diveDate];
    
    if(_diveVisibilityTxt.text && ![_diveVisibilityTxt.text isEqualToString:@""]) {
        NSScanner *intScanner = [NSScanner scannerWithString:[_diveVisibilityTxt text]];
        BOOL isFloat = [intScanner scanFloat:nil];
        if(!isFloat) {
            [TYGenericUtils displayErrorAlert:@"Please enter a number for the dive visibility"];
            return NO;
        }
        [_dive setVisibility:[NSNumber numberWithFloat:[_diveVisibilityTxt.text floatValue]]];
    }
    
    if(_diveAirTempTxt.text && ![_diveAirTempTxt.text isEqualToString:@""]) {
        NSScanner *intScanner = [NSScanner scannerWithString:[_diveAirTempTxt text]];
        BOOL isFloat = [intScanner scanFloat:nil];
        if(!isFloat) {
            [TYGenericUtils displayErrorAlert:@"Please enter a number for the air temperature"];
            return NO;
        }
        [_dive setAirTemperature:[NSNumber numberWithFloat:[_diveAirTempTxt.text floatValue]]];
    }
    
    if(_diveWaterTempTxt.text && ![_diveWaterTempTxt.text isEqualToString:@""]) {
        NSScanner *intScanner = [NSScanner scannerWithString:[_diveWaterTempTxt text]];
        BOOL isFloat = [intScanner scanFloat:nil];
        if(!isFloat) {
            [TYGenericUtils displayErrorAlert:@"Please enter a number for the water temperature"];
            return NO;
        }
        [_dive setWaterTemperature:[NSNumber numberWithFloat:[_diveWaterTempTxt.text floatValue]]];
    }
    
    if(_diveTimeTxt.text && ![_diveTimeTxt.text isEqualToString:@""]) {
        NSScanner *intScanner = [NSScanner scannerWithString:[_diveTimeTxt text]];
        BOOL isFloat = [intScanner scanFloat:nil];
        if(!isFloat) {
            [TYGenericUtils displayErrorAlert:@"Please enter a number for the dive time."];
            return NO;
        }
        [_dive setDiveTime:[NSNumber numberWithFloat:[_diveTimeTxt.text floatValue]]];
    }
    
    [_dive.tank setAirComposition:_tankAirCompositionTxt.text];
    
    if(_tankEndingPressureTxt.text && ![_tankEndingPressureTxt.text isEqualToString:@""]) {
        NSScanner *intScanner = [NSScanner scannerWithString:[_tankEndingPressureTxt text]];
        BOOL isFloat = [intScanner scanFloat:nil];
        if(!isFloat) {
            [TYGenericUtils displayErrorAlert:@"Please enter a number for the ending pressure. Units in psi."];
            return NO;
        }
        [_dive setDiveTime:[NSNumber numberWithFloat:[_tankEndingPressureTxt.text floatValue]]];
    }
    
    if(_tankStartingPressureTxt.text && ![_tankStartingPressureTxt.text isEqualToString:@""]) {
        NSScanner *intScanner = [NSScanner scannerWithString:[_tankStartingPressureTxt text]];
        BOOL isFloat = [intScanner scanFloat:nil];
        if(!isFloat) {
            [TYGenericUtils displayErrorAlert:@"Please enter a number for the starting pressure. Units in psi."];
            return NO;
        }
        [_dive setDiveTime:[NSNumber numberWithFloat:[_tankStartingPressureTxt.text floatValue]]];
    }
    
    return YES;
}

-(void) createNavBarButtons {
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonClicked:)];
    [[self navigationItem] setRightBarButtonItem:saveButton];

    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked:)];
    [[self navigationItem] setLeftBarButtonItem:cancelButton];
}

-(UIColor *) darkBlueTextColor {
    return [UIColor colorWithRed:0.22f green:0.33f blue:0.53f alpha:1.0f];
}

-(UITableViewCell *) makeVisibilityCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableViewCell Default.png"]];
    [[cell textLabel] setText:@"Visibility (ft)"];
    _diveVisibilityTxt = [[UITextField alloc] initWithFrame:CGRectMake(140, 12, 165, 30)];
    _diveVisibilityTxt.adjustsFontSizeToFitWidth = NO;
    _diveVisibilityTxt.textColor = [self darkBlueTextColor];
    _diveVisibilityTxt.keyboardType = UIKeyboardTypeNamePhonePad;
    _diveVisibilityTxt.returnKeyType = UIReturnKeyNext;
    _diveVisibilityTxt.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    _diveVisibilityTxt.autocapitalizationType = UITextAutocapitalizationTypeWords; // no auto capitalization support
    _diveVisibilityTxt.textAlignment = UITextAlignmentRight;
    _diveVisibilityTxt.tag = 3;
    _diveVisibilityTxt.delegate = self;
    
    _diveVisibilityTxt.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
    [_diveVisibilityTxt setEnabled: YES];
    
    [cell addSubview:_diveVisibilityTxt];    
    if ([_dive visibility]) {
        NSString *visibility = [NSString stringWithFormat:@"%f", [_dive visibility]];
        [_diveVisibilityTxt setText:visibility];
    }
    [cell.textLabel setShadowColor:[UIColor whiteColor]];
    [cell.textLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    return cell;
}

-(UITableViewCell *) makeAirTemperatureCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableViewCell Default.png"]];
    [[cell textLabel] setText:@"Air Temperature (°F)"];
    _diveAirTempTxt = [[UITextField alloc] initWithFrame:CGRectMake(190, 12, 115, 30)];
    _diveAirTempTxt.adjustsFontSizeToFitWidth = NO;
    _diveAirTempTxt.textColor = [self darkBlueTextColor];
    _diveAirTempTxt.keyboardType = UIKeyboardTypeNumberPad;
    _diveAirTempTxt.returnKeyType = UIReturnKeyNext;
    _diveAirTempTxt.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    _diveAirTempTxt.autocapitalizationType = UITextAutocapitalizationTypeWords; // no auto capitalization support
    _diveAirTempTxt.textAlignment = UITextAlignmentRight;
    _diveAirTempTxt.tag = 4;
    _diveAirTempTxt.delegate = self;
    
    _diveAirTempTxt.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
    [_diveAirTempTxt setEnabled: YES];
    
    [cell addSubview:_diveAirTempTxt];
    
    if ([_dive airTemperature]) {
        NSString *airTemperature = [NSString stringWithFormat:@"%f", [_dive airTemperature]];
        [_diveAirTempTxt setText:airTemperature];
    }
    [cell.textLabel setShadowColor:[UIColor whiteColor]];
    [cell.textLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    return cell;
}

-(UITableViewCell *) makeWaterTemperatureCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableViewCell Default.png"]];
    [[cell textLabel] setText:@"Water temperature (°F)"];
    _diveWaterTempTxt = [[UITextField alloc] initWithFrame:CGRectMake(215, 12, 90, 30)];
    _diveWaterTempTxt.adjustsFontSizeToFitWidth = NO;
    _diveWaterTempTxt.textColor = [self darkBlueTextColor];
    _diveWaterTempTxt.keyboardType = UIKeyboardTypeNumberPad;
    _diveWaterTempTxt.returnKeyType = UIReturnKeyNext;
    _diveWaterTempTxt.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    _diveWaterTempTxt.autocapitalizationType = UITextAutocapitalizationTypeWords; // no auto capitalization support
    _diveWaterTempTxt.textAlignment = UITextAlignmentRight;
    _diveWaterTempTxt.tag = 5;
    _diveWaterTempTxt.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
    [_diveWaterTempTxt setEnabled:YES];
    _diveWaterTempTxt.delegate = self;
    
    [cell addSubview:_diveWaterTempTxt];
    
    if ([_dive waterTemperature]) {
        NSString *waterTemperature = [NSString stringWithFormat:@"%f", [_dive waterTemperature]];
        [_diveWaterTempTxt setText:waterTemperature];
    }
    [cell.textLabel setShadowColor:[UIColor whiteColor]];
    [cell.textLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    return cell;
}

-(UITableViewCell *) makeDiveTimeCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableViewCell Default.png"]];
    [[cell textLabel] setText:@"Dive Time"];
    _diveTimeTxt = [[UITextField alloc] initWithFrame:CGRectMake(140, 12, 165, 30)];
    _diveTimeTxt.adjustsFontSizeToFitWidth = NO;
    _diveTimeTxt.textColor = [self darkBlueTextColor];
    _diveTimeTxt.keyboardType = UIKeyboardTypeNumberPad;
    _diveTimeTxt.returnKeyType = UIReturnKeyNext;
    _diveTimeTxt.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    _diveTimeTxt.autocapitalizationType = UITextAutocapitalizationTypeWords; // no auto capitalization support
    _diveTimeTxt.textAlignment = UITextAlignmentRight;
    _diveTimeTxt.tag = 6;
    _diveTimeTxt.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
    [_diveTimeTxt setEnabled:YES];
    _diveTimeTxt.delegate = self;
    
    [cell addSubview:_diveTimeTxt];
    
    if ([_dive diveTime]) {
        NSString *diveTime = [NSString stringWithFormat:@"%f", [_dive diveTime]];
        [_diveTimeTxt setText:diveTime];
    }
    [cell.textLabel setShadowColor:[UIColor whiteColor]];
    [cell.textLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    return cell;
}
@end
