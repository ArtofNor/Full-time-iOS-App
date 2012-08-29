//
//  WebBrowserViewController.h
//  Fulltime
//
//  Created by Nor Sanavongsay on 10/20/11.
//  Copyright (c) 2011 nawDsign. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AsyncImageView.h"

@protocol WebBrowserViewControllerDelegate;

@interface WebBrowserViewController : UIViewController <UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic, assign) id<WebBrowserViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIView *navBar;
@property (nonatomic, retain) IBOutlet UIView *addressBar;
@property (nonatomic, retain) IBOutlet UIView *actionBar;

@property (nonatomic, retain) IBOutlet UIButton *closeButton;
@property (nonatomic, retain) IBOutlet UIButton *refreshButton;
@property (nonatomic, retain) IBOutlet UIButton *backButton;
@property (nonatomic, retain) IBOutlet UIButton *forwardButton;
@property (nonatomic, retain) IBOutlet UIButton *safariButton;
@property (nonatomic, retain) IBOutlet UIWebView *browser;

@property (nonatomic, retain) IBOutlet UIImageView *graydot;

@property (nonatomic, retain) IBOutlet UILabel *webtitle;
@property (nonatomic, retain) IBOutlet UILabel *address;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *spinner;

@property (nonatomic, retain) AsyncImageView *navicon;

- (void) closeThisView;
- (void) loadWebViewWithURL:(NSURL *)url andTitle:(NSString *)title;
- (void) updateButtons;

@end

// create delegate functions
@protocol WebBrowserViewControllerDelegate <NSObject>
- (void)webViewDidFinish:(WebBrowserViewController *)controller;
- (void)loadErrorViewWith:(NSString *)string orError:(NSError *)error;
- (void)removeError;
@end