//
//  SettingsViewController.m
//  Ajobs
//
//  Created by Nor Sanavongsay on 4/12/11.
//  Copyright 2011 nawDsign. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"
#import "SettingsViewController.h"
#import "SettingsCell.h"

@implementation SettingsViewController

@synthesize delegate;
@synthesize settings;
@synthesize settingsTableView;
@synthesize actionsheet;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    
    NSData *plistData;  
    NSString *error;  
    NSPropertyListFormat format;
    NSDictionary *plist;
    
    NSDictionary *settingsList;
    NSDictionary *connectList;
    NSDictionary *aboutList;
    NSDictionary *contactList;
    
    NSString *localizedPath = [[NSBundle mainBundle] pathForResource:@"settings" ofType:@"plist"];  
    plistData = [NSData dataWithContentsOfFile:localizedPath];   
    
    plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];  
    if (!plist) {  
        NSLog(@"Error reading plist from file '%s', error = '%s'", [localizedPath UTF8String], [error UTF8String]);  
        [error release];  
    } else {
        settingsList   = [plist objectForKey:@"settings"];
        connectList    = [plist objectForKey:@"connections"];
        aboutList      = [plist objectForKey:@"about"];
        contactList    = [plist objectForKey:@"contact"];
        self.settings  = [NSArray arrayWithObjects:settingsList,connectList,contactList,aboutList,nil];
    }
    
    // connections
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"fbconnect"] || ![[NSUserDefaults standardUserDefaults] objectForKey:@"twitconnect"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"Not Connected" forKey:@"fbconnect"];
        [[NSUserDefaults standardUserDefaults] setObject:@"Not Connected" forKey:@"twitconnect"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    AppDelegate *fbdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[fbdelegate facebook] isSessionValid]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"Connected" forKey:@"fbconnect"];
        [self.settingsTableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    NSInteger sections = [[self settings] count];
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *sectionContents = [[[self settings] objectAtIndex:section] objectForKey:@"items"];
    NSInteger rows = [sectionContents count];
	
    return rows;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeader = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 20)] autorelease];
    sectionHeader.backgroundColor = [UIColor colorWithWhite:0.200 alpha:0.850];
    UILabel *sectionTitle = [[[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.bounds.size.width, 10)] autorelease];
    sectionTitle.font            = [UIFont fontWithName:@"Helvetica Neue" size:14.0];
    sectionTitle.font            = [UIFont boldSystemFontOfSize:14.0];
    sectionTitle.shadowColor     = [UIColor colorWithWhite:0 alpha:0.900];
    sectionTitle.shadowOffset    = CGSizeMake(0,1.0);
    sectionTitle.backgroundColor = [UIColor clearColor];
    sectionTitle.textColor       = [UIColor colorWithWhite:0.400 alpha:1.000];
    NSString *key = [[[self settings] objectAtIndex:section] objectForKey:@"title"];
    sectionTitle.text = key;
    [sectionHeader addSubview:sectionTitle];
    
    return sectionHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *sectionTitle = [[[self settings] objectAtIndex:[indexPath section]] objectForKey:@"title"];
    NSArray *sectionContents = [[[self settings] objectAtIndex:[indexPath section]] objectForKey:@"items"];
    if ([sectionTitle isEqualToString:@"About Full-time"]) {
        if (![[[sectionContents objectAtIndex:indexPath.row] objectForKey:@"title"] isEqualToString:@""]) {
            return 50;
        } else {
            return 85;
        }
    } else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingsCell";
    
	SettingsCell *cell = (SettingsCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		cell = (SettingsCell *)[[[SettingsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
    
    NSString *sectionTitle = [[[self settings] objectAtIndex:[indexPath section]] objectForKey:@"title"];
    
    NSArray *sectionContents = [[[self settings] objectAtIndex:[indexPath section]] objectForKey:@"items"];
    NSString *imageName = [[sectionContents objectAtIndex:indexPath.row] objectForKey:@"image"];
    NSString *setting = [[sectionContents objectAtIndex:indexPath.row] objectForKey:@"setting"];
    
    if ([sectionTitle isEqualToString:@"Preferences"]) {
        setting = [[NSUserDefaults standardUserDefaults] stringForKey:setting];
        cell.imageView.frame = CGRectMake(10, 10, 50, 50);
    } else if ([sectionTitle isEqualToString:@"Connections"]){
        setting = [[NSUserDefaults standardUserDefaults] stringForKey:setting];
        cell.imageView.frame = CGRectMake(10, 10, 50, 50);
    } else if ([sectionTitle isEqualToString:@"About Full-time"]) {
        if ([[[sectionContents objectAtIndex:indexPath.row] objectForKey:@"title"] isEqualToString:@"Version"]) {
            //NSString *appNameString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
            NSString *appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
            setting = [NSString stringWithFormat:@"%@",appVersionString];
        }
    }
    
    cell.detailTextLabel.text	= setting;
    cell.textLabel.text         = [[sectionContents objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.imageView.image        = [UIImage imageNamed:imageName];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionContents = [[[self settings] objectAtIndex:[indexPath section]] objectForKey:@"items"];
    if ([[sectionContents objectAtIndex:indexPath.row] objectForKey:@"id"]) {
        NSString *settingId = [[sectionContents objectAtIndex:indexPath.row] objectForKey:@"id"];
        if ([settingId isEqualToString:@"location"]) {
            [self changeLocation];
        } else if ([settingId isEqualToString:@"numberofjobs"]) {
            [self changeNumberOfJobs];
        } else if ([settingId isEqualToString:@"email"]) {
            [self showPicker:@"Email"];
        } else if ([settingId isEqualToString:@"twitter"]) {
            NSString *twittername = [[sectionContents objectAtIndex:indexPath.row] objectForKey:@"setting"];
            NSString *handle = [NSString stringWithFormat:@"http://mobile.twitter.com/%@",twittername];
            NSURL *url = [NSURL URLWithString:handle];
            [self gotoWebsite:url];
        } else if ([settingId isEqualToString:@"twitconnect"]) {
            [self tweetThis];
        } else if ([settingId isEqualToString:@"fbconnect"]) {
            [self facebookThis];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) tweetThis {
    AppDelegate *appdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"twitconnect"] isEqualToString:@"Connected"]) {
        [appdelegate loadErrorViewWith:@"You're already connected to twitter!" orError:nil];
    } else {
        if ([TWTweetComposeViewController canSendTweet]) {
            [[NSUserDefaults standardUserDefaults] setObject:@"Connected" forKey:@"twitconnect"];
            [self.settingsTableView reloadData];
        } else {
            [appdelegate loadErrorViewWith:@"Please sign in to your Twitter Account." orError:nil];
        }
    }
}

- (void) facebookThis {
    AppDelegate *fbdelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"fbconnect"] isEqualToString:@"Connected"] || [[fbdelegate facebook] isSessionValid]) {
        [fbdelegate loadErrorViewWith:@"You're already connected to Facebook!" orError:nil];
    } else {
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
            [self.delegate loadSettingsView];
        }
    }
}

