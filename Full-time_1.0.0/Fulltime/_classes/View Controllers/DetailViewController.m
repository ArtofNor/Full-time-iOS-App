//
//  DetailViewController.m
//  Ajobs
//
//  Created by Nor Sanavongsay on 4/10/11.
//  Copyright 2011 nawDsign. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"
#import "FBConnect.h"

#import "FontLabel.h"
#import "FontLabelStringDrawing.h"
#import "FontManager.h"

#import "DetailViewController.h"

//#import "CheckInternet.h"
#import "JobsRecord.h"

#define mapviewtag 5555

@implementation DetailViewController

@synthesize delegate;
@synthesize mainWindow;
@synthesize companyLogo,companyName,companyLocation,companyInfoButton,globeImage;
@synthesize companyWebSite,jobDescription,jobLocation,jobId,companyLogoURL,jobDescriptionText;
@synthesize applyButton,emailButton;
@synthesize navBar,actionBar;
@synthesize backButton,navtitle,popoverButton,mapViewButton;
@synthesize companyDetail;
@synthesize stringForEmail,applyUrl,applyEmail;
@synthesize jobTitle;
@synthesize customActionSheet,alertView;
@synthesize filterLine;
@synthesize facebook;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.clipsToBounds = YES;
    self.view.layer.cornerRadius = 6.0;
    
    self.navBar.layer.shadowOpacity = 0;
    self.navBar.layer.shadowRadius = 0;
    self.navBar.layer.shadowOffset = CGSizeMake(0,1);
    self.navBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.navBar.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1] CGColor];
    
    [self hideGradientBackground:self.jobDescription];
    
    //self.navtitle = [[[FontLabel alloc] initWithFrame:CGRectMake(75, 7,170,30) fontName:@"aventura" pointSize:24.0f] autorelease];
    self.navtitle = [[[UILabel alloc] initWithFrame:CGRectMake(75, 8,170,30) ] autorelease];
    self.navtitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
    self.navtitle.textAlignment = UITextAlignmentCenter;
    self.navtitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.navtitle.backgroundColor = [UIColor clearColor];
    self.navtitle.textColor = [UIColor blackColor];
    [self.navBar addSubview:self.navtitle];
    
    self.actionBar.layer.shadowOpacity = 0.3;
    self.actionBar.layer.shadowRadius = 2.0;
    self.actionBar.layer.shadowOffset = CGSizeMake(0,1);
    self.actionBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    
    UIImage *buttonImage = [[UIImage imageNamed:@"button_shell_dark.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
    UIImage *buttonPressedImage = [[UIImage imageNamed:@"button_shell_dark_pressed.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
    UIImage *bluebuttonImage = [[UIImage imageNamed:@"button_shell_blue.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
    UIImage *bluebuttonPressedImage = [[UIImage imageNamed:@"button_shell_blue_pressed.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:10.0];
    
    [self.popoverButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.popoverButton setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    [self.emailButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.emailButton setBackgroundImage:buttonPressedImage forState:UIControlStateHighlighted];
    [self.applyButton setBackgroundImage:bluebuttonImage forState:UIControlStateNormal];
    [self.applyButton setBackgroundImage:bluebuttonPressedImage forState:UIControlStateHighlighted];
    
    /*NSString *categoryTitle = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentCategory"];
    CGSize stringsize = [categoryTitle sizeWithFont:[UIFont systemFontOfSize:12]];
    int titleLabelWidth = stringsize.width+20;
    if (titleLabelWidth <= 64) { titleLabelWidth = 64; }
    if (titleLabelWidth >= 90) { titleLabelWidth = 90; }
    [self.backButton setFrame:CGRectMake(5,7,titleLabelWidth, 30)];
    [self.backButton setTitle:categoryTitle forState:UIControlStateNormal];*/
    
    [self.backButton addTarget:self action:@selector(closeThisView) forControlEvents:UIControlEventTouchUpInside];
    [self.mapViewButton addTarget:self action:@selector(loadMapView) forControlEvents:UIControlEventTouchUpInside];
    [self.globeImage addTarget:self action:@selector(openCompanySite) forControlEvents:UIControlEventTouchUpInside];
    [self.companyInfoButton addTarget:self action:@selector(openCompanySite) forControlEvents:UIControlEventTouchUpInside];
    
	// Set up action sheet
	self.customActionSheet = [[[UIActionSheet alloc] initWithTitle:@"Share this job on"
													delegate:self
										   cancelButtonTitle:@"Cancel"
									  destructiveButtonTitle:nil
										   otherButtonTitles:@"Twitter",@"Facebook", /*@"Linkedin",*/ nil] autorelease];
    openInSafari = YES;
    
    // 
    UISwipeGestureRecognizer *swipeUp = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeUp:)] autorelease];
    swipeUp.direction = UISwipeGestureRecognizerDirectionUp; 
    [self.view addGestureRecognizer:swipeUp];
    // 
    UISwipeGestureRecognizer *swipeDown = [[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeDown:)] autorelease];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown; 
    [self.view addGestureRecognizer:swipeDown];
    
    [self addScrollViewListener];
}

#pragma mark - Swipe Action
-(void)swipeUp: (UISwipeGestureRecognizer *) sender
{
    /// load next job
    NSLog(@"hi");
}

-(void)swipeDown: (UISwipeGestureRecognizer *) sender
{
    [self closeThisView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self tweetThis];
            break;
        case 1:
            [self facebookThis];
            break;
        case 2:
            [self linkedinThis];
            break;
        default:
            break;
    }
}

- (void) tweetThis {
    if ([TWTweetComposeViewController canSendTweet]) {
        NSString *tweetString = [NSString stringWithFormat:@"%@, %@ at %@ (%@) via @FulltimeApp",self.navtitle.text,self.jobTitle,self.companyName.text, self.jobLocation];
        NSString *tweetURL = [NSString stringWithFormat:@"http://authjo.bz/j/%@",self.jobId];
        
        // Create the view controller
        TWTweetComposeViewController *twitter = [[[TWTweetComposeViewController alloc] init] autorelease];
        
        // Optional: set an image, url and initial text
        [twitter setInitialText:tweetString];
        [twitter addImage:self.companyLogo.image];
        [twitter addURL:[NSURL URLWithString:[NSString stringWithString:tweetURL]]];
        
        // Show the controller
        [self presentModalViewController:twitter animated:YES];
    } else {
        AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appdelegate loadErrorViewWith:@"Please check if you can tweet in the Twitter Settings App." orError:nil];
    }
    //[TestFlight passCheckpoint:@"Twitter Share"];
}

- (void) facebookThis {
    AppDelegate *fbdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] && [defaults objectForKey:@"FBExpirationDateKey"]) {
        [fbdelegate facebook].accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        [fbdelegate facebook].expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    if (![[fbdelegate facebook] isSessionValid]) {
        NSArray *permissions = [[NSArray alloc] initWithObjects:
                                @"user_status",
                                @"publish_stream",
                                nil];
        [fbdelegate facebook].sessionDelegate = self;
        [[fbdelegate facebook] authorize:permissions];
        [permissions release];
    } else {
        NSString *nameText = [NSString stringWithFormat:@"%@, %@",self.navtitle.text,self.jobTitle];
        NSString *caption = [NSString stringWithFormat:@"%@ (%@)",self.companyName.text, self.jobLocation];
        NSString *link = [NSString stringWithFormat:@"http://authjo.bz/j/%@",self.jobId];
        NSString *description = [NSString stringWithFormat:@"%@",self.jobDescriptionText];
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       nameText, @"name",
                                       caption, @"caption",
                                       description, @"description",
                                       link, @"link",
                                       self.companyLogoURL, @"picture",
                                       nil];  
        [[fbdelegate facebook] dialog:@"feed" andParams:params andDelegate:self];
    }
    //[TestFlight passCheckpoint:@"Facebook Share"];
}

