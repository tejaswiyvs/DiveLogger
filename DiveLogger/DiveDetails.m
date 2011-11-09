//
//  DiveDetails.m
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DiveDetails.h"
#import "ActionSheetPicker.h"
#import "DiveLocationPicker.h"

@interface DiveDetails (private)
-(void) createNavBarButtons;
-(void) createAirCompositionPicker;
-(void) dismissKeyboard;
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
@synthesize pickerViewItems = _pickerViewItems;
@synthesize airCompositionPicker = _airCompositionPicker;

static int kNumberOfSections = 3;

-(id) initWithDive:(Dive *) dive {
    self = [super initWithNibName:@"DiveDetails" bundle:nil];
    if(self) {
        if(!dive) {
            [self setTitle:@"Add a dive"];
            _newDive = YES;
            dive = [[Dive alloc] init];
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
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableHeaders = [[NSMutableArray alloc] init];
    [_tableHeaders addObject:@"Dive Info"];
    [_tableHeaders addObject:@"Tank Info"];
    [_tableHeaders addObject:@"Conditions"];
    
    _pickerViewItems = [[NSMutableArray alloc] init];
    [_pickerViewItems addObject:@"Nitrox 1"];
    [_pickerViewItems addObject:@"Nitrox 2"];
    [_pickerViewItems addObject:@"Other"];
    
    [self createNavBarButtons];
    [self createAirCompositionPicker];
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
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 30.0)];
    [headerLabel setText:[_tableHeaders objectAtIndex:section]];
    [headerLabel setBackgroundColor:[UIColor clearColor]];
    return headerLabel;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Dive Name
    if(indexPath.section == 0 && indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITextField *nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(140, 12, 165, 30)];
        nameTextField.adjustsFontSizeToFitWidth = NO;
        nameTextField.textColor = [UIColor blueColor];
        nameTextField.placeholder = @"Dive Name";
        nameTextField.keyboardType = UIKeyboardTypeNamePhonePad;
        nameTextField.returnKeyType = UIReturnKeyNext;
        nameTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        nameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords; // no auto capitalization support
        nameTextField.textAlignment = UITextAlignmentRight;
        nameTextField.tag = 0;
        nameTextField.delegate = self;
        //playerTextField.delegate = self;
        
        nameTextField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
        [nameTextField setEnabled: YES];
        
        [cell addSubview:nameTextField];
        [[cell textLabel] setText:@"Dive Name"];
        if ([_dive diveName] && ![[_dive diveName] isEqualToString:@""]) {
            [nameTextField setText:[_dive diveName]];
        }
        return cell;
    }
    // Dive Date
    else if(indexPath.section == 0 && indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [[cell textLabel] setText:@"Dive Date"];
        if([_dive diveDate]) {
            [cell.detailTextLabel setText:[TYGenericUtils stringFromDate:[_dive diveDate]]];
        }
        else {
            // Initialize by default to today.
            [cell.detailTextLabel setText:[TYGenericUtils stringFromDate:[[NSDate alloc] init]]];
        }
        return cell;    
    }
    // Dive Location
    else if(indexPath.section == 0 && indexPath.row == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [[cell textLabel] setText:@"Dive Location"];
        if(_dive.diveLocation.latitude == EmptyLocationCoordinate.latitude && _dive.diveLocation.longitude == EmptyLocationCoordinate.longitude) {
            [[cell detailTextLabel] setText:@"Pick a Location"];
        }
        else {
            NSString *locationString = [NSString stringWithFormat:@"%f, %f", _dive.diveLocation.latitude, _dive.diveLocation.longitude];
            [[cell detailTextLabel] setText:locationString];
        }
        return cell;
    }
    else if(indexPath.section == 0 && indexPath.row == 3) {
        return [self makeDiveTimeCell];
    }
    else if(indexPath.section == 1 && indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [[cell textLabel] setText:@"Starting Pressure"];
        UITextField *startingPressureTxt = [[UITextField alloc] initWithFrame:CGRectMake(170, 12, 135, 30)];
        startingPressureTxt.adjustsFontSizeToFitWidth = NO;
        startingPressureTxt.textColor = [UIColor blueColor];
//        startingPressureTxt.placeholder = @"Pressure in psi";
        startingPressureTxt.keyboardType = UIKeyboardTypeNumberPad;
        startingPressureTxt.returnKeyType = UIReturnKeyNext;
        startingPressureTxt.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
        startingPressureTxt.autocapitalizationType = UITextAutocapitalizationTypeWords; // no auto capitalization support
        startingPressureTxt.textAlignment = UITextAlignmentRight;
        startingPressureTxt.tag = 1;
        startingPressureTxt.delegate = self;
        //playerTextField.delegate = self;
        
        startingPressureTxt.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
        [startingPressureTxt setEnabled: YES];
        
        [cell addSubview:startingPressureTxt];

        if ([[_dive tank] startingPressure]) {
            NSString *startingPressure = [NSString stringWithFormat:@"%d psi", [[_dive tank] startingPressure]];
            [startingPressureTxt setText:startingPressure];
        }
        return cell;
    }
    else if(indexPath.section == 1 && indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [[cell textLabel] setText:@"Ending Pressure"];
        UITextField *endingPressureTxt = [[UITextField alloc] initWithFrame:CGRectMake(170, 12, 135, 30)];
        endingPressureTxt.adjustsFontSizeToFitWidth = NO;
        endingPressureTxt.textColor = [UIColor blueColor];
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
            NSString *endingPressure = [NSString stringWithFormat:@"%d psi", [[_dive tank] endingPressure]];
            [endingPressureTxt setText:endingPressure];
        }
        return cell;
    }
    else if(indexPath.section == 1 && indexPath.row == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [[cell textLabel] setText:@"Air Composition"];
        if([[_dive tank] airComposition]) {
            if([[_dive tank] airComposition] == kTYAirCompositionNitrox1) {
                [[cell detailTextLabel] setText:@"Nitrox 1"];
            }
            else if([[_dive tank] airComposition] == kTYAirCompositionNitrox2) {
                [[cell detailTextLabel] setText:@"Nitrox 2"];
            }
            else {
                [[cell detailTextLabel] setText:@"Other"];
            }
        }
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
    // Date of dive picker
    if(indexPath.section == 0 && indexPath.row == 1) {
        UIDatePicker *pickerView = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 40, 320, 216)];
        [pickerView setDatePickerMode:UIDatePickerModeDate];
        [pickerView setMaximumDate:[[NSDate alloc] init]];
        [pickerView setDate:[[NSDate alloc] init]];
    }
    // Location Picker
    else if(indexPath.section == 0 && indexPath.row == 2) {
        DiveLocationPicker *locationPicker = [[DiveLocationPicker alloc] initWithDive:_dive];
        [[self navigationController] pushViewController:locationPicker animated:YES];
    }
    // Air Composition Picker
    else if(indexPath.section == 1 && indexPath.row == 2) {
        [_airCompositionPicker setHidden:NO];
    }
}

