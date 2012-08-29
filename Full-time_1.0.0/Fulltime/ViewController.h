//
//  ViewController.h
//  Fulltime
//
//  Created by Nor Sanavongsay on 11/17/11.
//  Copyright (c) 2011 nawDsign. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

#import "JobListTableViewController.h"
#import "TipsViewController.h"
#import "SettingsViewController.h"
#import "CategoryViewController.h"
#import "DetailViewController.h"
#import "LocationViewController.h"

@interface ViewController : UIViewController <JobListTableViewControllerDelegate,TipsViewControllerDelegate,SettingsViewControllerDelegate,CategoryViewControllerDelegate,DetailViewControllerDelegate,LocationViewControllerDelegate,UIWebViewDelegate>
{
    BOOL firstLoad;
}

@property (nonatomic, retain) UIWindow *mainWindow;
@property (nonatomic, retain) AppDelegate *appdelegate;

@property (nonatomic, retain) IBOutlet UIView *navBar;
@property (nonatomic, retain) IBOutlet UIView *tabBar;
@property (nonatomic, retain) UILabel *navtitle;
@property (nonatomic, retain) IBOutlet UIButton *settingsButton;
@property (nonatomic, retain) IBOutlet UIButton *infoButton;
@property (nonatomic, retain) IBOutlet UIButton *categoryButton;
@property (nonatomic, retain) IBOutlet UIButton *locationButton;
@property (nonatomic, retain) IBOutlet UIImageView *blueLight;

@property (nonatomic, retain) JobListTableViewController *joblistTable;
@property (nonatomic, retain) UIView *detailView;

- (IBAction)setTabSelected:(id)sender;
- (void)loadCategories;
- (void)setCategoryTitle:(NSString *)title andCategoryId:(NSString *)catid;
- (void)loadJobs;
- (void)startLoadingWithPulldown;
- (void)hideMainView:(BOOL)yes whichSide:(NSString *)side;

- (void)loadSettingsView;
- (void)checkForSettingChange;

//delegate
- (void)loadDetailViewWithData:(NSDictionary *)aJobs andImage:(UIImage *)image;
- (void)loadErrorViewWith:(NSString *)string orError:(NSError *)error;
- (void)removeError;
- (void)initSpinner;
- (void)spinBegin;
- (void)spinEnd;

@end
