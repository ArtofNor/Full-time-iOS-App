//
//  JobListTableViewController.h
//  Fulltime
//
//  Created by Nor Sanavongsay on 9/1/11.
//  Copyright 2011 nawDsign. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullRefreshTableViewController.h"

#import "AjobsConnection.h"
#import "IconDownloader.h"

@class JobsRecord;

@protocol JobListTableViewControllerDelegate;

@interface JobListTableViewController : PullRefreshTableViewController <IconDownloaderDelegate,AjobsConnectionDelegate>

@property (nonatomic, assign) id<JobListTableViewControllerDelegate> delegate;

@property (nonatomic, retain) NSArray *jobs;
@property (nonatomic, retain) NSMutableArray *jobsArray;
@property (nonatomic, retain) NSString *currentPage;
@property (nonatomic, retain) NSString *currentType;
@property (nonatomic, retain) NSString *perPage;
@property (nonatomic, retain) NSString *currentCategoryId;
@property (nonatomic, retain) NSString *userLocation;

@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;

- (void)filterJobsWithArray:(NSArray *)filterjob  withError:(NSError *) error;
- (void)loadImagesForOnscreenRows;
- (void)startIconDownload:(JobsRecord *)jobsRecord forIndexPath:(NSIndexPath *)indexPath;
- (void)appImageDidLoad:(NSIndexPath *)indexPath;
- (void)refreshFromServer:(BOOL)isfromserver withLoadingAnimation:(BOOL)isloading;

@end

@protocol JobListTableViewControllerDelegate <NSObject>
- (void)loadDetailViewWithData:(NSDictionary *)aJobs andImage:(UIImage *)image;
- (void)loadErrorViewWith:(NSString *)string orError:(NSError *)error;
- (void)removeError;
- (void)initSpinner;
- (void)spinBegin;
- (void)spinEnd;
@end