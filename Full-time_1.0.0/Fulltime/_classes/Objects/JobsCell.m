//
//  JobsCell.m
//  Ajobs
//
//  Created by nawdsign on 3/4/11.
//  Copyright 2011 nawDsign. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "JobsCell.h"

@implementation JobsCell

@synthesize textLabel,detailTextLabel,dateTextLabel,jobtypeTextLabel,locationTextLabel;
@synthesize companyLogo,companyBackImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
		// Company Name
        detailTextLabel           = [[UILabel alloc] initWithFrame:CGRectZero];
        detailTextLabel.font      = [UIFont fontWithName:@"Helvetica Neue" size:12.0];
        detailTextLabel.font      = [UIFont boldSystemFontOfSize:12.0];
		detailTextLabel.backgroundColor = [UIColor clearColor];
        detailTextLabel.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
        [self addSubview:detailTextLabel];
        
		// Job Title
        textLabel			= [[UILabel alloc] initWithFrame:CGRectZero];
        textLabel.font		= [UIFont fontWithName:@"Helvetica Neue" size:16.0];
        textLabel.font      = [UIFont boldSystemFontOfSize:16.0];
        textLabel.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.900];
        textLabel.shadowOffset = CGSizeMake(0,1.0);
		textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
        [self addSubview:textLabel];
        
		// Job Type
        jobtypeTextLabel           = [[UILabel alloc] initWithFrame:CGRectZero];
        jobtypeTextLabel.font      = [UIFont fontWithName:@"Helvetica Neue" size:12.0];
        jobtypeTextLabel.font      = [UIFont boldSystemFontOfSize:12.0];
		jobtypeTextLabel.backgroundColor = [UIColor clearColor];
        jobtypeTextLabel.textColor = [UIColor colorWithWhite:0.200 alpha:1.000];
        [self addSubview:jobtypeTextLabel];
        
		// Date
        dateTextLabel           = [[UILabel alloc] initWithFrame:CGRectZero];
        dateTextLabel.font		= [UIFont fontWithName:@"Helvetica Neue" size:12.0];
        dateTextLabel.textAlignment = UITextAlignmentRight;
		dateTextLabel.backgroundColor = [UIColor clearColor];
        dateTextLabel.textColor = [UIColor colorWithWhite:0.600 alpha:1.000];
        [self addSubview:dateTextLabel];
        
		// Location
        locationTextLabel           = [[UILabel alloc] initWithFrame:CGRectZero];
        locationTextLabel.font		= [UIFont fontWithName:@"Helvetica Neue" size:12.0];
		locationTextLabel.backgroundColor = [UIColor clearColor];
        locationTextLabel.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
        [self addSubview:locationTextLabel];
        
        companyBackImage = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"companyBack.png"]] autorelease];
        [self addSubview:companyBackImage];
        
        companyLogo = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"companyblank.png"]] autorelease];
        [self addSubview:companyLogo];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellSelected.png"]] autorelease];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
    CGRect contentRect = [self.contentView bounds];
	int offset = 80.0;
	detailTextLabel.frame  = CGRectMake(140.0, 8.0, 130.0, 16.0);
	textLabel.frame        = CGRectMake(offset, 24.0, contentRect.size.width - (10.0+offset), 20.0);
    jobtypeTextLabel.frame = CGRectMake(offset, 8.0, contentRect.size.width - (10.0+offset), 16.0);
	dateTextLabel.frame    = CGRectMake(contentRect.size.width - 60, 46.0, 50.0, 16.0);
	locationTextLabel.frame= CGRectMake(offset, 46.0, contentRect.size.width - (50.0+offset), 16.0);
    
    companyBackImage.frame = CGRectMake(10.0,5.0, 60.0, 60.0);
    companyLogo.contentMode = UIViewContentModeScaleAspectFit;
    companyLogo.frame      = CGRectMake(15,10.0,50.0,50.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    textLabel.shadowOffset = CGSizeMake(0,0);
	textLabel.highlightedTextColor			= [UIColor whiteColor];
	jobtypeTextLabel.highlightedTextColor	= [UIColor whiteColor];
	detailTextLabel.highlightedTextColor	= [UIColor whiteColor];
	dateTextLabel.highlightedTextColor      = [UIColor whiteColor];
	locationTextLabel.highlightedTextColor  = [UIColor whiteColor];
}

- (void)dealloc
{
    [super dealloc];
    
    [textLabel release];
    [detailTextLabel release]; 
    [dateTextLabel release];
    [jobtypeTextLabel release];
}

@end
