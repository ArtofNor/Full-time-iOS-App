//
//  DetailViewController.h
//  Ajobs
//
//  Created by Nor Sanavongsay on 4/10/11.
//  Copyright 2011 nawDsign. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Twitter/Twitter.h>

#import "MapViewController.h"
#import "WebBrowserViewController.h"

#import "FBConnect.h"

@protocol DetailViewControllerDelegate;

@interface DetailViewController : UIViewController <
    UIWebViewDelegate,
    UIScrollViewDelegate,
    UIActionSheetDelegate,
    UIAlertViewDelegate,
    MFMailComposeViewControllerDelegate,
    WebBrowserViewControllerDelegate,
    MapViewControllerDelegate,
    FBRequestDelegate,
    FBSessionDelegate,
    FBDialogDelegate
> {
    id<DetailViewControllerDelegate>delegate;
    
    UILabel *companyName;
    UIView *navBar;
    UILabel *navtitle;
    UILabel *navtitleShadow;
    UILabel *companyLocation;
    
    NSDictionary *companyDetail;
    UIImageView *companyLogo;
    UIImageView *filterLine;
    
    UIButton *companyInfoButton;
    NSString *companyWebSite;
    NSString *applyUrl;
    NSString *applyEmail;
    NSString *jobTitle;
    NSString *jobId;
    NSString *companyLogoURL;
    NSString *jobDescriptionText;
    
    NSString *stringForEmail;
    NSString *jobLocation;
    
    UIWebView *jobDescription;
    
    UIButton *backButton;
    UIButton *popoverButton;
    UIButton *applyButton;
    UIButton *emailButton;
    
    UIButton *mapViewButton;
    
	UIActionSheet *customActionSheet;
    UIAlertView *alertView;
    
    BOOL openInSafari;
    BOOL firstTouch;
    BOOL _canTweet;
    
    int touchOffset;
    int endLocation;
    
    Facebook *facebook;
}

@property (nonatomic, assign) id<DetailViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *companyName;
@property (nonatomic, retain) IBOutlet UILabel *companyLocation;
@property (nonatomic, retain) IBOutlet UIButton *companyInfoButton;
@property (nonatomic, retain) IBOutlet UIButton *globeImage;
@property (nonatomic, retain) IBOutlet UIWebView *jobDescription;

@property (nonatomic, retain) IBOutlet UIImageView *companyLogo;
@property (nonatomic, retain) IBOutlet UIImageView *filterLine;

@property (nonatomic, retain) UILabel *navtitle;
@property (nonatomic, retain) IBOutlet UIView *navBar;
@property (nonatomic, retain) IBOutlet UIView *actionBar;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *popoverButton;
@property (nonatomic, retain) IBOutlet UIButton *mapViewButton;
@property (nonatomic, retain) IBOutlet UIButton *applyButton;
@property (nonatomic, retain) IBOutlet UIButton *emailButton;

@property (nonatomic, retain) UIWindow *mainWindow;
@property (nonatomic, retain) NSDictionary *companyDetail;
@property (nonatomic, retain) UIActionSheet *customActionSheet;
@property (nonatomic, retain) UIAlertView *alertView;

@property (nonatomic, copy) NSString *companyWebSite;
@property (nonatomic, copy) NSString *applyUrl;
@property (nonatomic, copy) NSString *applyEmail;
@property (nonatomic, copy) NSString *jobTitle;
@property (nonatomic, copy) NSString *stringForEmail;
@property (nonatomic, copy) NSString *jobLocation;
@property (nonatomic, copy) NSString *jobId;
@property (nonatomic, copy) NSString *companyLogoURL;
@property (nonatomic, copy) NSString *jobDescriptionText;

@property (nonatomic, retain) Facebook *facebook;

- (void) showData:(id)atIndex andImage:(UIImage *)image;

- (void) hideGradientBackground:(UIView*)theView;
- (void) openCompanySite;

- (void) gotoWebsite:(NSURL *)url;

- (void) closeThisView;

- (void) showPicker:(NSString *) whichPicker;
- (void) displayComposerSheet:(NSString *) whichSheet;
- (void) launchMailAppOnDevice;

- (void) webViewDidFinish:(WebBrowserViewController *)controller;

- (void) tweetThis;
- (void) facebookThis;
- (void) linkedinThis;

@end

// create delegate functions
@protocol DetailViewControllerDelegate <NSObject>
- (void)detailViewDidFinish:(DetailViewController *)controller;
- (void)loadErrorViewWith:(NSString *)string orError:(NSError *)error;
- (void)removeError;
@end