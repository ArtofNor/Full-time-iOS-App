//
//  CategoryCell.h
//  Ajobs
//
//  Created by Nor Sanavongsay on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CategoryCell : UITableViewCell {
    UIImageView *radiobutton;
	UILabel *textLabel;
}


@property (nonatomic, retain) UIImageView *radiobutton;
@property (nonatomic, retain) UILabel *textLabel;

@end