#pragma mark - PickerView

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [_pickerViewItems count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [_pickerViewItems objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if(!_dive.tank) {
        _dive.tank = [[Tank alloc] init];
    }
    if (row == 0) {
        [_dive.tank setAirComposition:kTYAirCompositionNitrox1];
    }
    else if(row == 1) {
        [_dive.tank setAirComposition:kTYAirCompositionNitrox2];
    }
    else if(row == 2) {
        [_dive.tank setAirComposition:kTYAirCompositionOther];
    }
    [_tableView reloadData];
}

#pragma mark - UITextField Delegate

-(void)textFieldDidEndEditing:(UITextField *)textField {
    NSScanner *intScanner = [NSScanner scannerWithString:[textField text]];
    BOOL isInteger = [intScanner scanInt:NULL];
    switch (textField.tag) {
        case 0:
            // dive name
            [_dive setDiveName:[textField text]];
            break;
        case 1:
            // starting pressure
            if (!_dive.tank) {
                _dive.tank = [[Tank alloc] init];
            }
            if(!isInteger) {
                // Not an integer.
                [TYGenericUtils displayErrorAlert:@"Please enter a number for the starting pressure. Units in psi."];
                [textField setText:@""];
                return;
            }
            _dive.tank.startingPressure = [[textField text] intValue];
            break;
        case 2:
            // ending pressure
            if (!_dive.tank) {
                _dive.tank = [[Tank alloc] init];
            }
            if(!isInteger) {
                // Not an integer.
                [TYGenericUtils displayErrorAlert:@"Please enter a number for the ending pressure. Units in psi."];
                [textField setText:@""];
                return;
            }
            _dive.tank.endingPressure = [[textField text] intValue];
            break;
        case 3:
            // visibility
            if(!isInteger) {
                // Not an integer.
                [TYGenericUtils displayErrorAlert:@"Please enter a number for the visibility. Units are in feet."];
                [textField setText:@""];
                return;
            }
            _dive.visibility = [[textField text] intValue];
            break;
        case 4:
            // air temperature
            if(!isInteger) {
                // Not an integer.
                [TYGenericUtils displayErrorAlert:@"Please enter a number for the current air temperature. Units are in °F."];
                [textField setText:@""];
                return;
            }

            _dive.airTemperature = [[textField text] intValue];
            break;
        case 5:
            // water temperature
            if(!isInteger) {
                // Not an integer.
                [TYGenericUtils displayErrorAlert:@"Please enter a number for the water temperature. Units are in °F."];
                [textField setText:@""];
                return;
            }
            _dive.waterTemperature = [[textField text] intValue];
            break;
        case 6:
            if(!isInteger) {
                // Not an integer.
                [TYGenericUtils displayErrorAlert:@"Please enter a number in minutes for the dive time. Typing in value of 60 indicates 60 minutes."];
                [textField setText:@""];
                return;
            }
            _dive.diveTime = [[textField text] intValue];
            // dive time (don't ask)
            break;
        default:
            break;
    }
}

#pragma mark - Event Handlers

-(IBAction) saveButtonClicked:(id) sender {
    if(_delegate) {
        [_delegate didSaveDive:_dive];
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction)cancelButtonClicked:(id)sender {
    if(_delegate) {
        [_delegate didDismissWithoutSaving];
    }
    [self dismissModalViewControllerAnimated:YES];
}

-(void) datePicked:(NSDate *) date {
    NSLog(@"%@", date);
}

#pragma mark - Helpers

-(void) createNavBarButtons {
    if(_newDive) {
        UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonClicked:)];
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClicked:)];
        [[self navigationItem] setRightBarButtonItem:saveButton];
        [[self navigationItem] setLeftBarButtonItem:cancelButton];
    }
}

