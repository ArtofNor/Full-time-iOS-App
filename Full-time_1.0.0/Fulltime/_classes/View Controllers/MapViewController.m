//
//  MapViewController.m
//  Fulltime
//
//  Created by Nor Sanavongsay on 9/22/11.
//  Copyright 2011 nawDsign. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "MapViewController.h"
//#import "CheckInternet.h"

#define MAP_GUTTER 10

@implementation MapViewController

@synthesize delegate;
@synthesize mapCase;
@synthesize mapImage,mapButton;
@synthesize locationName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
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
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    
    CGRect mapCaseFrame = CGRectMake(MAP_GUTTER,MAP_GUTTER, self.view.bounds.size.width - (MAP_GUTTER*2), self.view.bounds.size.height - (MAP_GUTTER*2));
    self.mapCase = [[[UIView alloc] initWithFrame:mapCaseFrame] autorelease];
    self.mapCase.backgroundColor = [UIColor whiteColor];
    //self.mapCase.layer.borderColor = [[UIColor colorWithWhite:0.8 alpha:1.000] CGColor];
    //self.mapCase.layer.borderWidth = 1.0;
    self.mapCase.layer.shadowOpacity = 0.30;
    self.mapCase.layer.shadowOffset = CGSizeMake(0,1.0);
    self.mapCase.layer.shadowRadius = 2.0;
    
    CGRect mapImageFrame = CGRectMake(MAP_GUTTER,MAP_GUTTER, self.mapCase.bounds.size.width - ((MAP_GUTTER)*2), self.mapCase.bounds.size.height - ((MAP_GUTTER)*2));
    self.mapImage = [[[AsyncImageView alloc] initWithFrame:mapImageFrame] autorelease];
    self.mapImage.contentMode = UIViewContentModeCenter;
    self.mapImage.backgroundColor = [UIColor colorWithWhite:0.937 alpha:1.000];
    
    self.locationName = [[[UILabel alloc] initWithFrame:CGRectMake(10,10, self.mapImage.bounds.size.width, 30)] autorelease];
    self.locationName.font  = [UIFont fontWithName:@"Helvetica Neue" size:15.0];
    self.locationName.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    self.locationName.textColor = [UIColor darkGrayColor];
    self.locationName.textAlignment = UITextAlignmentCenter;
    
    self.mapButton = [[[UIButton alloc] initWithFrame:mapCaseFrame] autorelease];
    [self.mapButton setBackgroundImage:[UIImage imageNamed:@"mapfold.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:self.mapCase];
    [self.mapCase addSubview:self.mapImage];
    [self.mapCase addSubview:self.locationName];
    [self.view addSubview:self.mapButton];
    
}

- (void)loadMapWithLocationData:(NSDictionary *)data{
    
    int imageWidth = self.mapImage.bounds.size.width;
    int imageHeight = self.mapImage.bounds.size.height;
    
    NSDictionary *location = [data objectForKey:@"location"];
    NSString *city      = [location objectForKey:@"city"];
    NSString *state     = [location objectForKey:@"state"];
    //NSString *country   = [location objectForKey:@"country"];
    //NSString *locid     = [location objectForKey:@"id"];
    NSString *lat       = [location objectForKey:@"lat"];
    NSString *lng       = [location objectForKey:@"lng"];
    NSString *name      = [location objectForKey:@"name"];
    
    //CheckInternet *checkInternet = [[CheckInternet alloc] init];
    NSString *mapImageName  = nil;
    if ([name isEqualToString:@""] || name==nil) {
        //name = @"Anywhere";
        mapImageName = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?zoom=14&size=%ix%i&maptype=road&sensor=true&markers=Atlantis",imageWidth*2,imageHeight*2];
        
        NSURL *url = [NSURL URLWithString:[mapImageName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self.mapImage loadImageFromURL:url];
    } else {
        if (lat || lng) {
            mapImageName = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?zoom=14&size=%ix%i&maptype=road&sensor=false&markers=%@,%@",imageWidth*2,imageHeight*2,lat,lng];
        } else if (city || state) {
            mapImageName = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?zoom=14&size=%ix%i&maptype=road&sensor=false&markers=%@,%@",imageWidth*2,imageHeight*2,city,state];
        } else {
            mapImageName = [NSString stringWithFormat:@"http://maps.google.com/maps/api/staticmap?zoom=14&size=%ix%i&maptype=road&sensor=false&markers=%@",imageWidth*2,imageHeight*2,name];
        }
        
        self.mapImage.contentMode = UIViewContentModeScaleAspectFill;
        
        NSURL *url = [NSURL URLWithString:[mapImageName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self.mapImage loadImageFromURL:url];
    }
    
    self.locationName.text = city;
    
    [self.mapButton addTarget:self.delegate action:@selector(showInMap) forControlEvents:UIControlEventTouchUpInside];

    //[checkInternet release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.mapCase    = nil;
    self.mapImage   = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
