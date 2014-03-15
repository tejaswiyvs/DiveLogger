//
//  Settings.h
//  DiveLogger
//
//  Created by Tejaswi Y on 12/5/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : UIViewController

@property (nonatomic, retain) IBOutlet UIButton *connectToFacebookBtn;

- (id)init;
- (IBAction)connectToFacebookClicked:(id)sender;
@end
