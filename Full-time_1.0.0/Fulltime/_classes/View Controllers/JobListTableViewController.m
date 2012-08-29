//
//  JobListTableViewController.m
//  Fulltime
//
//  Created by Nor Sanavongsay on 9/1/11.
//  Copyright 2011 nawDsign. All rights reserved.
//

#import "JobListTableViewController.h"
#import "JSON.h"

#import "JobsRecord.h"
#import "JobsCell.h"

#define REFRESH_HEADER_HEIGHT 80.0f

@implementation JobListTableViewController

@synthesize jobs,jobsArray;
@synthesize delegate;
@synthesize currentPage,currentType,currentCategoryId,perPage,userLocation;
@synthesize imageDownloadsInProgress;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil { 
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) { 
        self.jobs = [NSArray array];
        self.jobsArray  = [NSMutableArray array];
        self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    }
    return self; 
}

- (void)dealloc
{
    [super dealloc];
    
    [jobs release];
    [jobsArray release];
    [imageDownloadsInProgress release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return [self.jobs count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"JobsCell";
    
	JobsCell *cell = (JobsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = (JobsCell *)[[[JobsCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
	}
    
    if ([jobs count] > 0) {
        // Set up the cell if there's jobs
        NSDictionary *aJobs   = [self.jobs objectAtIndex:[indexPath row]];
        
        NSDictionary *company = [aJobs objectForKey:@"company"];
        NSString *companyName = [company objectForKey:@"name"];
        //NSString *compId      = [company objectForKey:@"id"];
        NSString *compLogo    = [company objectForKey:@"logo"];
        
        if ([companyName isEqualToString:@""] || companyName==nil) {
            companyName = @"Company Confidential";
        }
        
        NSDictionary *type      = [aJobs objectForKey:@"type"];
        //NSString *companyTypeId = [type objectForKey:@"id"];
        //NSString *description   = [aJobs objectForKey:@"description"];
        NSString *companyType   = [type objectForKey:@"name"];
        NSString *jobLocation      = [[company objectForKey:@"location"] objectForKey:@"city"];
        if ([jobLocation isEqualToString:@""] || jobLocation==nil) {
            jobLocation = @"Anywhere";
        }
        
        NSString *dateStr = [aJobs objectForKey:@"post_date"];
        
        // Convert string to date object
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date = [dateFormat dateFromString:dateStr];
        
        // Convert date object to desired output format
        [dateFormat setDateFormat:@"MMM dd"];
        dateStr = [dateFormat stringFromDate:date];  
        [dateFormat release];
        
        // Only load cached images; defer new downloads until scrolling ends
        if ([self.jobsArray count] > 0) {
            JobsRecord *jR = [self.jobsArray objectAtIndex:indexPath.row];
            if (!jR.companyLogo) {
                if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
                    [self startIconDownload:jR forIndexPath:indexPath];
                }
                // if a download is deferred or in progress, return a placeholder image
                cell.companyLogo.image = [UIImage imageNamed:@"companyblank.png"];
            } else {
                cell.companyLogo.image = jR.companyLogo;
            }
        } else if (compLogo == nil || [compLogo isEqualToString:@""]){
            cell.companyLogo.image = [UIImage imageNamed:@"companyblank.png"];
        }
        
        // change font color
        if ([companyType isEqualToString:@"Full-time"]) {
            cell.jobtypeTextLabel.textColor = [UIColor colorWithRed:0.902 green:0.541 blue:0.125 alpha:1.000];
        } else if ([companyType isEqualToString:@"Contract"]){
            cell.jobtypeTextLabel.textColor = [UIColor colorWithRed:0.165 green:0.486 blue:0.647 alpha:1.000];
        } else if ([companyType isEqualToString:@"Freelance"]){
            cell.jobtypeTextLabel.textColor = [UIColor colorWithRed:0.604 green:0.663 blue:0.008 alpha:1.000];
        } else if ([companyType isEqualToString:@"Internship"]){
            cell.jobtypeTextLabel.textColor = [UIColor colorWithRed:0.722 green:0.333 blue:0.604 alpha:1.000];
        } else {
            cell.jobtypeTextLabel.textColor = [UIColor colorWithWhite:0.400 alpha:1.000];
        }
        
        cell.jobtypeTextLabel.text  = companyType;
        cell.detailTextLabel.text	= companyName;
        cell.textLabel.text         = [aJobs objectForKey:@"title"];
        cell.dateTextLabel.text     = dateStr;
        cell.locationTextLabel.text     = jobLocation;
    }
    
    return cell;
}

- (void)refreshFromServer:(BOOL)isfromserver withLoadingAnimation:(BOOL)isloading
{
    
    self.perPage = [[NSUserDefaults standardUserDefaults] stringForKey:@"perPage"];
    self.userLocation = [[NSUserDefaults standardUserDefaults] stringForKey:@"userLocationId"];
    
    if ([self.currentCategoryId isEqualToString:@"0"]) { self.currentCategoryId = @""; }
    if ([self.userLocation isEqualToString:@"anywhere"]) { self.userLocation = @""; }
    
    if([currentType isEqualToString:@"0"] || [currentType isEqualToString:@""]){
        [self checkForFinishConnection:nil handleError:nil];
    } else {
        if(isfromserver){
            AjobsConnection *AJobsConn = [[AjobsConnection alloc] init];
            
            if([self.delegate respondsToSelector:@selector(initSpinner)] && isloading) {
                [self.delegate initSpinner];
                [self.delegate spinBegin];
            }
            
            [AJobsConn requestJobs:@"json"
                        withMethod:@"aj.jobs.search"
                           location:self.userLocation
                           perPage:self.perPage
                      whatCategory:self.currentCategoryId
                          whatType:@"1,2,3,4"
                          whatPage:self.currentPage];
            [AJobsConn setDelegate:self];
            [AJobsConn release];
        } else {
            NSString *responseString = [[NSUserDefaults standardUserDefaults] stringForKey:@"listing"];
            NSDictionary *results  = [responseString JSONValue];
            NSDictionary *listings = [results objectForKey:@"listings"];
            NSArray      *listing  = [listings objectForKey:@"listing"];
            [self filterJobsWithArray:listing  withError:nil];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.currentType forKey:@"currentType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.jobsArray count] > 0) {
        JobsRecord *jR = [self.jobsArray objectAtIndex:indexPath.row];
        NSDictionary *aJobs   = jR.company;
        if([self.delegate respondsToSelector:@selector(loadDetailViewWithData:andImage:)]) {
            [self.delegate loadDetailViewWithData:aJobs andImage:jR.companyLogo];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)checkForFinishConnection:(NSArray *)jobslisting handleError:(NSError *)error{
    
    [self stopLoading];
    
    if([self.delegate respondsToSelector:@selector(spinEnd)]) {
        [self.delegate spinEnd];
    }
    
    [self filterJobsWithArray:jobslisting withError:error];
}

- (void) filterJobsWithArray:(NSArray *)filterjob withError:(NSError *) error
{
    jobs = nil;
    NSArray *fJobs = [NSArray arrayWithArray:filterjob];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type.id IN %@", [self.currentType componentsSeparatedByString:@","]];
    NSArray *filtered = [fJobs filteredArrayUsingPredicate:predicate];
    jobs = [[NSArray alloc] initWithArray:filtered copyItems:YES];
    
    [self.jobsArray removeAllObjects];
    [imageDownloadsInProgress removeAllObjects];
    
    for (int i=0; i < [jobs count]; i++) {
        JobsRecord *jR = [[[JobsRecord alloc] init] autorelease];
        NSDictionary *aJobs   = [jobs objectAtIndex:i];
        NSDictionary *company = [aJobs objectForKey:@"company"];
        NSString *compLogo    = [company objectForKey:@"logo"];
        NSString *compId      = [company objectForKey:@"id"];
        jR.logoURLString = compLogo;
        jR.companyId = compId;
        jR.company = aJobs;
        [self.jobsArray insertObject:jR atIndex:i];
    }
    
    if ([jobs count] == 0) {
        if (error) {
            [self.delegate loadErrorViewWith:nil orError:error];
        } else {
            if ([self.delegate respondsToSelector:@selector(loadErrorViewWith:orError:)]) {
                [self.delegate loadErrorViewWith:@"No jobs available. Try changing your location preference or different categories." orError:nil];
            }
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(JobsRecord *)jobsRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.jobsRecord = jobsRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([self.jobsArray count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            JobsRecord *jobsRecord = [self.jobsArray objectAtIndex:indexPath.row];
            
            if (!jobsRecord.companyLogo) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:jobsRecord forIndexPath:indexPath];
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        JobsCell *cell = (JobsCell *)[self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        cell.companyLogo.image = iconDownloader.jobsRecord.companyLogo;
    }
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
    if(isLoading)return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

@end
