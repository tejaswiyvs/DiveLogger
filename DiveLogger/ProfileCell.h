//
//  ProfileCell.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/10/11.
//  Copyright (c) 2011 Tejaswi Yerukalapudi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *categoryName;
@property (nonatomic, strong) IBOutlet UILabel *categoryDetail;
@property (nonatomic, strong) IBOutlet UIImageView *img;

@end
