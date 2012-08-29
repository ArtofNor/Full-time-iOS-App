//
//  PullRefreshTableViewController.m
//  Plancast
//
//  Created by Leah Culver on 7/2/10.
//  Copyright (c) 2010 Leah Culver
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

// THIS FILE WAS MODIFIED MY NOR SANAVONGSAY :)

#import <QuartzCore/QuartzCore.h>
#import "PullRefreshTableViewController.h"

#define REFRESH_HEADER_HEIGHT 80.0f
#define REFRESH_HEADER_OFFSET 400.0f

@implementation PullRefreshTableViewController

@synthesize textPull, textRelease, textLoading, refreshHeaderView, refreshLabel,refreshSpinner;
@synthesize logo;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self != nil) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    textPull    = [[NSString alloc] initWithString:@"PULL DOWN"];
    textRelease = [[NSString alloc] initWithString:@"RELEASE"];
    textLoading = [[NSString alloc] initWithString:@"LOADING..."];
    [self addPullToRefreshHeader];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT - REFRESH_HEADER_OFFSET, self.tableView.bounds.size.width, REFRESH_HEADER_HEIGHT + REFRESH_HEADER_OFFSET)];
    refreshHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"fabric_blue_stripe.png"]];
    refreshHeaderView.clipsToBounds = YES;
    refreshHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    refreshLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 50 + REFRESH_HEADER_OFFSET, self.tableView.bounds.size.width, 20)];
    refreshLabel.backgroundColor = [UIColor clearColor];
    refreshLabel.font		= [UIFont fontWithName:@"Helvetica Neue" size:12.0];
    refreshLabel.font = [UIFont boldSystemFontOfSize:12.0];
    refreshLabel.shadowColor = [UIColor darkGrayColor];
    refreshLabel.shadowOffset = CGSizeMake(0, 1.0);
    refreshLabel.textColor = [UIColor whiteColor];
    refreshLabel.textAlignment = UITextAlignmentCenter;
    refreshLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nawDsign_medal.png"]];
    logo.frame = CGRectMake((self.tableView.bounds.size.width / 2)-(29/2), REFRESH_HEADER_OFFSET - 20, 29, 42.5);

    refreshSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    refreshSpinner.frame = CGRectMake((self.tableView.bounds.size.width / 2)-(20/2),REFRESH_HEADER_OFFSET + 22,20, 20);
    refreshSpinner.hidesWhenStopped = YES;
    refreshSpinner.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
    
    UIImageView *paper = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"paper.png"]];
    paper.contentMode = UIViewContentModeScaleToFill;
    paper.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    paper.frame = CGRectMake(0, REFRESH_HEADER_OFFSET + REFRESH_HEADER_HEIGHT - 10, self.tableView.bounds.size.width, 10);
    
    [refreshHeaderView addSubview:refreshLabel];
    [refreshHeaderView addSubview:logo];
    [refreshHeaderView addSubview:refreshSpinner];
    [refreshHeaderView addSubview:paper];
    [self.tableView addSubview:refreshHeaderView];
    
    [paper release];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.tableView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.tableView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView beginAnimations:nil context:NULL];
        if (scrollView.contentOffset.y < -(REFRESH_HEADER_HEIGHT - 30)) {
            // User is scrolling above the header
            refreshLabel.text = self.textRelease;
            //[refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            
            logo.frame = CGRectMake((self.tableView.bounds.size.width / 2)-(29/2), REFRESH_HEADER_OFFSET + 10, 29, 42.5);
            
        } else { // User is scrolling somewhere within the header
            refreshLabel.text = self.textPull;
            //[refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            
            logo.frame = CGRectMake((self.tableView.bounds.size.width / 2)-(29/2), REFRESH_HEADER_OFFSET - 20, 29, 42.5);
        }
        [UIView commitAnimations];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.tableView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
    refreshLabel.text = self.textLoading;
    logo.alpha = 0;
    [refreshSpinner startAnimating];
    [UIView commitAnimations];
    
    // Refresh action!
    [self refreshFromServer:YES withLoadingAnimation:NO];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDidStopSelector:@selector(stopLoadingComplete:finished:context:)];
    self.tableView.contentInset = UIEdgeInsetsZero;
    //[refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    logo.frame = CGRectMake((self.tableView.bounds.size.width / 2)-(29/2), REFRESH_HEADER_OFFSET + 10, 29, 42.5);
    logo.alpha = 1;
    [UIView commitAnimations];
}

- (void)stopLoadingComplete:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    // Reset the header
    refreshLabel.text = self.textPull;
    logo.alpha = 1;
    [refreshSpinner stopAnimating];
}

- (void)refreshFromServer:(BOOL)isfromserver withLoadingAnimation:(BOOL)isloading {
    // This is just a demo. Override this method with your custom reload action.
    // Don't forget to call stopLoading at the end.
    
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}

- (void)dealloc {
    [super dealloc];
    
    [refreshHeaderView release];
    [refreshLabel release];
    [refreshSpinner release];
    [textPull release];
    [textRelease release];
    [textLoading release];
    [logo release];
}

@end
