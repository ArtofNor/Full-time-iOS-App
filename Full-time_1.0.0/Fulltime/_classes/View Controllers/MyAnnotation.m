//
//  MyAnnotation.m
//  Fulltime
//
//  Created by Jose Fonseca on 3/22/12.
//  Copyright (c) 2012 nawDsign. All rights reserved.
//

#import "MyAnnotation.h"


@implementation MyAnnotation

@synthesize title;
@synthesize subtitle;
@synthesize coordinate;
@synthesize latitude, longitude, selId, uId;

- (void)dealloc 
{
	[super dealloc];
	self.title = nil;
	self.subtitle = nil;
}

- (CLLocationCoordinate2D)coord
{
    
    coord.latitude  = [self.latitude doubleValue];;
    coord.longitude = [self.longitude doubleValue];;
    return coord;
}
@end