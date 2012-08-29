//
//  JobsCell.h
//  Ajobs
//
//  Created by nawdsign on 3/4/11.
//  Copyright 2011 nawDsign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JobsCell : UITableViewCell{
	UILabel *textLabel;
	UILabel *detailTextLabel;
	UILabel *dateTextLabel;
	UILabel *jobtypeTextLabel;
	UILabel *locationTextLabel;
    UIImageView *companyLogo;
    UIImageView *companyBackImage;
}

@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) UILabel *detailTextLabel;
@property (nonatomic, retain) UILabel *dateTextLabel;
@property (nonatomic, retain) UILabel *jobtypeTextLabel;
@property (nonatomic, retain) UILabel *locationTextLabel;
@property (nonatomic, retain) UIImageView *companyLogo;
@property (nonatomic, retain) UIImageView *companyBackImage;

@end
