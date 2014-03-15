//
//  ProfileCell.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/10/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *categoryName;
@property (nonatomic, retain) IBOutlet UILabel *categoryDetail;
@property (nonatomic, retain) IBOutlet UIImageView *img;

@end
