//
//  MyAnnotation.h
//  Fulltime
//
//  Created by Jose Fonseca on 3/22/12.
//  Copyright (c) 2012 nawDsign. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>

@interface MyAnnotation : NSObject<MKAnnotation> {
	CLLocationCoordinate2D	coord;
	CLLocationCoordinate2D	coordinate;
    int           uId;
    NSString*				selId;
	NSString*				title;
	NSString*				subtitle;
    NSNumber*               latitude;
    NSNumber*               longitude;
}

@property (nonatomic, assign)	CLLocationCoordinate2D	coordinate;
@property (nonatomic, assign)   int                     uId;
@property (nonatomic, copy)		NSString*				selId;
@property (nonatomic, copy)		NSString*				title;
@property (nonatomic, copy)		NSString*				subtitle;
@property (nonatomic, retain)   NSNumber*               latitude;
@property (nonatomic, retain)   NSNumber*               longitude;

@property (nonatomic, readonly) CLLocationCoordinate2D coord;
@end
