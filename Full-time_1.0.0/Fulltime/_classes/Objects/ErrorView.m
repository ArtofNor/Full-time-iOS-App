//
//  ErrorView.m
//  Fulltime
//
//  Created by Nor Sanavongsay on 12/4/11.
//  Copyright (c) 2011 nawDsign. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "ErrorView.h"

@implementation ErrorView

@synthesize textLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = NO;
        self.layer.cornerRadius = 8.0;
        self.layer.shadowOpacity = 0.65;
        self.layer.shadowRadius = 5.0;
        self.layer.shadowOffset = CGSizeMake(0,1.0);
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.borderWidth = 2;
        self.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.0] CGColor];
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_grid.png"]];
        
		// Title
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 15, frame.size.width-30, frame.size.height-30)];
        textLabel.font            = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
        textLabel.shadowColor     = [UIColor colorWithWhite:1.0 alpha:0.900];
        textLabel.textAlignment   = UITextAlignmentCenter;
        textLabel.shadowOffset    = CGSizeMake(0,1.0);
		textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textColor       = [UIColor colorWithWhite:0.600 alpha:1.000];
        textLabel.numberOfLines   = 4.0;
        [self addSubview:textLabel];
    }
    return self;
}

- (void)errorWithString:(NSString *)string{
    textLabel.text = string;
}

- (void)errorWithError:(NSError *)error{
    NSString *string = [NSString stringWithFormat:@"%@",[error localizedDescription]];
    textLabel.text = string;
}

@end
