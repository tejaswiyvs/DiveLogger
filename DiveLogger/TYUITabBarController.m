//
//  TYUITabBarController.m
//  DiveLogger
//
//  Created by Tejaswi Y on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TYUITabBarController.h"

@implementation TYUITabBarController

-(void) viewDidLoad {
    [super viewDidLoad];
    CGRect frame = CGRectMake(0.0, 0.0, 320.0, 66.0);
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:frame];
    [bgImg setImage:[UIImage imageNamed:@"CustomUITabBarController.png"]];
    [[self tabBar] addSubview:bgImg];
}
@end
