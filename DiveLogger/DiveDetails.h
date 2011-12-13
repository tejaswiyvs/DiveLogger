//
//  DiveDetails.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import "Dive.h"

@protocol TYDiveDetailsDelegate;
@interface DiveDetails : UIViewController<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource> {
    __unsafe_unretained id<TYDiveDetailsDelegate> _delegate; // ?? TODO - Figure out later. Some ARC issue.
    Dive *_dive;
    NSMutableArray *_tableHeaders;
    BOOL _newDive;
    UITableView *_tableView;
    
    // TextFields
    UITextField *_diveNameTxt;
    UITextField *_diveDateTxt;
    UITextField *_diveLocTxt;
    UITextField *_diveTimeTxt;
    UITextField *_tankStartingPressureTxt;
    UITextField *_tankEndingPressureTxt;
    UITextField *_tankAirCompositionTxt;
    UITextField *_diveVisibilityTxt;
    UITextField *_diveAirTempTxt;
    UITextField *_diveWaterTempTxt;
    CLLocationCoordinate2D diveLocation;
}

@property (nonatomic, retain) Dive *dive;
@property (nonatomic, assign) id<TYDiveDetailsDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *tableHeaders;
@property (nonatomic, assign) BOOL newDive;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

@property (nonatomic, retain) UITextField *diveNameTxt;
@property (nonatomic, retain) UITextField *diveDateTxt;
@property (nonatomic, retain) UITextField *diveLocTxt;
@property (nonatomic, retain) UITextField *diveTimeTxt;
@property (nonatomic, retain) UITextField *tankStartingPressureTxt;
@property (nonatomic, retain) UITextField *tankEndingPressureTxt;
@property (nonatomic, retain) UITextField *tankAirCompositionTxt;
@property (nonatomic, retain) UITextField *diveVisibilityTxt;
@property (nonatomic, retain) UITextField *diveAirTempTxt;
@property (nonatomic, retain) UITextField *diveWaterTempTxt;

-(id) initWithDive:(Dive *) dive;
-(IBAction)cancelButtonClicked:(id)sender;
-(IBAction)saveButtonClicked:(id)sender;
@end

@protocol TYDiveDetailsDelegate <NSObject>
-(void) didSaveDive:(Dive *) dive;
-(void) didDismissWithoutSaving;
@end
