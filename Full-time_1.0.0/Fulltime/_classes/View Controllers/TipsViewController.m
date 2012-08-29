//
//  TipsViewController.m
//  Ajobs
//
//  Created by Nor Sanavongsay on 4/17/11.
//  Copyright 2011 nawDsign. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "TipsViewController.h"
#import "TipsCell.h"

#import "FontLabel.h"
#import "FontLabelStringDrawing.h"
#import "FontManager.h"

@implementation TipsViewController

@synthesize delegate;
@synthesize tipsTable;
@synthesize tipsData,tips;
@synthesize tableHeader;
@synthesize blogUrl;

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tipsData = [[[NSMutableDictionary alloc] init] autorelease];
    [self.tipsData setValue:@"A Quick Walkthrough" forKey:@"title"];
    [self.tipsData setValue:@"How to use the app" forKey:@"description"];
    [self.tipsData setValue:@"tips_icon_info.png" forKey:@"image"];
    /* 
     
    // Static Data for testing 
     
    NSMutableDictionary *tips5 = [[[NSMutableDictionary alloc] init] autorelease];
    [tips5 setValue:@"Be Prepared" forKey:@"title"];
    [tips5 setValue:@"For the phone screen" forKey:@"description"];
    [tips5 setValue:@"http://nor.nawdsign.com/2012/05/be-prepared-for-the-interview/" forKey:@"link"];
    [tips5 setValue:@"tips_icon_interview.png" forKey:@"image"];
    NSMutableDictionary *tips2 = [[[NSMutableDictionary alloc] init] autorelease];
    [tips2 setValue:@"Dress Appropriately" forKey:@"title"];
    [tips2 setValue:@"Your first impression counts" forKey:@"description"];
    [tips2 setValue:@"http://nor.nawdsign.com/2012/04/dress-appropriately/" forKey:@"link"];
    [tips2 setValue:@"tips_icon_attire.png" forKey:@"image"];
    NSMutableDictionary *tips3 = [[[NSMutableDictionary alloc] init] autorelease];
    [tips3 setValue:@"API Provided by" forKey:@"title"];
    [tips3 setValue:@"Authentic Jobs" forKey:@"description"];
    [tips3 setValue:@"http://authenticjobs.com/about/" forKey:@"link"];
    [tips3 setValue:@"logo_authenticjobs.png" forKey:@"image"];
    NSMutableDictionary *tips4 = [[[NSMutableDictionary alloc] init] autorelease];
    [tips4 setValue:@"Dedicated To" forKey:@"title"];
    [tips4 setValue:@"Steve Jobs (1955-2011)" forKey:@"description"];
    [tips4 setValue:@"http://nor.nawdsign.com/2011/10/thank-you-steve-jobs/" forKey:@"link"];
    [tips4 setValue:@"logo_stevejobs.png" forKey:@"image"];
    
    self.tips = [NSMutableArray arrayWithObjects:tips5,tips2,self.tipsData,tips4,tips3,nil]; */
    self.tips = [NSMutableArray arrayWithObjects:self.tipsData,nil];
    
    [self.tipsTable reloadData];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor blackColor];
        self.tipsTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_diagnal.png"]];
    }
    return self;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tips count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"TipsCell";
    
	TipsCell *cell = (TipsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = (TipsCell *)[[[TipsCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
	}
    
    NSDictionary *titles = [self.tips objectAtIndex:[indexPath row]];
    
    cell.infoImage.image = [UIImage imageNamed:[titles objectForKey:@"image"]];
    cell.textLabel.text = [titles objectForKey:@"title"];
    cell.detailTextLabel.text = [titles objectForKey:@"description"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([indexPath row] == ([self.tips count] - 3)) {
        [self loadFirstStartView];
    } else {
        self.blogUrl = [NSString stringWithFormat:@"%@", [[self.tips objectAtIndex:indexPath.row ] objectForKey:@"link"]];
        [self loadBlogView];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Walkthrough Views

- (void)loadFirstStartView{
    if([self.delegate respondsToSelector:@selector(hideMainView:whichSide:)]) {
        [self.delegate hideMainView:YES whichSide:@"left"]; 
    }
    
    WalkthroughViewController *controller = [[WalkthroughViewController alloc] initWithNibName:@"WalkthroughViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self presentModalViewController:controller animated:YES];
}

- (void)walkthroughDidFinish:(WalkthroughViewController *)controller{
    
    if([self.delegate respondsToSelector:@selector(hideMainView:whichSide:)]) {
        [self.delegate hideMainView:NO whichSide:@"left"]; 
    }
    
    [self dismissModalViewControllerAnimated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

#pragma mark -
#pragma mark Blog View

- (void)loadBlogView{
    
    if([self.delegate respondsToSelector:@selector(hideMainView:whichSide:)]) {
        [self.delegate hideMainView:YES whichSide:@"left"]; 
    }
    
    WebBrowserViewController *controller = [[WebBrowserViewController alloc] initWithNibName:@"WebBrowserViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    NSURL *url = [NSURL URLWithString:self.blogUrl];
    [controller loadWebViewWithURL:url andTitle:nil];
    [self presentModalViewController:controller animated:YES];
}

- (void) webViewDidFinish:(WebBrowserViewController *)controller{
    if([self.delegate respondsToSelector:@selector(hideMainView:whichSide:)]) {
        [self.delegate hideMainView:NO whichSide:@"left"]; 
    } 
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self dismissModalViewControllerAnimated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)loadErrorViewWith:(NSString *)string orError:(NSError *)error{

}

- (void)removeError{
    
}

- (void)dealloc
{
    [tipsTable release];
    [tableHeader release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.tipsTable = nil;
    self.tableHeader = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
