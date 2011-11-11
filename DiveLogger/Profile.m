//
//  Profile.m
//  DiveLogger
//
//  Created by Tejaswi Y on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Profile.h"

@implementation Profile

-(id) init {
    self = [super initWithNibName:@"Profile" bundle:nil];
    if(self) {
        [self setTitle:@"My Profile"];
    }
    [[self tabBarItem] setImage:[UIImage imageNamed:@"user.png"]];
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

@end
