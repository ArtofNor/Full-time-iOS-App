//
//  MapViewController.h
//  Fulltime
//
//  Created by Nor Sanavongsay on 9/22/11.
//  Copyright 2011 nawDsign. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AsyncImageView.h"

@protocol MapViewControllerDelegate;

@interface MapViewController : UIViewController {
    id<MapViewControllerDelegate>delegate;
    UIView *mapCase;
    UIButton *mapButton;
    UILabel *locationName;
    AsyncImageView *mapImage;
}

@property (nonatomic, assign) id<MapViewControllerDelegate> delegate;
@property (nonatomic, retain) UIView *mapCase;
@property (nonatomic, retain) UIButton *mapButton;
@property (nonatomic, retain) UILabel *locationName;
@property (nonatomic, retain) AsyncImageView *mapImage;

- (void) loadMapWithLocationData:(NSDictionary *)data;

@end

// create delegate functions
@protocol MapViewControllerDelegate <NSObject>
- (void)showInMap;
@end