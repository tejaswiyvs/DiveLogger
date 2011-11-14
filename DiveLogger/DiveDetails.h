//
//  DiveDetails.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Dive.h"

@protocol TYDiveDetailsDelegate;
@interface DiveDetails : UITableViewController<UITextFieldDelegate> {
    __unsafe_unretained id<TYDiveDetailsDelegate> _delegate; // ?? TODO - Figure out later. Some ARC issue.
    Dive *_dive;
    NSMutableArray *_tableHeaders;
    BOOL _newDive;
    UITableView *_tableView;
}

@property (nonatomic, retain) Dive *dive;
@property (nonatomic, assign) id<TYDiveDetailsDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *tableHeaders;
@property (nonatomic, assign) BOOL newDive;
@property (nonatomic, retain) IBOutlet UITableView *tableView;

-(id) initWithDive:(Dive *) dive;
-(IBAction)cancelButtonClicked:(id)sender;
-(IBAction)saveButtonClicked:(id)sender;
@end

@protocol TYDiveDetailsDelegate <NSObject>
-(void) didSaveDive:(Dive *) dive;
-(void) didDismissWithoutSaving;
@end
