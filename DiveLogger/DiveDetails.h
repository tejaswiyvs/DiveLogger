//
//  DiveDetails.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import "Dive.h"
#import "TYAppDelegate.h"

@protocol TYDiveDetailsDelegate;
@interface DiveDetails : UITableViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) Dive *dive;
@property (nonatomic) id <TYDiveDetailsDelegate> delegate;
@property (nonatomic) BOOL newDive;
@property (nonatomic, strong) NSManagedObjectContext *diveDetailsContext;
@property (nonatomic, strong) TYAppDelegate *appDelegate;

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) UIBarButtonItem *saveButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UITextField *diveNameTxt;
@property (nonatomic, strong) UITextField *diveDateTxt;
@property (nonatomic, strong) UITextField *diveLocTxt;
@property (nonatomic, strong) UITextField *diveTimeTxt;
@property (nonatomic, strong) UITextField *tankStartingPressureTxt;
@property (nonatomic, strong) UITextField *tankEndingPressureTxt;
@property (nonatomic, strong) UITextField *tankAirCompositionTxt;
@property (nonatomic, strong) UITextField *diveVisibilityTxt;
@property (nonatomic, strong) UITextField *diveAirTempTxt;
@property (nonatomic, strong) UITextField *diveWaterTempTxt;

- (id)initWithDive:(Dive *)dive;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)saveButtonClicked:(id)sender;
- (void)doneButtonClicked:(id)sender;
- (void)postToFBClicked:(id)sender;
- (void)resignFirstResponderForSubviewsOfView:(UIView *)aView;
- (void)animateDatePickerOut;
- (void)animateDatePickerIn;
@end

@protocol TYDiveDetailsDelegate <NSObject>
- (void)didSaveDive:(Dive *)dive inContext:(NSManagedObjectContext *)managedObjectContext;
- (void)didDismissWithoutSaving;
@end
