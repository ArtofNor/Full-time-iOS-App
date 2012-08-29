//
//  SettingsCell.m
//  Fulltime
//
//  Created by Nor Sanavongsay on 10/25/11.
//  Copyright (c) 2011 nawDsign. All rights reserved.
//

#import "SettingsCell.h"

@implementation SettingsCell

@synthesize detailTextLabel,textLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellSelected.png"]] autorelease];
        
        textLabel           = [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.font		= [UIFont fontWithName:@"Helvetica Neue" size:16.0];
        textLabel.font      = [UIFont boldSystemFontOfSize:16.0];
        textLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0];
        textLabel.shadowOffset = CGSizeMake(0,1.0);
		textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor lightGrayColor];
        
        detailTextLabel           = [[UILabel alloc] initWithFrame:CGRectZero];
        detailTextLabel.font      = [UIFont fontWithName:@"Helvetica Neue" size:16.0];
        detailTextLabel.shadowColor = [UIColor colorWithWhite:0.0 alpha:1.0];
        detailTextLabel.shadowOffset = CGSizeMake(0,1.0);
		detailTextLabel.backgroundColor = [UIColor clearColor];
        detailTextLabel.textColor = [UIColor whiteColor];
        
        [self addSubview:detailTextLabel];
        [self addSubview:textLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    CGRect contentRect = [self.contentView bounds];
	int offset = 50.0;
    int textWidth = 100.0;
	textLabel.frame        = CGRectMake(offset, 15.0,textWidth, 20.0);
	detailTextLabel.frame  = CGRectMake(offset + textWidth + 10, 15.0, ((contentRect.size.width - (offset + textWidth + 10)) - 15.0), 20.0);
    
	[super layoutSubviews];
	
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    // Configure the view for the selected state
	textLabel.highlightedTextColor			= [UIColor whiteColor];
    textLabel.shadowOffset = CGSizeMake(0,0);
	detailTextLabel.highlightedTextColor	= [UIColor whiteColor];
    detailTextLabel.shadowOffset = CGSizeMake(0,0);
    
    [super setSelected:selected animated:animated];
}

@end