- (void) linkedinThis {
    //NSLog(@"Linkedin");
}

- (void) closeThisView{
    if([self.delegate respondsToSelector:@selector(detailViewDidFinish:)]) {
        [self.delegate detailViewDidFinish:self];
    }
}

- (void)showData:(id)atIndex andImage:(UIImage *)image{
    
    self.companyDetail          = [atIndex objectForKey:@"company"];
    NSString *compName          = [self.companyDetail objectForKey:@"name"];
    NSString *tagline           = [self.companyDetail objectForKey:@"tagline"];
    self.companyWebSite         = [self.companyDetail objectForKey:@"url"];
    self.companyLogoURL         = [self.companyDetail objectForKey:@"logo"];
    self.jobTitle               = [atIndex objectForKey:@"title"];
    self.applyUrl               = [atIndex objectForKey:@"apply_url"];
    self.applyEmail             = [atIndex objectForKey:@"apply_email"];
    self.jobLocation            = [[self.companyDetail objectForKey:@"location"] objectForKey:@"city"];
    self.jobId                  = [atIndex objectForKey:@"id"];
    self.jobDescriptionText     = tagline;
    
    /*NSString *city              = [[self.companyDetail objectForKey:@"location"] objectForKey:@"city"];
    NSString *state             = [[self.companyDetail objectForKey:@"location"] objectForKey:@"state"];
    NSString *lat             = [[self.companyDetail objectForKey:@"location"] objectForKey:@"lat"];
    NSString *lng               = [[self.companyDetail objectForKey:@"location"] objectForKey:@"lng"];
    */
    
    if ([self.jobLocation isEqualToString:@""] || self.jobLocation==nil) {
        self.jobLocation = @"Anywhere";
        self.mapViewButton.enabled = NO;
    }
    
    if ([compName isEqualToString:@""] || compName==nil) {
        compName = @"Company Confidential";
        self.jobLocation = @"Anywhere";
    }
    
    if([self.companyWebSite isEqualToString:@""] || self.companyWebSite==nil){
        self.companyInfoButton.userInteractionEnabled = NO;
        self.globeImage.hidden = YES;
    } else {
        self.companyInfoButton.userInteractionEnabled = YES;
        self.globeImage.hidden = NO;
    }
    
    if (!image) {
        self.companyLogo.image = [UIImage imageNamed:@"companyblank.png"];
    } else {
        self.companyLogo.image = image;
    }
    
    NSDictionary *type      = [atIndex objectForKey:@"type"];
    //NSString *companyTypeId = [type objectForKey:@"id"];
    NSString *companyType   = [type objectForKey:@"name"];
    
    self.navtitle.text = companyType;
    
    // change font color
    if ([companyType isEqualToString:@"Full-time"]) {
        self.filterLine.image = [UIImage imageNamed:@"tab_fulltime.png"];
        self.navtitle.textColor = [UIColor colorWithRed:0.902 green:0.541 blue:0.125 alpha:1.000];
    } else if ([companyType isEqualToString:@"Contract"]){
        self.filterLine.image = [UIImage imageNamed:@"tab_contract.png"];
        self.navtitle.textColor = [UIColor colorWithRed:0.165 green:0.486 blue:0.647 alpha:1.000];
    } else if ([companyType isEqualToString:@"Freelance"]){
        self.filterLine.image = [UIImage imageNamed:@"tab_freelance.png"];
        self.navtitle.textColor = [UIColor colorWithRed:0.604 green:0.663 blue:0.008 alpha:1.000];
    } else if ([companyType isEqualToString:@"Internship"]){
        self.filterLine.image = [UIImage imageNamed:@"tab_internship.png"];
        self.navtitle.textColor = [UIColor colorWithRed:0.722 green:0.333 blue:0.604 alpha:1.000];
    } else {
        self.navtitle.textColor = [UIColor blackColor];
    }
    
    NSString *dateStr = [atIndex objectForKey:@"post_date"];
    
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormat dateFromString:dateStr];
    
    // Convert date object to desired output format
    [dateFormat setDateFormat:@"MMM d, yyyy"];
    dateStr = [dateFormat stringFromDate:date];  
    [dateFormat release];
    
    //NSString *companyID     = [atIndex objectForKey:@"id"];
    if (tagline) {
        self.companyLocation.text   = @"≡ visit our website";
    } else{
        self.companyLocation.text   = self.jobLocation;
        tagline = @"...";
    }
    self.companyName.text   = compName;
    
    NSString *jobPerks      = nil;
    if ([atIndex objectForKey:@"perks"] != [NSNull null] && [atIndex objectForKey:@"perks"]) {
        jobPerks = [NSString stringWithFormat:@"<div class='jobperks'><h4>&#9733; JOB PERKS</h4>%@</div>",[atIndex objectForKey:@"perks"]];
    } else {
        jobPerks = @"";
    }
    
    NSString *jobDes        = [NSString stringWithFormat:@"<style>a:link{color:#2BA3F0;text-decoration:none;}\
                               .howto a:link{color:#3399FF;}\
                               .jobperks {padding:10pt;border-radius:4pt;background-color:#f1f1f1;border:1pt solid #ddd;}\
                               .jobperks h4 {margin:0 0 5pt;}\
                               p,body,li,h4{font-family:'Helvetica Neue',san-serif;font-size:10pt;color:#333;}\
                               h1{padding-bottom:0;margin-bottom:0.5em;font-weight:100;font-size:20pt;color:#333;text-shadow:0 1pt 0 #fff;text-align:center;font-style:italic;font-family:Georgia;}\
                               ul{margin:0 1em 1em;padding:0;} li{margin:0 .2em .2em;padding:2pt;color:#666;}\
                               h4{margin-bottom:.5em;text-align:center;text-transform:uppercase;}\
                               h3{margin:0;padding:0 0 .5em;font-size:12pt;color:#666;text-align:center;}\
                               h3 em{font-size:9pt;color:#aaa;font-weight:normal;}\
                               .meta {padding:4pt 0;margin:0 0 2em;color:#666;font-size:8pt;text-align:center;border-bottom:1px dotted #ddd;height:.3em;}\
                               .meta span {background-color:#fff;padding:0 1em;} </style>\
                               <body style='background-color:transparent;padding:0 4pt 4pt'><h1>%@</h1><h3>%@<br /><em>%@</em></h3><p class='meta'><span>%@</span></p><p style='color:#aaa;'>%@</p>%@%@\
                                    <div><p>%@</p></p>\
                               </body>",
                               [atIndex objectForKey:@"title"],compName,tagline,dateStr,self.jobLocation,
                               [atIndex objectForKey:@"description"],jobPerks,[atIndex objectForKey:@"howto_apply"]];
    
	[self.jobDescription loadHTMLString:jobDes baseURL:NULL];
    self.stringForEmail = jobDes;
    
}

