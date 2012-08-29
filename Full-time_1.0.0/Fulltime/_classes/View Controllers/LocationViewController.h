//
//  LocationViewController.h
//  Fulltime
//
//  Created by Nor Sanavongsay on 11/4/11.
//  Copyright 2011 nawDsign. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AsyncImageView.h"
#import "AjobsConnection.h"
#import "MyAnnotation.h"

@protocol LocationViewControllerDelegate;

@interface LocationViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,AjobsConnectionDelegate, MKMapViewDelegate,CLLocationManagerDelegate>{
    CLLocationManager *lm;
    NSArray *locationItems;
    //MyAnnotation *annotation;
}
@property (retain, nonatomic) CLLocationManager *lm;
@property (nonatomic, retain) NSArray *locationItems;
@property (nonatomic, retain) UILabel *navtitle;
@property (nonatomic, retain) IBOutlet UIView *navBar;
@property (nonatomic, retain) IBOutlet UIView *actionBar;
@property (nonatomic, retain) IBOutlet UIButton *doneButton;
@property (nonatomic, retain) IBOutlet UIButton *locationButton;
@property (nonatomic, retain) IBOutlet UIButton *anyButton;

@property (nonatomic, retain) NSArray *locations;
@property (nonatomic, retain) IBOutlet UITableView *locationTable;
@property (nonatomic, assign) id<LocationViewControllerDelegate> delegate;

@property (nonatomic, retain) UILabel *locationName;

@property (nonatomic, retain) UIButton *btnShowLocation;
@property (nonatomic, retain) IBOutlet MKMapView *mapView;

- (void)closeThisView;
- (void)loadLocationWithData:(NSArray *)data;
- (void)loadMapWithLocationData:(NSString *)data;
- (void)getJobLocations;
- (void)saveEverywhereLocation;

@end

// create delegate functions
@protocol LocationViewControllerDelegate <NSObject>
- (void)locationViewDidFinish:(LocationViewController *)controller;
- (void)loadErrorViewWith:(NSString *)string orError:(NSError *)error;
@end