-(void) createAirCompositionPicker {
    [_airCompositionPicker setHidden:YES];
}

-(UITableViewCell *) makeVisibilityCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[cell textLabel] setText:@"Visibility (ft)"];
    UITextField *visibilityTxt = [[UITextField alloc] initWithFrame:CGRectMake(140, 12, 165, 30)];
    visibilityTxt.adjustsFontSizeToFitWidth = NO;
    visibilityTxt.textColor = [UIColor blueColor];
    visibilityTxt.keyboardType = UIKeyboardTypeNamePhonePad;
    visibilityTxt.returnKeyType = UIReturnKeyNext;
    visibilityTxt.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    visibilityTxt.autocapitalizationType = UITextAutocapitalizationTypeWords; // no auto capitalization support
    visibilityTxt.textAlignment = UITextAlignmentRight;
    visibilityTxt.tag = 3;
    visibilityTxt.delegate = self;
    
    visibilityTxt.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
    [visibilityTxt setEnabled: YES];
    
    [cell addSubview:visibilityTxt];    
    if ([_dive visibility]) {
        NSString *visibility = [NSString stringWithFormat:@"%d", [_dive visibility]];
        [visibilityTxt setText:visibility];
    }
    return cell;
}

-(UITableViewCell *) makeAirTemperatureCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[cell textLabel] setText:@"Air Temperature (°F)"];
    UITextField *airTemperatureTxt = [[UITextField alloc] initWithFrame:CGRectMake(190, 12, 115, 30)];
    airTemperatureTxt.adjustsFontSizeToFitWidth = NO;
    airTemperatureTxt.textColor = [UIColor blueColor];
    airTemperatureTxt.keyboardType = UIKeyboardTypeNumberPad;
    airTemperatureTxt.returnKeyType = UIReturnKeyNext;
    airTemperatureTxt.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    airTemperatureTxt.autocapitalizationType = UITextAutocapitalizationTypeWords; // no auto capitalization support
    airTemperatureTxt.textAlignment = UITextAlignmentRight;
    airTemperatureTxt.tag = 4;
    airTemperatureTxt.delegate = self;
    
    airTemperatureTxt.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
    [airTemperatureTxt setEnabled: YES];
    
    [cell addSubview:airTemperatureTxt];
    
    if ([_dive airTemperature]) {
        NSString *airTemperature = [NSString stringWithFormat:@"%d", [_dive airTemperature]];
        [airTemperatureTxt setText:airTemperature];
    }
    return cell;
}

