//
//  HomeCell.m
//  DiveLogger
//
//  Created by Tejaswi Y on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "HomeCell.h"

@implementation HomeCell

@synthesize diveName;
@synthesize diveDate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