- (void) changeLocation {
    if([self.delegate respondsToSelector:@selector(hideMainView:whichSide:)]) {
        [self.delegate hideMainView:YES whichSide:@"right"]; 
    }
    LocationViewController *controller = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentModalViewController:controller animated:YES];
    [controller release];
}

- (void)locationViewDidFinish:(LocationViewController *)controller{
    if([self.delegate respondsToSelector:@selector(hideMainView:whichSide:)]) {
        [self.delegate hideMainView:NO whichSide:@"right"]; 
    }
    [self dismissModalViewControllerAnimated:YES];
    [self.settingsTableView reloadData];
}

#pragma mark - Action Sheet
- (void) changeNumberOfJobs {
    if([self.delegate respondsToSelector:@selector(hideMainView:whichSide:)]) {
        [self.delegate hideMainView:YES whichSide:@"right"]; 
    }
    // Set up action sheet
	self.actionsheet = [[[UIActionSheet alloc] initWithTitle:@"How many jobs to show?"
													delegate:self
										   cancelButtonTitle:@"Cancel"
									  destructiveButtonTitle:nil
										   otherButtonTitles:@"25",@"50",@"100",nil] autorelease];
    
	[self.actionsheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if([self.delegate respondsToSelector:@selector(hideMainView:whichSide:)]) {
        [self.delegate hideMainView:NO whichSide:@"right"]; 
    }
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if (![buttonTitle isEqualToString:@"Cancel"]) {
        [[NSUserDefaults standardUserDefaults] setObject:buttonTitle forKey:@"perPage"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"changeSetting"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.settingsTableView reloadData];
    }
}

#pragma mark - Open Website
- (void) gotoWebsite:(NSURL *)url {
    if([self.delegate respondsToSelector:@selector(hideMainView:whichSide:)]) {
        [self.delegate hideMainView:YES whichSide:@"right"]; 
    } 
    
    WebBrowserViewController *controller = [[WebBrowserViewController alloc] initWithNibName:@"WebBrowserViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [controller loadWebViewWithURL:url andTitle:nil];
    [self presentModalViewController:controller animated:YES];
}

- (void)webViewDidFinish:(WebBrowserViewController *)controller{
    
    if([self.delegate respondsToSelector:@selector(hideMainView:whichSide:)]) {
        [self.delegate hideMainView:NO whichSide:@"right"]; 
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self dismissModalViewControllerAnimated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

-(void)showPicker:(NSString *) whichPicker{
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

#pragma mark -
#pragma mark Compose Mail

// Displays an email composition interface inside the application. Populates all the Mail fields. 
-(void)displayComposerSheet:(NSString *) whichSheet
{
    if([self.delegate respondsToSelector:@selector(hideMainView:whichSide:)]) {
        [self.delegate hideMainView:YES whichSide:@"right"]; 
    }
    
    NSArray *toRecipients = [NSArray arrayWithObject:@"nor.san@nawdsign.com"];
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
    
    [picker setToRecipients:toRecipients];
    [picker setSubject:@"Full-time App"];
	[picker setMessageBody:@"Hi Nor," isHTML:NO];

    // Attach an image to the email
    /*NSString *path = [[NSBundle mainBundle] pathForResource:@"sent_from@2x" ofType:@"png"];
    NSData *myData = [NSData dataWithContentsOfFile:path];
    [picker addAttachmentData:myData mimeType:@"image/png" fileName:@"sent_from"];*/
	
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
            whatHappened = [[UIAlertView alloc] initWithTitle:nil 
                                                      message:@"You've saved your email." 
                                                     delegate:self 
                                            cancelButtonTitle:@"Close" 
                                            otherButtonTitles:nil];
			break;
		case MFMailComposeResultSent:
            whatHappened = [[UIAlertView alloc] initWithTitle:nil 
                                                      message:@"Thank you for sharing!" 
                                                     delegate:self 
                                            cancelButtonTitle:@"Close" 
                                            otherButtonTitles:nil];
			break;
		case MFMailComposeResultFailed:
            whatHappened = [[UIAlertView alloc] initWithTitle:@"Uh oh!" 
                                                      message:@"Something went wrong." 
                                                     delegate:self 
                                            cancelButtonTitle:@"Close" 
                                            otherButtonTitles:nil];
			break;
		default:
            whatHappened = [[UIAlertView alloc] initWithTitle:@"Oh no!" 
                                                      message:@"Mail did not send. Please try again." 
                                                     delegate:self 
                                            cancelButtonTitle:@"Close" 
                                            otherButtonTitles:nil];
			break;
	}
    [whatHappened show];
    [whatHappened release];
    
    if([self.delegate respondsToSelector:@selector(hideMainView:whichSide:)]) {
        [self.delegate hideMainView:NO whichSide:@"right"]; 
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
	[self dismissModalViewControllerAnimated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

#pragma mark -
#pragma mark Workaround

// Launches the Mail application on the device.
-(void)launchMailAppOnDevice
{   
	NSString *recipients = @"mailto:nor.san@nawdsign.com?subject=Full-time App";
	NSString *body = @"&body=Hi Nor,";
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}

#pragma mark -
#pragma mark Error Views

- (void)loadErrorViewWith:(NSString *)string orError:(NSError *)error{
    [self.delegate loadErrorViewWith:string orError:error];
}

- (void)removeError {
    [self.delegate removeError];
}

#pragma mark - Unload

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.settingsTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.view.backgroundColor = [UIColor blackColor];
        self.settingsTableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_diagnal.png"]];
        
    }
    return self;
}

- (void)dealloc
{
    [settingsTableView release];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
