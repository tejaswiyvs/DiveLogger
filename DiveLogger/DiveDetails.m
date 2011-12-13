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
-(UITextField *) makeTxtField;
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
static float kEmptyLocation = -1000;

-(id) initWithDive:(Dive *) dive {
    self = [super initWithNibName:@"DiveDetails" bundle:nil];
    if(self) {
        if(!dive) {
            [self setTitle:@"Add a dive"];
            _newDive = YES;

            TYAppDelegate *appDelegate = (TYAppDelegate *) [[UIApplication sharedApplication] delegate];
            NSManagedObjectContext *managedObjectContext = appDelegate.managedObjectContext;
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
            dive.diveLocationX = [NSNumber numberWithFloat:kEmptyLocation];
            dive.diveLocationY = [NSNumber numberWithFloat:kEmptyLocation];
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0) {
        return @"Dive Info";
    }
    else if(section == 1) {
        return @"Tank Info";
    }
    else if(section == 2) {
        return @"Conditions";
    }
    return @"";
}

/* - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
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
} */

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Dive Name
    if(indexPath.section == 0 && indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableViewCell Default.png"]];
        _diveNameTxt = [self makeTxtField];
        _diveNameTxt.placeholder = @"Dive Name";
        _diveNameTxt.keyboardType = UIKeyboardTypeNamePhonePad;        
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
        _diveDateTxt = [self makeTxtField];
        _diveDateTxt.placeholder = @"Dive Date";
        _diveDateTxt.keyboardType = UIKeyboardTypeNamePhonePad;        
        [cell addSubview:_diveDateTxt];
        [[cell textLabel] setText:@"Dive Date"];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];                                            
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
        // Dive Location does not exist or is Equal to Empty Location
        if((_dive.diveLocationX == nil || _dive.diveLocationY == nil) || ([_dive.diveLocationX floatValue] == kEmptyLocation  && [_dive.diveLocationY floatValue] == kEmptyLocation)) {
            [[cell detailTextLabel] setText:@"Pick a Location"];
        }
        else {
            NSString *locationString = [NSString stringWithFormat:@"%.2f, %.2f", _dive.diveLocation.latitude, _dive.diveLocation.longitude];
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
        _tankStartingPressureTxt = [self makeTxtField];
        _tankStartingPressureTxt.placeholder = @"Dive Date";
        _tankStartingPressureTxt.keyboardType = UIKeyboardTypeNumberPad;        
        [cell addSubview:_tankStartingPressureTxt];

        if ([_dive.tank startingPressure]) {
            NSString *startingPressure = [NSString stringWithFormat:@"%.2f psi", [_dive.tank.startingPressure floatValue]];
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
        _tankEndingPressureTxt = [self makeTxtField];
        _tankEndingPressureTxt.placeholder = @"Ending Pressure";
        _tankEndingPressureTxt.keyboardType = UIKeyboardTypeNumberPad;        
        [cell addSubview:_tankEndingPressureTxt];        
        if ([[_dive tank] endingPressure]) {
            NSString *endingPressure = [NSString stringWithFormat:@"%.2f psi", [_dive.tank.endingPressure floatValue]];
            [_tankEndingPressureTxt setText:endingPressure];
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
        _tankAirCompositionTxt = [self makeTxtField];
        _tankAirCompositionTxt.keyboardType = UIKeyboardTypeNamePhonePad;        
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
    //if([self validateAndSave]) {
    if(_delegate) {
        [_delegate didSaveDive:_dive];
    }   
    [self.navigationController popViewControllerAnimated:YES];
    //}
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

#pragma mark - UITextFieldDelegate

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if(textField == _diveNameTxt) {
        if(![_diveNameTxt.text isEqualToString:@""]) {
            [_dive setDiveName:_diveNameTxt.text];
        }
    }
    else if(textField == _diveDateTxt) {
        // Verify if it's a valid date
        [_dive setDiveDate:[TYGenericUtils dateFromString:_diveDateTxt.text]];
    }
    else if(textField == _diveAirTempTxt) {
        NSScanner *intScanner = [NSScanner scannerWithString:[_diveAirTempTxt text]];
        BOOL isFloat = [intScanner scanFloat:nil];
        if(isFloat) {
            [_dive setAirTemperature:[NSNumber numberWithFloat:[_diveAirTempTxt.text floatValue]]];
        }
    }
    else if(textField == _diveTimeTxt) {
        NSScanner *intScanner = [NSScanner scannerWithString:[_diveTimeTxt text]];
        BOOL isFloat = [intScanner scanFloat:nil];
        if(isFloat) {
            [_dive setDiveTime:[NSNumber numberWithFloat:[_diveTimeTxt.text floatValue]]];
        }
    }
    else if(textField == _diveVisibilityTxt) {
        NSScanner *intScanner = [NSScanner scannerWithString:[_diveVisibilityTxt text]];
        BOOL isFloat = [intScanner scanFloat:nil];
        if(isFloat) {
            [_dive setVisibility:[NSNumber numberWithFloat:[_diveVisibilityTxt.text floatValue]]];
        }
    }
    else if(textField == _diveWaterTempTxt) {
        NSScanner *intScanner = [NSScanner scannerWithString:[_diveWaterTempTxt text]];
        BOOL isFloat = [intScanner scanFloat:nil];
        if(isFloat) {
            [_dive setWaterTemperature:[NSNumber numberWithFloat:[_diveWaterTempTxt.text floatValue]]];
        }
    }
    else if(textField == _tankAirCompositionTxt) {
        [_dive.tank setAirComposition:_tankAirCompositionTxt.text];
    }
    else if(textField == _tankEndingPressureTxt) {
        NSScanner *intScanner = [NSScanner scannerWithString:[_tankEndingPressureTxt text]];
        BOOL isFloat = [intScanner scanFloat:nil];
        if(isFloat) {
            [_dive.tank setEndingPressure:[NSNumber numberWithFloat:[_tankEndingPressureTxt.text floatValue]]];
        }
    }
    else if(textField == _tankStartingPressureTxt) {
        NSScanner *intScanner = [NSScanner scannerWithString:[_tankStartingPressureTxt text]];
        BOOL isFloat = [intScanner scanFloat:nil];
        if(isFloat) {
            [_dive.tank setStartingPressure:[NSNumber numberWithFloat:[_tankStartingPressureTxt.text floatValue]]];
        }
    }
}

#pragma mark - Helpers

-(UITextField *) makeTxtField {
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(140, 12, 165, 30)];
    textField.adjustsFontSizeToFitWidth = NO;
    textField.textColor = [self darkBlueTextColor];
    textField.returnKeyType = UIReturnKeyNext;
    textField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords; // no auto capitalization support
    textField.textAlignment = UITextAlignmentRight;
    textField.delegate = self;
    [textField setBackgroundColor:[UIColor clearColor]];
    textField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
    [textField setEnabled: YES];
    return textField;
}

-(BOOL) validateAndSave {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
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
        DebugLog(@"%f", [_diveVisibilityTxt.text floatValue]);
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
    _diveVisibilityTxt = [self makeTxtField];
    _diveVisibilityTxt.keyboardType = UIKeyboardTypeNumberPad;        
    [cell addSubview:_diveVisibilityTxt];        
    if ([_dive visibility]) {
        NSString *visibility = [NSString stringWithFormat:@"%.2f", [_dive.visibility floatValue]];
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
    [cell.textLabel setShadowColor:[UIColor whiteColor]];
    [cell.textLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    _diveAirTempTxt = [self makeTxtField];
    _diveAirTempTxt.keyboardType = UIKeyboardTypeNumberPad;        
    [cell addSubview:_diveAirTempTxt];        
    if ([_dive airTemperature]) {
        NSString *airTemperature = [NSString stringWithFormat:@"%.2f", [_dive.airTemperature floatValue]];
        [_diveAirTempTxt setText:airTemperature];
    }
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    return cell;
}

-(UITableViewCell *) makeWaterTemperatureCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableViewCell Default.png"]];
    [[cell textLabel] setText:@"Water temperature (°F)"];
    [cell.textLabel setShadowColor:[UIColor whiteColor]];
    [cell.textLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    _diveWaterTempTxt = [self makeTxtField];
    _diveWaterTempTxt.keyboardType = UIKeyboardTypeNumberPad;        
    [cell addSubview:_diveWaterTempTxt];        
    if ([_dive waterTemperature]) {
        NSString *waterTemperature = [NSString stringWithFormat:@"%.2f", [_dive.waterTemperature floatValue]];
        [_diveWaterTempTxt setText:waterTemperature];
    }
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    return cell;
}

-(UITableViewCell *) makeDiveTimeCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"UITableViewCell Default.png"]];
    [[cell textLabel] setText:@"Dive Time"];
    _diveTimeTxt = [self makeTxtField];
    _diveTimeTxt.keyboardType = UIKeyboardTypeNumberPad;        
    [cell addSubview:_diveTimeTxt];        
    if ([_dive diveTime]) {
        NSString *diveTime = [NSString stringWithFormat:@"%.2f", [_dive.diveTime floatValue]];
        [_diveTimeTxt setText:diveTime];
    }
    [cell.textLabel setShadowColor:[UIColor whiteColor]];
    [cell.textLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    return cell;
}
@end
