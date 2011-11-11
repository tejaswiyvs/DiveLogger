//
//  HomeCell.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCell : UITableViewCell
{
    UILabel *diveName;
    UILabel *diveDate;
}

@property (nonatomic, retain) IBOutlet UILabel *diveName;
@property (nonatomic, retain) IBOutlet UILabel *diveDate;

@end
