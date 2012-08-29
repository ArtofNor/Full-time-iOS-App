//
//  AjobsConnection.h
//  Ajobs
//
//  Created by Nor Sanavongsay2 on 3/9/11.
//  Copyright 2011 nawDsign. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AjobsConnectionDelegate;

@interface AjobsConnection : NSObject {
    id<AjobsConnectionDelegate> delegate;
	NSMutableData *responseData;
}

@property (nonatomic, assign) id<AjobsConnectionDelegate> delegate;

- (void)requestJobs:(NSString *)format 
       withMethod:(NSString *)method 
          location:(NSString *)location 
          perPage:(NSString *)perpage  
       whatCategory:(NSString *)category
         whatType:(NSString *)type  
         whatPage:(NSString *)page;

- (void)requestLocation:(NSString *)format 
             withMethod:(NSString *)method;

@end

// create delegate functions
@protocol AjobsConnectionDelegate <NSObject>
- (void)checkForFinishConnection:(NSArray *)jobslisting handleError:(NSError *)error;
@end