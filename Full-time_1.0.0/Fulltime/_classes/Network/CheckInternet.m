//
//  CheckInternet.m
//  Ajobs
//
//  Created by Nor Sanavongsay on 4/21/11.
//  Copyright 2011 nawDsign. All rights reserved.
//

#import "CheckInternet.h"
#import "Reachability.h"

@implementation CheckInternet

#pragma mark -
#pragma mark Checking Internet Connection

-(BOOL)isAvailable{
	//Test for Internet Connection
	//NSLog(@"Testing Internet Connectivity");
	Reachability *r = [Reachability reachabilityForInternetConnection];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL internet;
	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN)) {
		internet = NO;
	} else {
		internet = YES;
	}
	return internet;
}

@end
