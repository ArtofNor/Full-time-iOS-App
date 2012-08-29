//
//  TipsCell.m
//  Fulltime
//
//  Created by Nor Sanavongsay on 10/7/11.
//  Copyright (c) 2011 nawDsign. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TipsCell.h"

@implementation TipsCell

@synthesize textLabel,detailTextLabel,infoImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
		// Title
        textLabel                 = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.font            = [UIFont fontWithName:@"Helvetica Neue" size:18.0];
        textLabel.font            = [UIFont boldSystemFontOfSize:18.0];
        textLabel.shadowColor     = [UIColor colorWithWhite:0 alpha:0.600];
        textLabel.shadowOffset    = CGSizeMake(0,1.0);
		textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor       = [UIColor whiteColor];
        [self addSubview:textLabel];
        
		// Description TEXT
        detailTextLabel           = [[UILabel alloc] initWithFrame:CGRectZero];
        detailTextLabel.font      = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
		detailTextLabel.backgroundColor = [UIColor clearColor];
        detailTextLabel.textColor = [UIColor lightGrayColor];
        [self addSubview:detailTextLabel];
        
        infoImage = [[[UIImageView alloc] init] autorelease];
        infoImage.clipsToBounds = YES;
        infoImage.layer.cornerRadius = 5;
        infoImage.backgroundColor = [UIColor blackColor];
        [self addSubview:infoImage];
        
        self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellSelected.png"]] autorelease];
    }
    return self;
}

- (void)layoutSubviews
{
    CGRect contentRect = [self.contentView bounds];
	
	textLabel.frame        = CGRectMake(65.0, 10.0, contentRect.size.width - 60, 20.0);
	detailTextLabel.frame  = CGRectMake(65.0, 30.0, contentRect.size.width - 60, 16.0);
    
    infoImage.contentMode = UIViewContentModeScaleAspectFill;
    infoImage.frame      = CGRectMake(4.0,4.0,50.0,50.0);
    
	[super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // Configure the view for the selected state
    //detailTextLabel.textColor   = [UIColor whiteColor];
    //textLabel.textColor         = [UIColor whiteColor];
    //textLabel.shadowOffset = CGSizeMake(0,0);
    
    [super setSelected:selected animated:animated];
}

@end
