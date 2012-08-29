//
//  LocationCell.m
//  Fulltime
//
//  Created by Nor Sanavongsay on 12/15/11.
//  Copyright (c) 2011 nawDsign. All rights reserved.
//

#import "LocationCell.h"

@implementation LocationCell

@synthesize textLabel,icon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellSelected.png"]] autorelease];
        
        textLabel           = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.font		= [UIFont fontWithName:@"Helvetica Neue" size:16.0];
		textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
        [self addSubview:textLabel];
        
        icon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pin.png"]] autorelease];
        [self addSubview:icon];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
    CGRect contentRect = [self.contentView bounds];
    textLabel.frame = CGRectMake(contentRect.origin.x + 35.0, 0.0, contentRect.size.width-60.0, contentRect.size.height);
    icon.frame  = CGRectMake(8.0,(contentRect.size.height/2)-(icon.frame.size.height/2)+1, 20, 20);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // Configure the view for the selected state
	textLabel.highlightedTextColor	= [UIColor whiteColor];
    textLabel.shadowOffset = CGSizeMake(0, 0);
    
    [super setSelected:selected animated:animated];
}

@end
