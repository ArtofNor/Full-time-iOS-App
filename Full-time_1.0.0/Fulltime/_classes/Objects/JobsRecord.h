//
//  JobsRecord.h
//  Ajobs
//
//  Created by Nor Sanavongsay on 8/31/11.
//  Copyright 2011 nawDsign. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JobsRecord : NSObject {
    NSString *logoURLString;
    NSString *companyId;
    NSString *jobId;
    
    NSDictionary *company;
    UIImage  *companyLogo;
}

@property (nonatomic, retain) NSString *logoURLString;
@property (nonatomic, retain) NSString *companyId;
@property (nonatomic, retain) NSString *jobId;
@property (nonatomic, retain) NSDictionary *company;
@property (nonatomic, retain) UIImage  *companyLogo;

@end
