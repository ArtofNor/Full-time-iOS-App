//
//  LocationViewController.m
//  Fulltime
//
//  Created by Nor Sanavongsay on 11/4/11.
//  Copyright 2011 nawDsign. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "JSON.h"
#import "MyAnnotation.h"
#import "LocationViewController.h"
#import "LocationCell.h"

#define MAP_GUTTER 0
#define MAP_BORDER 0
#define MAP_HEIGHT 160
#define MAP_Y 44

#define METERS_PER_MILE 1609.344
#define MAP_MILE_VIEW 10.0

@implementation LocationViewController

@synthesize delegate;
@synthesize locations;
@synthesize locationTable;
@synthesize navBar,actionBar,navtitle,doneButton,locationButton,anyButton;
@synthesize locationName;
@synthesize mapView, btnShowLocation, lm, locationItems;

- (void) closeThisView{
    if([self.delegate respondsToSelector:@selector(locationViewDidFinish:)]) {
        [self.delegate locationViewDidFinish:self];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.clipsToBounds = YES;
        self.view.layer.cornerRadius = 6.0;
    }
    return self;
}

- (void)dealloc
{
    [self.mapView.userLocation removeObserver:self forKeyPath:@"location"];
    [self.mapView removeFromSuperview]; // release crashes app
    self.mapView = nil;
    
    [super dealloc];
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
    
    self.navBar.layer.shadowOpacity = 0;
    self.navBar.layer.shadowRadius = 0;
    self.navBar.layer.shadowOffset = CGSizeMake(0,1);
    self.navBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navBar.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
    
    // Do any additional setup after loading the view from its nib.
    self.navtitle = [[[UILabel alloc] initWithFrame:CGRectMake(10, 7, 200,15)] autorelease];
    self.navtitle.font = [UIFont fontWithName:@"Helvetica Neue" size:10.0f];
    //self.navtitle.font = [UIFont boldSystemFontOfSize:16.0f];
    self.navtitle.backgroundColor = [UIColor clearColor];
    self.navtitle.textColor = [UIColor lightGrayColor];
    self.navtitle.shadowOffset = CGSizeMake(0,1.0);
    self.navtitle.shadowColor = [UIColor colorWithWhite:1.0 alpha:0.4];
    self.navtitle.text = @"Selected Location";
    [self.navBar addSubview:self.navtitle];
    
    self.actionBar.layer.shadowOpacity = 0.3;
    self.actionBar.layer.shadowRadius = 2.0;
    self.actionBar.layer.shadowOffset = CGSizeMake(0,1);
    self.actionBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    
    self.locationTable.alpha = 0;
    
    [self.doneButton addTarget:self action:@selector(closeThisView) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *bluebuttonImage = [[UIImage imageNamed:@"button_shell_blue.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
    UIImage *bluebuttonPressedImage = [[UIImage imageNamed:@"button_shell_blue_pressed.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
    [self.anyButton setBackgroundImage:bluebuttonImage forState:UIControlStateNormal];
    [self.anyButton setBackgroundImage:bluebuttonPressedImage forState:UIControlStateHighlighted];
    [self.anyButton addTarget:self action:@selector(saveEverywhereLocation) forControlEvents:UIControlEventTouchUpInside];
    
    [self.locationButton addTarget:self action:@selector(centerToUserLocation) forControlEvents:UIControlEventTouchUpInside];
    
    self.locationName = [[[UILabel alloc] initWithFrame:CGRectMake(10, 18, 280,25)] autorelease];
    self.locationName.font  = [UIFont fontWithName:@"Helvetica Neue" size:15.0];
    self.locationName.textColor = [UIColor darkGrayColor];
    self.locationName.backgroundColor = [UIColor clearColor];
    [self.navBar addSubview:self.locationName];
    
    //START INIT MAPS AND INTERACTION HERE
    mapView.delegate = self;    
    mapView.mapType = MKMapTypeStandard;
    MKCoordinateSpan span;
    span.latitudeDelta = 1.04*(126.766667 - 66.95);
    span.longitudeDelta = 1.04*(49.384472 - 24.520833);
    
    CLLocationCoordinate2D location;
    location.latitude = 37.250556;
    location.longitude = -96.358333;
    
    MKCoordinateRegion region;
    region.span = span;
    region.center = location;
    
    [mapView setRegion:region animated:NO];
    [mapView regionThatFits:region];
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] 
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
    [lpgr release];
    //END INIT MAPS AND INTERACTION HERE
    
    [self loadMapWithLocationData:[[NSUserDefaults standardUserDefaults] stringForKey:@"userLocation"]];
    [self getJobLocations];
}

-(void)centerToUserLocation {       
    MKCoordinateRegion region;
    region.center = self.mapView.userLocation.coordinate;  
    
    MKCoordinateSpan span; 
    span.latitudeDelta  = 0.5; // Change these values to change the zoom
    span.longitudeDelta = 0.5; 
    region.span = span;
    
    [self.mapView setRegion:region animated:YES];
    [self.locationTable scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
}

- (void)saveThisLocation:(NSDictionary *)thislocation {
    //NSString *currentLocation = [[NSUserDefaults standardUserDefaults] stringForKey:@"userLocation"];
    NSString *currentLocationId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userLocationId"];
    if (![currentLocationId isEqualToString:[thislocation objectForKey:@"id"]]) {
        [[NSUserDefaults standardUserDefaults] setObject:[thislocation objectForKey:@"name"] forKey:@"userLocation"];
        [[NSUserDefaults standardUserDefaults] setObject:[thislocation objectForKey:@"id"] forKey:@"userLocationId"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"changeSetting"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self loadMapWithLocationData:[thislocation objectForKey:@"name"]];
    }
    [self closeThisView];
}

- (void)saveEverywhereLocation {
    mapView.showsUserLocation = YES;   
    
    NSLog(@"locationItems   >>>>>  %@", locationItems);
    NSString *currentLocationId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userLocationId"];
    if (![currentLocationId isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"Anywhere" forKey:@"userLocation"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userLocationId"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"changeSetting"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self loadMapWithLocationData:@"Anywhere"];
    }
    [self closeThisView];
}

- (void)getJobLocations {
    /*if ([[NSUserDefaults standardUserDefaults] stringForKey:@"locations"]) {
        NSString *responseString = [[NSUserDefaults standardUserDefaults] stringForKey:@"locations"];
        NSDictionary *results  = [responseString JSONValue];
        NSDictionary *listings = [results objectForKey:@"locations"];
        NSArray      *listing  = [listings objectForKey:@"location"];
        [self loadLocationWithData:listing];
    } else {*/
        AjobsConnection *AJobsConn = [[AjobsConnection alloc] init];
        [AJobsConn requestLocation:@"json"
                    withMethod:@"aj.jobs.getLocations"];
        [AJobsConn setDelegate:self];
        [AJobsConn release];
    //}
}

- (void)checkForFinishConnection:(NSArray *)jobslisting handleError:(NSError *)error{
    if (error) {
        [self.delegate loadErrorViewWith:nil orError:error];
    } else {
        [self loadLocationWithData:jobslisting];
    }
}

- (void)loadMapWithLocationData:(NSString *)data{
    self.locationName.text = data;
    [self.locationTable reloadData];
}



- (void) loadLocationWithData:(NSArray *)data {
    self.locations = data;
    locationItems = data;
    
    [self addAllItemsToMap];
    [self.locationTable reloadData];

    [UIView animateWithDuration:0.3 delay:0.2 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.locationTable.alpha = 1;
    } completion:^(BOOL finished) {}];
    
}

- (void)viewDidUnload
{
    [mapView release];
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
    return [self.locations count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell"; 
    
	LocationCell *cell = (LocationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = (LocationCell *)[[[LocationCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier] autorelease];
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    
    NSString *currentLocationId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userLocationId"];
    NSDictionary *location = [self.locations objectAtIndex:indexPath.row];
    if ([[location objectForKey:@"name"] length] == 0) {
        cell.textLabel.text = @"Unspecified Location";
    } else {
        cell.textLabel.text = [location objectForKey:@"name"];
    }
    
    if ([currentLocationId isEqualToString:[location objectForKey:@"id"]]) {
        cell.icon.image = [UIImage imageNamed:@"map_icon.png"];
    } else {
        cell.icon.image = [UIImage imageNamed:@"pin.png"];
    }
    
    return cell; 
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self saveThisLocation:[self.locations objectAtIndex:indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Start Map Code
-(void)addAllItemsToMap {
    
    for (id<MKAnnotation> annotation in mapView.annotations) {
        [mapView removeAnnotation:annotation];
    }
    int i;
    for (i = 0; i < [locationItems count]; i++) {
        id latId = [[locationItems objectAtIndex:i] objectForKey:@"lat"];
        id lngId = [[locationItems objectAtIndex:i] objectForKey:@"lng"];
        CLLocationCoordinate2D location;
        NSString *selId = [NSString stringWithFormat:@"%@",[[locationItems objectAtIndex:i] objectForKey:@"id"]];
        NSString *city = [NSString stringWithFormat:@"%@",[[locationItems objectAtIndex:i] objectForKey:@"city"]];
        NSString *lat = [NSString stringWithFormat:@"%@",[[locationItems objectAtIndex:i] objectForKey:@"lat"]];
        NSString *lng = [NSString stringWithFormat:@"%@",[[locationItems objectAtIndex:i] objectForKey:@"lng"]];
        
        // set our latitude and longitude based on the two chunks in the string
        location.latitude = [latId doubleValue];//[[[NSNumber alloc] initWithDouble:[latId doubleValue]] autorelease];
        location.longitude = [lngId doubleValue];//[[[NSNumber alloc] initWithDouble:[lngId doubleValue]] autorelease];
        MyAnnotation* myAnnotation=[[MyAnnotation alloc] init];
        myAnnotation.uId        = i;
        myAnnotation.coordinate = location;
        myAnnotation.latitude   = latId;
        myAnnotation.longitude  = lngId;
        myAnnotation.selId      = selId;
        myAnnotation.title      = [NSString stringWithFormat:@"%@", city];
        myAnnotation.subtitle   = [NSString stringWithFormat:@"Lat: %@. Lng: %@", lat, lng];
        [mapView addAnnotation:myAnnotation];
    }
}

#pragma mark - MAP Events
//Used to calculate the distance for zoom
- (double)MilesToMeters:(float)miles
{
    return 1609.344f * miles;
}

// distance between 2 points
- (double)distanceFrom:(CLLocationCoordinate2D)fromLoc to:(CLLocationCoordinate2D)toLoc
{
    double R = 6371.0;//3963.0;//6368500.0; // in meters
    
    double lat1 = fromLoc.latitude*M_PI/180.0;
    double lon1 = fromLoc.longitude*M_PI/180.0;
    double lat2 = toLoc.latitude*M_PI/180.0;
    double lon2 = toLoc.longitude*M_PI/180.0;
    
    double distanceFromTo = acos(sin(lat1) * sin(lat2) + 
                                 cos(lat1) * cos(lat2) *
                                 cos(lon2 - lon1)) * R;
    NSLog(@"DISTANCE  >>>>>>   %f",distanceFromTo);
    

    return acos(sin(lat1) * sin(lat2) + 
                cos(lat1) * cos(lat2) *
                cos(lon2 - lon1)) * R;
}

-(void)mapView:(MKMapView *)mView regionWillChangeAnimated:(BOOL)animated {	
    //MKCoordinateRegion region = mView.region;
    //NSLog(@"%f",region.span.latitudeDelta);
    //NSLog(@"%f",region.span.longitudeDelta);    	
}

- (void)mapView:(MKMapView *)mView didSelectAnnotationView:(MKAnnotationView *)view
{
    
    MyAnnotation *selectedAnnotation = view.annotation; // This will give the annotation.
    CLLocationCoordinate2D location = selectedAnnotation.coord;
    NSLog(@"didSelectAnnotationView %@", selectedAnnotation.title);
    NSLog(@"SELECTED ID %@", selectedAnnotation.selId);
    NSLog(@"coordinates %f", location.latitude);
    
    [self saveThisLocation:[self.locations objectAtIndex:selectedAnnotation.uId]];
    
    // Zoom into position
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = selectedAnnotation.coordinate.latitude;
    zoomLocation.longitude= selectedAnnotation.coordinate.longitude;
    // distance to display
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location, [self MilesToMeters:MAP_MILE_VIEW], [self MilesToMeters:MAP_MILE_VIEW]);
    // Help fit it into the view
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];                
    // Animate it to location
    [mapView setRegion:adjustedRegion animated:YES]; 

}

-(MKAnnotationView *)mapView:(MKMapView *)mView viewForAnnotation:(id)annotation
{
    static NSString *jobsAnnotationIdentifier = @"JobsAnnotationIdentifier";
    
    if([annotation isKindOfClass:[MyAnnotation class]]){
        //Try to get an unused annotation, similar to uitableviewcells
        MKAnnotationView *annotationView=[mView dequeueReusableAnnotationViewWithIdentifier:jobsAnnotationIdentifier];
        //If one isn't available, create a new one
        if(!annotationView){
            annotationView=[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:jobsAnnotationIdentifier];
            //Here's where the magic happens
            annotationView.image=[UIImage imageNamed:@"pin_job.png"];
        }
        return annotationView;
    }
    return nil;
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];   
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    double far = [self distanceFrom:mapView.userLocation.coordinate to:touchMapCoordinate];
    NSLog(@"How far is it %f", far);
    NSLog(@"touchMapCoordinatetouchMapCoordinatetouchMapCoordinate %f", touchMapCoordinate.latitude);
}

#pragma mark - Dragging Scroll View

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self updateMapHeight:scrollView];
    [self updateShadows:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateMapHeight:scrollView];
    [self updateShadows:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self updateMapHeight:scrollView];
    [self updateShadows:scrollView];
}

- (void)updateShadows:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > 0) {
        if (scrollView.contentOffset.y >= 10) {
            self.navBar.layer.shadowOpacity = 0.3;
            self.navBar.layer.shadowRadius  = 4.0;
        } else if (scrollView.contentOffset.y < 10) {
            self.navBar.layer.shadowOpacity = (scrollView.contentOffset.y / 10)* 0.3;
            self.navBar.layer.shadowRadius  = (scrollView.contentOffset.y / 10)* 4.0;
        }
        self.navBar.layer.borderWidth = 0;
    } else if (scrollView.contentOffset.y <= 0){
        self.navBar.layer.shadowOpacity = 0;
        self.navBar.layer.shadowRadius = 0;
    }
}

- (void)updateMapHeight:(UIScrollView *)scrollView{
    int width = self.view.bounds.size.width;
    int maxheight = 150;
    int currentheight = maxheight;
    if (scrollView.contentOffset.y <= 0) {
        if (currentheight < maxheight) {
            self.mapView.frame = CGRectMake(0,0, width,maxheight);
        } else {
            currentheight += abs(scrollView.contentOffset.y);
            self.mapView.frame = CGRectMake(0,scrollView.contentOffset.y , width, currentheight);
        }
    }
}

@end
