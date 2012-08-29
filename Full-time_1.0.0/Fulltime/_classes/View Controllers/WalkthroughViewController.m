//
//  WalkthroughViewController.m
//  Ajobs
//
//  Created by Nor Sanavongsay on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "WalkthroughViewController.h"

#import "FontLabel.h"
#import "FontLabelStringDrawing.h"
#import "FontManager.h"

const CGFloat kScrollObjWidth	= 320.0;
const CGFloat kScrollObjHeight	= 400.0;

@implementation WalkthroughViewController

@synthesize delegate;
@synthesize scrollView;
@synthesize pageControl;
@synthesize navtitle,navtitleShadow,description;
@synthesize doneButton;
@synthesize walkthroughInfo;

- (void) closeThisView{
    if([self.delegate respondsToSelector:@selector(walkthroughDidFinish:)]) {
        [self.delegate walkthroughDidFinish:self];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.clipsToBounds = YES;
        self.view.layer.cornerRadius = 6.0;
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgrounddark.png"]];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [delegate release];
    [description release];
    [pageControl release];
    [scrollView release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navtitleShadow = [[[FontLabel alloc] initWithFrame:CGRectMake(75, 9, 170,30) fontName:@"aventura" pointSize:24.0f] autorelease];
    self.navtitleShadow.backgroundColor = [UIColor clearColor];
    self.navtitleShadow.textColor = [UIColor blackColor];
    self.navtitleShadow.textAlignment = UITextAlignmentCenter;
    self.navtitleShadow.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.navtitleShadow.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.navtitleShadow];
    
	self.navtitle = [[[FontLabel alloc] initWithFrame:CGRectMake(75, 8,170,30) fontName:@"aventura" pointSize:24.0f] autorelease];
    self.navtitle.backgroundColor = [UIColor clearColor];
    self.navtitle.textColor = [UIColor whiteColor];
    self.navtitle.textAlignment = UITextAlignmentCenter;
    self.navtitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.navtitle.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:self.navtitle];
    
    [self.doneButton addTarget:self action:@selector(closeThisView) forControlEvents:UIControlEventTouchUpInside];
    
	CGFloat kwidth = kScrollObjWidth;
	//CGFloat kheight = kScrollObjHeight;
    
	NSString *path = [[NSBundle mainBundle] pathForResource:@"walkthrough" ofType:@"plist"];
	self.walkthroughInfo = [[[NSMutableDictionary alloc] initWithContentsOfFile:path] autorelease];
    
    self.pageControl.hidesForSinglePage = YES;
    self.pageControl.defersCurrentPageDisplay = YES;
    self.pageControl.enabled = YES;
    self.pageControl.userInteractionEnabled = YES;
    self.pageControl.numberOfPages = [walkthroughInfo count];
    [self.pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    CGFloat curXLoc = 0;
    for (int i=0; i<[self.walkthroughInfo count]; i++) {
        NSString *objectKey = [NSString stringWithFormat:@"page%i",i+1];
		NSString *imageName		= [[self.walkthroughInfo objectForKey:objectKey] objectForKey:@"imageName"];
		UIImageView *helpImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        
        CGRect frame    = helpImageView.frame;
        int frameWidth = helpImageView.frame.size.width;
        int frameHeight = helpImageView.frame.size.height;
        int scrollframeWidth = self.scrollView.frame.size.width;
        int scrollframeHeight = self.scrollView.frame.size.height;
        frame.origin = CGPointMake(curXLoc+((scrollframeWidth/2)-(frameWidth/2)),((scrollframeHeight/2)-(frameHeight/2)));
        helpImageView.frame = frame;
        
        curXLoc += (kScrollObjWidth);
        
        [self.scrollView addSubview:helpImageView];
        [helpImageView release];
    }
    
	// set the content size so it can be scrollable
	[self.scrollView setContentSize:CGSizeMake(([self.walkthroughInfo count] * kwidth), [scrollView bounds].size.height)];
	self.scrollView.delegate = self;
    
    [self setHelpInfo];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.delegate = nil;
    self.description = nil;
    self.pageControl = nil;
    self.scrollView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Scrolling Paging
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
	[self.pageControl updateCurrentPageDisplay];
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    pageControlUsed = NO;
    [self setHelpInfo];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)sender willDecelerate:(BOOL)decelerate {
	pageControlUsed = NO;
    [self setHelpInfo];
}

- (void)changePage:(id)sender {
    int page = pageControl.currentPage;
    
    // update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
	
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
	[self.pageControl updateCurrentPageDisplay];
    
    [self setHelpInfo];
}

- (void)setHelpInfo {
    int page = pageControl.currentPage;
    
    NSString *helpPage = [NSString stringWithFormat:@"page%i",(page+1)];
	
    self.navtitle.text = [[walkthroughInfo objectForKey:helpPage] objectForKey:@"title"];
    self.navtitleShadow.text = [[walkthroughInfo objectForKey:helpPage] objectForKey:@"title"];
    self.description.text = [[walkthroughInfo objectForKey:helpPage] objectForKey:@"description"];
}

@end
