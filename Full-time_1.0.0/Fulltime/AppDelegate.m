//
//  AppDelegate.m
//  Fulltime
//
//  Created by Nor Sanavongsay on 11/17/11.
//  Copyright (c) 2011 nawDsign. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "FontManager.h"

#import "AppDelegate.h"
#import "ViewController.h"

#define errorwindowtag 4040
#define errorviewtag 404
#define overlaytag 405

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize splashView;
@synthesize overlay;
@synthesize loadingIndicatorView;
@synthesize facebook;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //[TestFlight takeOff:@"GET YOUR OWN TESTFLIGHT ID"];
    //[TestFlight passCheckpoint:@"App Started"];
    
	//[[FontManager sharedManager] loadFont:@"aventura"]; // Bought font
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    
    self.window.rootViewController = self.viewController;
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    [self.viewController setMainWindow:self.window];
    
    facebook = [[Facebook alloc] initWithAppId:@"YOUR FACEBOOK APP ID HERE" andDelegate:self];
    
    // Fade out default.png
	splashView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,320,480)];
	splashView.image = [UIImage imageNamed:@"Default.png"];
	[self.window insertSubview:splashView aboveSubview:self.viewController.view];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        splashView.alpha = 0;
    } completion:^(BOOL finished) {
        [splashView removeFromSuperview];
        [splashView release];
    }];
    
    return YES;
}

#pragma mark -
#pragma mark Load Help Overlays
- (void) howtoOverlay:(NSString *)imagename {
    if (![self.window viewWithTag:overlaytag]) {
        UIOverlay *helpBlack = [[[UIOverlay alloc] initWithFrame:self.viewController.view.bounds] autorelease];
        helpBlack.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        helpBlack.alpha = 0;
        helpBlack.tag = overlaytag;
        
        UIImage *buttonImage = [[UIImage imageNamed:@"button_shell_darkclear.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
        UIImage *buttonPressedImage = [[UIImage imageNamed:@"button_shell_blue_pressed.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
        
        UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
        dismissButton.frame = CGRectMake(10, (helpBlack.bounds.size.height - 40) - 20, 300, 40);
        dismissButton.titleLabel.font		= [UIFont fontWithName:@"Helvetica Bold" size:20.0];
        dismissButton.titleLabel.textColor    = [UIColor blackColor];
        dismissButton.titleLabel.textAlignment = UITextAlignmentCenter;
        [dismissButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [dismissButton setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
        [dismissButton setTitle:@"Don't show this again." forState:UIControlStateNormal];
        [dismissButton addTarget:self action:@selector(removeHelp) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView * helpImageView = [[[UIImageView alloc] initWithFrame:helpBlack.bounds] autorelease];
        helpImageView.contentMode = UIViewContentModeScaleAspectFill;
        helpImageView.image = [UIImage imageNamed:imagename];
        helpImageView.userInteractionEnabled = NO;
        
        [self.viewController.view addSubview:helpBlack];
        [helpBlack addSubview:helpImageView];
        [helpBlack addSubview:dismissButton];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            helpBlack.alpha = 1;
        } completion:^(BOOL finished) { }];
    }
}

- (void) removeHelp{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.window viewWithTag:overlaytag].alpha = 0;
    } completion:^(BOOL finished) { 
        [[self.window viewWithTag:overlaytag] removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLoad"];
    }];
}


#pragma mark -
#pragma mark Loading Indicator
- (void)initSpinner {
    if (self.overlay == nil) {
        self.overlay = [[[UIOverlay alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        self.overlay.alpha = 0.75;
        [self.viewController.view addSubview:self.overlay];
        
        UIView * blackbox = [[UIView alloc] initWithFrame:CGRectMake((self.overlay.bounds.size.width/2)-40,
                                                                     (self.overlay.bounds.size.height/2)-60,
                                                                     80,80)];
        blackbox.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.0]; 
        blackbox.layer.cornerRadius = 10.0;
        [self.overlay addSubview:blackbox];
        
        // we put our spinning "thing" right in the center of the current view
        //CGPoint newCenter = (CGPoint) [blackbox center];
        self.loadingIndicatorView = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
        self.loadingIndicatorView.frame = CGRectMake(((blackbox.bounds.size.width)/2) - (self.loadingIndicatorView.bounds.size.width/2), 
                                                     ((blackbox.bounds.size.height)/2) - (self.loadingIndicatorView.bounds.size.height/2), 
                                                     self.loadingIndicatorView.bounds.size.width,
                                                     self.loadingIndicatorView.bounds.size.height);
        [blackbox addSubview:self.loadingIndicatorView];
        
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            blackbox.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.8];
            self.overlay.alpha = 1;
        } completion:^(BOOL finished) { }];
        
        [blackbox release];
    }
}

- (void)spinBegin {
	[self.loadingIndicatorView startAnimating];
}

- (void)spinEnd {
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(removeOverlay:finished:context:)];
    self.overlay.alpha = 0;
	[UIView commitAnimations];
}

- (void) removeOverlay:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	[self.loadingIndicatorView stopAnimating];
    [self.overlay removeFromSuperview];
    self.overlay = nil;
}

- (void)loadErrorViewWith:(NSString *)string orError:(NSError *)error{
    if (![self.window viewWithTag:errorwindowtag] && ![self.window viewWithTag:errorviewtag]) {
        
        UIView *errorWindow = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
        errorWindow.tag = errorwindowtag;
        errorWindow.alpha = 0;
        [self.window addSubview:errorWindow];
        
        UIOverlay *erroroverlay = [[[UIOverlay alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
        erroroverlay.alpha = 0.75;
        
        UIButton *dismissButton = [[[UIButton alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
        [dismissButton addTarget:self action:@selector(removeError) forControlEvents:UIControlEventTouchUpInside];
        
        ErrorView *errorView = [[[ErrorView alloc] 
                                 initWithFrame:CGRectMake(([[UIScreen mainScreen] bounds].size.width/2)-100,
                                                          ([[UIScreen mainScreen] bounds].size.height/2)-50,
                                                          200,100)] autorelease];
        errorView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:1.0];
        errorView.tag = errorviewtag;
        errorView.transform = CGAffineTransformMakeScale(1.5,1.5);
        
        [errorWindow addSubview:erroroverlay];
        [errorWindow addSubview:errorView];
        [errorWindow addSubview:dismissButton];
        
        if (string == nil) {
            [errorView errorWithError:error];
        } else {
            [errorView errorWithString:string];
        }
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            errorView.transform=CGAffineTransformMakeScale(1, 1);
            errorWindow.alpha = 1;
        } completion:^(BOOL finished) {}];
    }
}

- (void)removeError{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.window viewWithTag:errorwindowtag].alpha = 0;
        [self.window viewWithTag:errorviewtag].transform = CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        [[self.window viewWithTag:errorwindowtag] removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark Facebook
// Pre 4.2 support
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [facebook handleOpenURL:url]; 
}

// For 4.2+ support
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [facebook handleOpenURL:url]; 
}

- (void)fbDidLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}


- (void) fbDidLogout {
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
}

- (void) checkFacebookCache {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
}


// ------------------------ //

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    [self checkFacebookCache];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    [self checkFacebookCache];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
