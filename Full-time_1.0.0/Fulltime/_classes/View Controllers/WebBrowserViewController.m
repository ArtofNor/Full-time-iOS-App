//
//  WebBrowserViewController.m
//  Fulltime
//
//  Created by Nor Sanavongsay on 10/20/11.
//  Copyright (c) 2011 nawDsign. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "WebBrowserViewController.h"

@implementation WebBrowserViewController

@synthesize navBar,addressBar,actionBar;
@synthesize browser, graydot;
@synthesize delegate = _delegate;
@synthesize webtitle,address;
@synthesize backButton,forwardButton,refreshButton,closeButton,safariButton;
@synthesize navicon;
@synthesize spinner;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        self.addressBar.transform=CGAffineTransformMakeTranslation(0,20);
        // Custom initialization
        self.view.clipsToBounds = YES;
        self.view.layer.cornerRadius = 6.0;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navBar.layer.shadowOpacity = 0;
    self.navBar.layer.shadowRadius = 0;
    self.navBar.layer.shadowOffset = CGSizeMake(0,1);
    self.navBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navBar.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
    self.navBar.layer.borderWidth = 1;
    
    self.actionBar.layer.shadowOpacity = 0.3;
    self.actionBar.layer.shadowRadius = 2.0;
    self.actionBar.layer.shadowOffset = CGSizeMake(0,1);
    self.actionBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    
    // Do any additional setup after loading the view from its nib.
    [self.closeButton addTarget:self action:@selector(closeThisView) forControlEvents:UIControlEventTouchUpInside];
    [self.safariButton addTarget:self action:@selector(openinSafari) forControlEvents:UIControlEventTouchUpInside];
    self.safariButton.enabled = NO;
    
    self.browser.delegate = self;
    self.browser.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    [self addScrollViewListener];
    
    CGRect mapImageFrame = CGRectMake(14,14,16,16);
    self.navicon = [[[AsyncImageView alloc] initWithFrame:mapImageFrame] autorelease];
    self.navicon.contentMode = UIViewContentModeScaleAspectFill;
    [self.navBar addSubview:self.navicon];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.navBar=nil;
    self.addressBar=nil;
    self.closeButton=nil;
    self.refreshButton=nil;
    self.backButton=nil;
    self.forwardButton=nil;
    self.browser=nil;
    
    self.webtitle=nil;
    self.address=nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Action
- (void) closeThisView{
    if([self.delegate respondsToSelector:@selector(webViewDidFinish:)]) {
        [self.delegate webViewDidFinish:self];
    }
}

- (void) loadWebViewWithURL:(NSURL *)url andTitle:(NSString *) title {
    if (title == nil) {
        title = @"Full-time Web Browser";
    }
    self.webtitle.text = title;
    self.address.text = [NSString stringWithFormat:@"%@",url];
    
    NSString *naviconURL = [NSString stringWithFormat:@"http://www.google.com/s2/favicons?domain_url=%@",url];
    NSURL *naviconImage = [NSURL URLWithString:[naviconURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.navicon loadImageFromURL:naviconImage];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url]; 
    [self.browser setScalesPageToFit:YES];
    [self.browser loadRequest:request];
    [self updateButtons];
}

- (void) openinSafari {
    if (![self.address.text isEqualToString:@"loading..."]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Open in Safari?" message:self.address.text delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Open Safari", nil];
        [alert show];
        [alert release];
    }
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1) {
        UIApplication *app = [UIApplication sharedApplication];
        NSString *locationURL = [NSString stringWithFormat:@"%@",self.address.text];
        NSURL *getjobLocation = [NSURL URLWithString:[locationURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [app openURL:getjobLocation];
    }
}

#pragma mark - UIWebViewDelegate protocol
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.spinner startAnimating];
    [self updateButtons];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.addressBar.transform=CGAffineTransformMakeTranslation(0,0);
    } completion:^(BOOL finished) {}];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.spinner stopAnimating];
    [self updateButtons];
    if (![self.address.text isEqualToString:@"loading..."]) {
        self.safariButton.enabled = YES;
    } else {
        self.safariButton.enabled = NO;
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.addressBar.transform=CGAffineTransformMakeTranslation(0,20);
    } completion:^(BOOL finished) {}];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.spinner stopAnimating];
    [self updateButtons];
    
    if (error.code == -999) {
        [self.delegate loadErrorViewWith:@"Hold tight, one at a time." orError:nil];
    } else {
        [self.delegate loadErrorViewWith:nil orError:error];
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.addressBar.transform=CGAffineTransformMakeTranslation(0,20);
    } completion:^(BOOL finished) {}];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

- (void)updateButtons
{
    self.forwardButton.enabled  = self.browser.canGoForward;
    self.backButton.enabled     = self.browser.canGoBack;
    self.refreshButton.enabled  = !self.browser.loading;
    self.graydot.hidden         = self.browser.loading;
    
    self.address.text = @"loading...";
    if (![[self.browser stringByEvaluatingJavaScriptFromString:@"document.URL"] isEqualToString:@"about:blank"]) {
       self.address.text = [self.browser stringByEvaluatingJavaScriptFromString:@"document.URL"];
    }
    if ([[self.browser stringByEvaluatingJavaScriptFromString:@"document.title"] isEqualToString:@""]) {
        self.webtitle.text = @"Full-time Web Browser";
    } else {
        self.webtitle.text = [self.browser stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}

#pragma mark - Dragging Web View

- (void) addScrollViewListener {
    UIScrollView* currentScrollView;
    for (UIView* subView in self.browser.subviews) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            currentScrollView = (UIScrollView*)subView;
            currentScrollView.delegate = self;
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self updateShadows:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateShadows:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self updateShadows:scrollView];
}

- (void)updateShadows:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y > 0) {
        if (scrollView.contentOffset.y >= 10) {
            self.navBar.layer.shadowOpacity = 0.3;
            self.navBar.layer.shadowRadius  = 4.0;
        } else if (scrollView.contentOffset.y < 10) {
            self.navBar.layer.shadowOpacity = (scrollView.contentOffset.y / 10)* 0.3;
            self.navBar.layer.shadowRadius  = (scrollView.contentOffset.y / 10)* 4.0;
        }
        self.navBar.layer.borderWidth = 0;
    } else if (scrollView.contentOffset.y <= 0){
        self.navBar.layer.shadowOpacity = 0;
        self.navBar.layer.shadowRadius = 0;
        self.navBar.layer.borderWidth = 1;
    }
}

@end
