//
//  ErrorView.h
//  Fulltime
//
//  Created by Nor Sanavongsay on 12/4/11.
//  Copyright (c) 2011 nawDsign. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorView : UIView

@property (nonatomic, retain) UILabel *textLabel;

- (void)errorWithString:(NSString *)string;
- (void)errorWithError:(NSError *)error;

@end
