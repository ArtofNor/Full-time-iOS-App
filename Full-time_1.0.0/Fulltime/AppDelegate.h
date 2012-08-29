//
//  AppDelegate.h
//  Fulltime
//
//  Created by Nor Sanavongsay on 11/17/11.
//  Copyright (c) 2011 nawDsign. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ErrorView.h"
#import "UIOverlay.h"
#import "FBConnect.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,FBSessionDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, retain) UIImageView *splashView;
@property (nonatomic, retain) UIOverlay *overlay;

@property (strong, nonatomic) ViewController *viewController;
@property (nonatomic, retain) UIActivityIndicatorView *loadingIndicatorView;
@property (nonatomic, retain) Facebook *facebook;


// delegated actions
- (void)initSpinner;
- (void)spinBegin;
- (void)spinEnd;
- (void)removeOverlay:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;

- (void)loadErrorViewWith:(NSString *)string orError:(NSError *)error;
- (void)removeError;

- (void)howtoOverlay:(NSString *)imagename;

@end
