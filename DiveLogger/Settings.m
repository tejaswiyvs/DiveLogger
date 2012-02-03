//
//  Settings.m
//  DiveLogger
//
//  Created by Tejaswi Y on 12/5/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import "Settings.h"
#import "TYAppDelegate.h"

@implementation Settings

@synthesize connectToFacebookBtn;

- (id) init {
    self = [super initWithNibName:@"Settings" bundle:nil];
    if(self) {
        [self setTitle:@"Settings"];
        [self.tabBarItem setImage:[UIImage imageNamed:@"settings-icon.png"]];
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
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_active.png"]]];
}

-(void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    TYAppDelegate *appDelegate = (TYAppDelegate *) [UIApplication sharedApplication].delegate;
    if([appDelegate.facebook isSessionValid]) {
        [connectToFacebookBtn setEnabled:NO];
        [connectToFacebookBtn setTitle:@"Connected" forState:UIControlStateNormal];
    }
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

#pragma mark - Event Handler

-(IBAction)connectToFacebookClicked:(id)sender {
    TYAppDelegate *appDelegate = (TYAppDelegate *) [UIApplication sharedApplication].delegate;
    NSArray *permissions = [NSArray arrayWithObjects:@"publish_stream", nil];
    [appDelegate.facebook authorize:permissions];
}

@end
