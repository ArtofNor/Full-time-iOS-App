//
//  TipsCell.h
//  Fulltime
//
//  Created by Nor Sanavongsay on 10/7/11.
//  Copyright (c) 2011 nawDsign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TipsCell : UITableViewCell{
	UILabel *textLabel;
	UILabel *detailTextLabel;
    UIImageView *infoImage;
}

@property (nonatomic, retain) UILabel *textLabel;
@property (nonatomic, retain) UILabel *detailTextLabel;
@property (nonatomic, retain) UIImageView *infoImage;

@end