// cancel opening links.
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *requestURL = [request URL];
    if(navigationType == UIWebViewNavigationTypeLinkClicked) {
        if (openInSafari) {
            [self gotoWebsite:requestURL];
            [self.jobDescription stopLoading];
            return YES;
        }
    }
    return YES;
}

#pragma mark - Remove Background WebView

- (void) hideGradientBackground:(UIView*)theView
{
    for (UIView * subview in theView.subviews)
    {
        if ([subview isKindOfClass:[UIImageView class]])
            subview.hidden = YES;
        
        [self hideGradientBackground:subview];
    }
    [theView setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - Open Website
- (void) openCompanySite {
    NSURL *url = [NSURL URLWithString:self.companyWebSite];
	[self gotoWebsite:url];
}

- (void) gotoWebsite:(NSURL *)url {
    WebBrowserViewController *controller = [[WebBrowserViewController alloc] initWithNibName:@"WebBrowserViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [controller loadWebViewWithURL:url andTitle:self.companyName.text];
    [self presentModalViewController:controller animated:YES];
}

- (void)webViewDidFinish:(WebBrowserViewController *)controller{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Apply to job

- (IBAction) applyToJob:(id)sender {
	[self showPicker:@"Apply"];
    //[TestFlight passCheckpoint:@"Apply to Job"];
}

- (IBAction) emailJob:(id)sender {
	[self showPicker:@"Email"];
    //[TestFlight passCheckpoint:@"Email Job"];
}

- (IBAction)showOptionsMenu:(id)sender {
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	[self.customActionSheet showInView:appdelegate.window];
}

-(void)showPicker:(NSString *) whichPicker{
	// This sample can run on devices running iPhone OS 2.0 or later  
	// The MFMailComposeViewController class is only available in iPhone OS 3.0 or later. 
	// So, we must verify the existence of the above class and provide a workaround for devices running 
	// earlier versions of the iPhone OS. 
	// We display an email composition interface if MFMailComposeViewController exists and the device can send emails.
	// We launch the Mail application on the device, otherwise.
    
    //first check if it's an email or website
    if ([whichPicker isEqualToString:@"Apply"] && self.applyUrl != nil) {
        NSURL *url = [NSURL URLWithString:self.applyUrl];
        [self gotoWebsite:url];
    } else {
        Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
        if (mailClass != nil) {
            // We must always check whether the current device is configured for sending emails
            if ([mailClass canSendMail]) {
                [self displayComposerSheet:whichPicker];
            } else {
                [self launchMailAppOnDevice];
            }
        } else {
            [self launchMailAppOnDevice];
        }
    }
}

#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet:(NSString *) whichSheet
{
    NSString *emailBody = nil;
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    
    if ([whichSheet isEqualToString:@"Apply"]) {
        NSString *email = self.applyEmail;
        if (email) {
            NSArray *toRecipients = [NSArray arrayWithObject:email];
            [picker setToRecipients:toRecipients];
        } else {
            // Fill out the email body text
            emailBody = @"**ATTENTION** \nThere were no emails supplied, please read the job post carefully to see how to apply.";
        }
        [picker setSubject:[NSString stringWithFormat:@"Applying for %@",self.jobTitle]];
    } else {
        
        [picker setSubject:[NSString stringWithFormat:@"%@ at %@",self.navtitle.text,self.companyName.text]];
        
        // Fill out the email body text
        emailBody = [NSString stringWithFormat:@"I found this job on the Full-time app and thought you might be interested:\n%@ \n <p>%@'s Website: %@</p><p>via Full-time iOS App</p>",self.stringForEmail,self.companyName.text,self.companyWebSite];
    }
    
	[picker setMessageBody:emailBody isHTML:YES];
    
    /*if (![whichSheet isEqualToString:@"Apply"]) {
        // Attach an image to the email
        NSString *path = [[NSBundle mainBundle] pathForResource:@"sent_from" ofType:@"png"];
        NSData *myData = [NSData dataWithContentsOfFile:path];
        [picker addAttachmentData:myData mimeType:@"image/png" fileName:@"sent_from@2x"];
    }*/
	
	[self presentModalViewController:picker animated:YES];
    [picker release];
}


// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error 
{	
	//message.hidden = NO;
	// Notifies users about errors associated with the interface
    UIAlertView *whatHappened = nil;
	switch (result)
	{
		case MFMailComposeResultCancelled:
            /*whatHappened = [[UIAlertView alloc] initWithTitle:@"Awwww!" 
                                message:@"You can share later then." 
                               delegate:self 
                      cancelButtonTitle:@"Thanks!" 
                      otherButtonTitles:nil];*/
			break;
		case MFMailComposeResultSaved:
            whatHappened = [[UIAlertView alloc] initWithTitle:@"Woohoo!" 
                                message:@"You've saved your email." 
                               delegate:self 
                      cancelButtonTitle:@"OK, cool" 
                      otherButtonTitles:nil];
			break;
		case MFMailComposeResultSent:
            whatHappened = [[UIAlertView alloc] initWithTitle:@"Way to go!" 
                                message:@"Thank you for sharing!" 
                               delegate:self 
                      cancelButtonTitle:@"You're welcome" 
                      otherButtonTitles:nil];
			break;
		case MFMailComposeResultFailed:
            whatHappened = [[UIAlertView alloc] initWithTitle:@"Uh oh!" 
                                message:@"Something went wrong." 
                               delegate:self 
                      cancelButtonTitle:@"Hmmmm..." 
                      otherButtonTitles:nil];
			break;
		default:
            whatHappened = [[UIAlertView alloc] initWithTitle:@"Oh no!" 
                                message:@"Mail did not send. Please try again." 
                               delegate:self 
                      cancelButtonTitle:@"OK" 
                      otherButtonTitles:nil];
			break;
	}
    [whatHappened show];
    [whatHappened release];
    
	[self dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{
	NSString *recipients = @"mailto:?subject=Sharing a job post I found in the Full-time app";
	NSString *body = [NSString stringWithFormat:@"I found this job on the Full-time app and thought you might be interested:\n%@ \n <p>%@'s Website: %@</p>",self.stringForEmail,self.companyName.text,self.companyWebSite];
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

#pragma mark -
#pragma mark Map Load
- (void)loadMapView {

    if (![self.view viewWithTag:mapviewtag]) {
        MapViewController *controller = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
        controller.delegate = self;  //Set delegate
        controller.view.tag = mapviewtag;
        controller.view.alpha = 0;
        controller.view.transform = CGAffineTransformMake(1.2,0,0,1.2,0,117);
        controller.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [controller loadMapWithLocationData:self.companyDetail];
        [self.view addSubview:controller.view];
    
        self.mapViewButton.selected = YES;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
            self.jobDescription.alpha = 0;
            self.jobDescription.transform = CGAffineTransformMakeScale(0.93,0.93);
            [self.view viewWithTag:mapviewtag].alpha = 1;
            [self.view viewWithTag:mapviewtag].transform = CGAffineTransformMake(1,0,0,1,0,117);
            self.actionBar.layer.shadowOpacity = 0;
            self.actionBar.layer.shadowRadius = 0;
        } completion:^(BOOL finished) { }];
        
        [controller release];
    } else {
    
        self.mapViewButton.selected = NO;
        [UIView animateWithDuration:0.3 delay:0 options:0 animations:^{
            self.jobDescription.alpha = 1;
            self.jobDescription.transform = CGAffineTransformMakeScale(1,1);
            [self.view viewWithTag:mapviewtag].alpha = 0;
            [self.view viewWithTag:mapviewtag].transform = CGAffineTransformMake(1.2,0,0,1.2,0,117);
            self.actionBar.layer.shadowOpacity = 0.3;
            self.actionBar.layer.shadowRadius = 2.0;
        } completion:^(BOOL finished) {
            [[self.view viewWithTag:mapviewtag] removeFromSuperview];
        }];
    }
    
}

- (void)showInMap {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Open location in Maps?" message:@"You are leaving Full-time app." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Open Maps", nil];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1) {
        UIApplication *app = [UIApplication sharedApplication];
        NSString *locationURL = [NSString stringWithFormat:@"http://maps.google.com/maps?q=%@",self.jobLocation];
        NSURL *getjobLocation = [NSURL URLWithString:[locationURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [app openURL:getjobLocation];
    }
}
#pragma mark - Dragging Web View

- (void) addScrollViewListener {
    UIScrollView* currentScrollView;
    for (UIView* subView in self.jobDescription.subviews) {
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
    } else if (scrollView.contentOffset.y <= 0){
        self.navBar.layer.shadowOpacity = 0;
        self.navBar.layer.shadowRadius = 0;
    }
}

#pragma mark -
#pragma mark Error Views

- (void)loadErrorViewWith:(NSString *)string orError:(NSError *)error{
    [self.delegate loadErrorViewWith:string orError:error];
}

- (void)removeError {
    [self.delegate removeError];
}

- (void)viewDidUnload
{
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.companyName = nil;
    self.companyLocation = nil;
    self.companyInfoButton = nil;
    self.jobDescription = nil;
    self.companyLogo = nil;
    self.backButton = nil;
    self.popoverButton = nil;
    self.mapViewButton = nil;
    self.applyButton = nil;
    self.emailButton = nil;
    self.filterLine = nil;
    
    [super viewDidUnload];
}

- (void)dealloc
{
    [companyName release];
    [companyLocation release];
    [companyInfoButton release];
    [jobDescription release];
    [companyLogo release];
    [backButton release];
    [popoverButton release];
    [mapViewButton release];
    [applyButton release];
    [emailButton release];
    [filterLine release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

@end
