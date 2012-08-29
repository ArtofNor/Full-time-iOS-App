//
//  CategoryCell.m
//  Ajobs
//
//  Created by Nor Sanavongsay on 8/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CategoryCell.h"

#import "FontLabel.h"
#import "FontLabelStringDrawing.h"
#import "FontManager.h"

@implementation CategoryCell

@synthesize radiobutton, textLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        textLabel       = [[[UILabel alloc] init] autorelease];
        textLabel.font  = [UIFont fontWithName:@"Helvetica Neue" size:16.0];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor = [UIColor lightGrayColor];
        textLabel.shadowColor = [UIColor colorWithWhite:0.1 alpha:0.900];
        textLabel.shadowOffset = CGSizeMake(0,1.0);
        [self addSubview:textLabel];
        
        radiobutton = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"radiobutton_off.png"]] autorelease];
        [self addSubview:radiobutton];
        
        self.selectedBackgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellSelected.png"]] autorelease];
    }
    return self;
}


- (void)layoutSubviews
{
	[super layoutSubviews];
    CGRect contentRect = [self.contentView bounds];
    textLabel.frame = CGRectMake(contentRect.origin.x + 50.0, 0.0, contentRect.size.width-15.0, contentRect.size.height);
    radiobutton.frame  = CGRectMake(18.0,(contentRect.size.height/2)-(radiobutton.frame.size.height/2), 15.0, 15.0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
	textLabel.highlightedTextColor	= [UIColor whiteColor];
    textLabel.shadowOffset = CGSizeMake(0, 0);
}

- (void)dealloc
{
    [super dealloc];
}

@end
