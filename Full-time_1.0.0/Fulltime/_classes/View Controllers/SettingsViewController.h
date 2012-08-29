//
//  SettingsViewController.h
//  Ajobs
//
//  Created by Nor Sanavongsay on 4/12/11.
//  Copyright 2011 nawDsign. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>

#import "WebBrowserViewController.h"
#import "LocationViewController.h"
#import "FBConnect.h"

@protocol SettingsViewControllerDelegate;

@interface SettingsViewController : UIViewController <
    UIScrollViewDelegate,
    UITableViewDelegate,
    UITableViewDataSource,
    UIActionSheetDelegate,
    MFMailComposeViewControllerDelegate,
    LocationViewControllerDelegate,
    WebBrowserViewControllerDelegate,
    FBRequestDelegate,
    FBSessionDelegate
> {
    id<SettingsViewControllerDelegate>delegate;
    UITableView *settingsTableView;
    NSArray *settings;
}

@property (nonatomic, assign) id<SettingsViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableView *settingsTableView;

@property (nonatomic, retain) UIActionSheet *actionsheet;
@property (nonatomic, retain) NSArray *settings;

- (void) changeLocation;
- (void) changeNumberOfJobs;
- (void) gotoWebsite:(NSURL *)url;

- (void) showPicker:(NSString *) whichPicker;
- (void) displayComposerSheet:(NSString *) whichSheet;
- (void) launchMailAppOnDevice;

- (void) tweetThis;
- (void) facebookThis;

@end

// create delegate functions
@protocol SettingsViewControllerDelegate <NSObject>
- (void)hideMainView:(BOOL)yes whichSide:(NSString *)side;
- (void)loadErrorViewWith:(NSString *)string orError:(NSError *)error;
- (void)loadSettingsView;
- (void)removeError;
@end