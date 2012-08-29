//
//  JobsRecord.m
//  Ajobs
//
//  Created by Nor Sanavongsay on 8/31/11.
//  Copyright 2011 nawDsign. All rights reserved.
//

#import "JobsRecord.h"


@implementation JobsRecord

@synthesize company;
@synthesize companyLogo,companyId,jobId;
@synthesize logoURLString;

- (void)dealloc
{
    [companyLogo release];
    [companyId release];
    [jobId release];
    [company release];
    [logoURLString release];
    
    [super dealloc];
}

@end