-(UITableViewCell *) makeWaterTemperatureCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[cell textLabel] setText:@"Water temperature (°F)"];
    UITextField *waterTemperatureTxt = [[UITextField alloc] initWithFrame:CGRectMake(215, 12, 90, 30)];
    waterTemperatureTxt.adjustsFontSizeToFitWidth = NO;
    waterTemperatureTxt.textColor = [UIColor blueColor];
    waterTemperatureTxt.keyboardType = UIKeyboardTypeNumberPad;
    waterTemperatureTxt.returnKeyType = UIReturnKeyNext;
    waterTemperatureTxt.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    waterTemperatureTxt.autocapitalizationType = UITextAutocapitalizationTypeWords; // no auto capitalization support
    waterTemperatureTxt.textAlignment = UITextAlignmentRight;
    waterTemperatureTxt.tag = 5;
    waterTemperatureTxt.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
    [waterTemperatureTxt setEnabled:YES];
    waterTemperatureTxt.delegate = self;
    
    [cell addSubview:waterTemperatureTxt];
    
    if ([_dive waterTemperature]) {
        NSString *waterTemperature = [NSString stringWithFormat:@"%d", [_dive waterTemperature]];
        [waterTemperatureTxt setText:waterTemperature];
    }
    return cell;
}

-(UITableViewCell *) makeDiveTimeCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [[cell textLabel] setText:@"Dive Time"];
    UITextField *currentDiveTimeTxt = [[UITextField alloc] initWithFrame:CGRectMake(140, 12, 165, 30)];
    currentDiveTimeTxt.adjustsFontSizeToFitWidth = NO;
    currentDiveTimeTxt.textColor = [UIColor blueColor];
    currentDiveTimeTxt.keyboardType = UIKeyboardTypeNumberPad;
    currentDiveTimeTxt.returnKeyType = UIReturnKeyNext;
    currentDiveTimeTxt.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    currentDiveTimeTxt.autocapitalizationType = UITextAutocapitalizationTypeWords; // no auto capitalization support
    currentDiveTimeTxt.textAlignment = UITextAlignmentRight;
    currentDiveTimeTxt.tag = 6;
    currentDiveTimeTxt.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
    [currentDiveTimeTxt setEnabled:YES];
    currentDiveTimeTxt.delegate = self;
    
    [cell addSubview:currentDiveTimeTxt];
    
    if ([_dive diveTime]) {
        NSString *diveTime = [NSString stringWithFormat:@"%d", [_dive diveTime]];
        [currentDiveTimeTxt setText:diveTime];
    }
    return cell;
}
@end
