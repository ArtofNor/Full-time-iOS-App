//
//  AjobsConnection.m
//  Ajobs
//
//  Created by Nor Sanavongsay2 on 3/9/11.
//  Copyright 2011 nawDsign. All rights reserved.
//

#import "AjobsConnection.h"
#import "JSON.h"

// GET API at http://www.authenticjobs.com/api/
#define ajapi @"Enter API here"

@implementation AjobsConnection

@synthesize delegate;

- (void)requestJobs:(NSString *)format 
       withMethod:(NSString *)method  
          location:(NSString *)location 
          perPage:(NSString *)perpage  
       whatCategory:(NSString *)category
         whatType:(NSString *)type  
         whatPage:(NSString *)page
{
	responseData    = [[NSMutableData data] retain];
    
    NSString *getThis;
    if ([location isEqualToString:@""]) {
        getThis = [NSString stringWithFormat:@"http://www.authenticjobs.com/api/?api_key=%@&format=%@&method=%@&page=%@&perpage=%@&type=%@&category=%@",ajapi,format,method,page,perpage,type,category];
    } else {
        getThis = [NSString stringWithFormat:@"http://www.authenticjobs.com/api/?api_key=%@&format=%@&method=%@&location=%@&page=%@&perpage=%@&type=%@&category=%@",ajapi,format,method,location,page,perpage,type,category];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:getThis]
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad 
										 timeoutInterval:30.0];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //NSLog(@"getThis: %@",getThis);
    
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES; // to stop it, set this to NO
}

- (void)requestLocation:(NSString *)format 
         withMethod:(NSString *)method 
{
	responseData    = [[NSMutableData data] retain];
    
    NSString *getThis = [NSString stringWithFormat:@"http://www.authenticjobs.com/api/?api_key=%@&format=%@&method=%@",ajapi,format,method];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:getThis]
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad 
										 timeoutInterval:30.0];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //NSLog(@"getThis: %@",getThis);
    
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES; // to stop it, set this to NO
}

#pragma mark NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if([self.delegate respondsToSelector:@selector(checkForFinishConnection:handleError:)]) {
        [self.delegate checkForFinishConnection:nil handleError:error];
    }
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO; // to stop it, set this to NO
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
	NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	[responseData release];
    
    NSDictionary *results  = [responseString JSONValue];
    NSDictionary *listings;
    NSArray      *listing;
    if ([results objectForKey:@"listings"]) {
        listings = [results objectForKey:@"listings"];
        listing  = [listings objectForKey:@"listing"];
        // save to defaults for global use
        [[NSUserDefaults standardUserDefaults] setObject:responseString forKey:@"listing"];
    } else if ([results objectForKey:@"locations"]){
        listings = [results objectForKey:@"locations"];
        listing  = [listings objectForKey:@"location"];
        // save to defaults for global use
        [[NSUserDefaults standardUserDefaults] setObject:responseString forKey:@"locations"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    if([self.delegate respondsToSelector:@selector(checkForFinishConnection:handleError:)]) {
        [self.delegate checkForFinishConnection:listing handleError:nil];
    }
    
    UIApplication* app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO; // to stop it, set this to NO
    
    [responseString release];
	[connection release];
}

@end
