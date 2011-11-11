//
//  ProfileCell.h
//  DiveLogger
//
//  Created by Tejaswi Y on 11/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileCell : UITableViewCell {
    UILabel *_categoryName;
    UILabel *_categoryDetail;
    UIImageView *_img;
}

@property (nonatomic, retain) IBOutlet UILabel *categoryName;
@property (nonatomic, retain) IBOutlet UILabel *categoryDetail;
@property (nonatomic, retain) IBOutlet UIImageView *img;

@end
