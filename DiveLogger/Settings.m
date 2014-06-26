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

- (id)init {
	self = [super initWithNibName:@"Settings" bundle:nil];
	if (self) {
		[self setTitle:@"Settings"];
		[self.tabBarItem setImage:[UIImage imageNamed:@"settings-icon.png"]];
	}
	return self;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark - Event Handler

- (IBAction)connectToFacebookClicked:(id)sender {
}

@end
