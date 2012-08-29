//
//  ViewController.m
//  Fulltime
//
//  Created by Nor Sanavongsay on 11/17/11.
//  Copyright (c) 2011 nawDsign. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "FontLabel.h"
#import "FontLabelStringDrawing.h"
#import "FontManager.h"

#import "ViewController.h"

#define viewtag 2486
#define settingstag 2487
#define categorytag 2488
#define infotag 2489
#define viewshadowRadius 8.0
#define mainviewhideamount 415

@implementation ViewController

@synthesize appdelegate;
@synthesize mainWindow;
@synthesize joblistTable;
@synthesize navBar,tabBar;
@synthesize settingsButton,infoButton,categoryButton,locationButton;
@synthesize navtitle;
@synthesize detailView;
@synthesize blueLight;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = self.view.frame;
    frame.origin = CGPointMake(0, 20);
    self.view.frame = frame;
    
	// Do any additional setup after loading the view, typically from a nib.
    self.view.layer.shadowOpacity = 1.0;
    self.view.layer.shadowRadius = 0.0;
    self.view.layer.shadowOffset = CGSizeMake(0,0);
    self.view.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgrounddark.png"]];
    
    self.appdelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
	//self.navtitle = [[[FontLabel alloc] initWithFrame:CGRectMake(75, 8,170,30) fontName:@"aventura" pointSize:24.0f] autorelease];
	self.navtitle = [[[UILabel alloc] initWithFrame:CGRectMake(75, 8,170,30) ] autorelease];
    self.navtitle.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
    self.navtitle.backgroundColor = [UIColor clearColor];
    self.navtitle.textColor = [UIColor whiteColor];
    self.navtitle.textAlignment = UITextAlignmentCenter;
    self.navtitle.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.navtitle.adjustsFontSizeToFitWidth = YES;
    [self.navBar addSubview:self.navtitle];
    
    [self.infoButton addTarget:self action:@selector(loadTipsView) forControlEvents:UIControlEventTouchUpInside];
    [self.settingsButton addTarget:self action:@selector(loadSettingsView) forControlEvents:UIControlEventTouchUpInside];
    [self.categoryButton addTarget:self action:@selector(loadCategories) forControlEvents:UIControlEventTouchUpInside];
    [self.locationButton addTarget:self action:@selector(loadLocationView) forControlEvents:UIControlEventTouchUpInside];
    
    if (![[NSUserDefaults standardUserDefaults] stringForKey:@"currentType"] && ![[NSUserDefaults standardUserDefaults] stringForKey:@"currentPage"] && ![[NSUserDefaults standardUserDefaults] stringForKey:@"currentCategory"] && ![[NSUserDefaults standardUserDefaults] stringForKey:@"perPage"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"1,2,3,4" forKey:@"currentType"];
        [[NSUserDefaults standardUserDefaults] setObject:@"All Jobs" forKey:@"currentCategory"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"currentCategoryId"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"currentPage"];
        [[NSUserDefaults standardUserDefaults] setObject:@"Anywhere" forKey:@"userLocation"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"userLocationId"];
        [[NSUserDefaults standardUserDefaults] setObject:@"100" forKey:@"perPage"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    [self setCategoryTitle:[[NSUserDefaults standardUserDefaults] stringForKey:@"currentCategory"] 
             andCategoryId:[[NSUserDefaults standardUserDefaults] stringForKey:@"currentCategoryId"]];
    
    if (self.joblistTable == nil) {
        JobListTableViewController *controller = [[JobListTableViewController alloc] initWithNibName:@"JobListTableViewController" bundle:nil];
        self.joblistTable = controller;
        [controller release];
    }
    self.joblistTable.view.frame = CGRectMake(0,85,
                                              self.view.bounds.size.width,
                                              self.view.bounds.size.height - (self.tabBar.bounds.size.height + self.navBar.bounds.size.height)+10);
    self.joblistTable.view.backgroundColor = [UIColor clearColor];
    
    if (![self.joblistTable.view isDescendantOfView:self.view]) {
        [self.view insertSubview:self.joblistTable.view belowSubview:self.tabBar];
    }
    
    [self.joblistTable setDelegate:self];
    
    // set selected bars
    if([[NSUserDefaults standardUserDefaults] stringForKey:@"currentType"]){
        NSString *cType = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentType"];
        NSArray	*typeArray	= [cType componentsSeparatedByString:@","];
        for (UIButton *button in self.tabBar.subviews){
            if ([button isKindOfClass:[UIButton class]]) {
                button.selected = NO;
            }
        }
        for(id type in typeArray){
            int typ = [type intValue];
            for (UIButton *button in self.tabBar.subviews){
                if ([button isKindOfClass:[UIButton class]] && button.tag == typ) {
                    button.selected = YES;
                }
            }
        }
    }
    
    [self loadJobs];
}

- (void)viewDidUnload
{
    self.appdelegate = nil;
    self.tabBar = nil;
    self.settingsButton = nil;
    self.infoButton = nil;
    self.categoryButton = nil;
    self.locationButton = nil;
    self.blueLight = nil;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLoad"]) {
        [self.appdelegate howtoOverlay:@"hint_overlay.png"];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Tabbar Selected

- (IBAction) setTabSelected:(id)sender {
    [self.joblistTable setCurrentType:@""];
    if ([sender isSelected]) {
        [sender setSelected:NO];
    } else {
        [sender setSelected:YES];
    }
    for (UIButton *butt in self.tabBar.subviews) {
        if ([butt isKindOfClass:[UIButton class]] && [butt isSelected] && butt.tag != 0) {
            //NSLog(@"selected: %i",butt.tag);
            if ([self.joblistTable.currentType isEqualToString:@""]) {
                [self.joblistTable setCurrentType:[NSString stringWithFormat:@"%i",butt.tag]];
            } else {
                [self.joblistTable setCurrentType:[NSString stringWithFormat:@"%@,%i",self.joblistTable.currentType,butt.tag]];
            }
        }
        butt = nil;
    }
    if ([self.joblistTable.currentType isEqualToString:@""]) {
        [self.joblistTable setCurrentType:@"0"];
        [self loadErrorViewWith:@"Please select at least one job type." orError:nil];
    }
    
    [self.joblistTable refreshFromServer:NO withLoadingAnimation:NO];
}

- (void)loadJobs{
    self.joblistTable.currentCategoryId = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentCategoryId"];
    self.joblistTable.currentType       = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentType"];
    self.joblistTable.currentPage       = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentPage"];
    self.joblistTable.userLocation      = [[NSUserDefaults standardUserDefaults] stringForKey:@"userLocationId"];
    [self.joblistTable refreshFromServer:YES withLoadingAnimation:YES];
}

- (void)setCategoryTitle:(NSString *)title andCategoryId:(NSString *)catid{
    self.navtitle.text = title;
    
    [self.joblistTable setCurrentCategoryId:catid];
    [self.joblistTable refreshFromServer:YES withLoadingAnimation:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:title forKey:@"currentCategory"];
    [[NSUserDefaults standardUserDefaults] setObject:catid forKey:@"currentCategoryId"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)loadCategories {
    
    if (![self.mainWindow viewWithTag:categorytag]) {
        [[self.mainWindow viewWithTag:settingstag] removeFromSuperview];
        [[self.mainWindow viewWithTag:infotag] removeFromSuperview];
        [[self.mainWindow viewWithTag:viewtag] removeFromSuperview];
        CategoryViewController *controller = [[CategoryViewController alloc] initWithNibName:@"CategoryViewController" bundle:nil];
        controller.delegate = self;
        controller.view.tag = categorytag;
        CGRect frame = controller.view.frame;
        frame.origin = CGPointMake(0, 0);
        controller.view.frame = frame;
        controller.view.transform = CGAffineTransformMakeScale(0.95,0.95);
        controller.selectedCategory = [[NSUserDefaults standardUserDefaults] stringForKey:@"currentCategory"];
        [self.mainWindow insertSubview:controller.view belowSubview:self.view];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.transform=CGAffineTransformMakeTranslation(0,mainviewhideamount);
            self.view.layer.shadowRadius = viewshadowRadius;
            [self.mainWindow viewWithTag:categorytag].transform = CGAffineTransformMakeScale(1,1);
            self.blueLight.alpha = 1;
            self.blueLight.transform = CGAffineTransformMakeTranslation(140,-1);
            self.navtitle.alpha = 0;
        } completion:^(BOOL finished) { }];
        //[TestFlight passCheckpoint:@"Categories"];
    } else {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, 0);
            self.view.layer.shadowRadius = 0.0;
            [self.mainWindow viewWithTag:categorytag].transform = CGAffineTransformMakeScale(0.95,0.95);
            self.blueLight.alpha = 0;
            self.navtitle.alpha = 1;
        } completion:^(BOOL finished) {
            [[self.mainWindow viewWithTag:categorytag] removeFromSuperview];
        }];
    }
}

- (void)categoryViewDidFinish:(CategoryViewController *)controller{
    [self loadCategories];
    [controller.view removeFromSuperview];
    [controller release];
}

- (void)startLoadingWithPulldown{
    [self.joblistTable startLoading];
}

#pragma mark -
#pragma mark Load Detail Views

- (void)loadDetailViewWithData:(NSDictionary *)aJobs andImage:(UIImage *)image{
    if (![self.mainWindow viewWithTag:viewtag]) {
        DetailViewController *controller = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
        controller.delegate = self;
        controller.view.tag = viewtag;
        CGRect frame = controller.view.frame;
        frame.origin = CGPointMake(0, 20);
        controller.view.frame = frame;
        controller.view.transform = CGAffineTransformMakeTranslation(0,480);
        [self.mainWindow insertSubview:controller.view aboveSubview:self.view];
        [controller showData:aJobs andImage:image];
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.view.transform = CGAffineTransformMakeScale(0.95,0.95);
            self.view.alpha = 0.8;
            controller.view.transform = CGAffineTransformMakeTranslation(0,0);
        } completion:^(BOOL finished) { 
            [self.view removeFromSuperview];
        }];
        
        //[TestFlight passCheckpoint:@"Details"];
    }
}

- (void)detailViewDidFinish:(DetailViewController *)controller {
    [self.mainWindow insertSubview:self.view belowSubview:controller.view];
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.view.transform = CGAffineTransformMakeScale(1,1);
        self.view.alpha = 1;
        controller.view.transform = CGAffineTransformMakeTranslation(0,480);
    } completion:^(BOOL finished) { 
        [[self.mainWindow viewWithTag:viewtag] removeFromSuperview];
    }];
}

#pragma mark -
#pragma mark Load Locations Views

- (void)loadLocationView {
    if (![self.mainWindow viewWithTag:viewtag]) {
        LocationViewController *controller = [[LocationViewController alloc] initWithNibName:@"LocationViewController" bundle:nil];
        controller.delegate = self;
        controller.view.tag = viewtag;
        CGRect frame = controller.view.frame;
        frame.origin = CGPointMake(0, 20);
        controller.view.frame = frame;
        controller.view.transform = CGAffineTransformMakeTranslation(0,480);
        [self.mainWindow insertSubview:controller.view aboveSubview:self.view];
        
        [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.view.transform = CGAffineTransformMakeScale(0.95,0.95);
            self.view.alpha = 0.8;
            controller.view.transform = CGAffineTransformMakeTranslation(0,0);
        } completion:^(BOOL finished) { 
            [self.view removeFromSuperview];
        }];
        
        //[TestFlight passCheckpoint:@"Locations"];
    }
}

- (void)locationViewDidFinish:(LocationViewController *)controller {
    [self.mainWindow insertSubview:self.view belowSubview:controller.view];
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.view.transform = CGAffineTransformMakeScale(1,1);
        self.view.alpha = 1;
        controller.view.transform = CGAffineTransformMakeTranslation(0,480);
    } completion:^(BOOL finished) { 
        [[self.mainWindow viewWithTag:viewtag] removeFromSuperview];
        [self checkForSettingChange];
    }];
}


#pragma mark -
#pragma mark Load Tips Views

- (void)loadTipsView {
    if (![self.mainWindow viewWithTag:infotag]) {
        [[self.mainWindow viewWithTag:settingstag] removeFromSuperview];
        [[self.mainWindow viewWithTag:categorytag] removeFromSuperview];
        [[self.mainWindow viewWithTag:viewtag] removeFromSuperview];
        TipsViewController *controller = [[TipsViewController alloc] initWithNibName:@"TipsViewController" bundle:nil];
        controller.delegate = self;
        controller.view.tag = infotag;
        CGRect frame = controller.view.frame;
        frame.origin = CGPointMake(0, 0);
        controller.view.frame = frame;
        controller.view.transform = CGAffineTransformMakeScale(0.95,0.95);
        [self.mainWindow insertSubview:controller.view belowSubview:self.view];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.transform=CGAffineTransformMakeTranslation(0,mainviewhideamount);
            self.view.layer.shadowRadius = viewshadowRadius;
            [self.mainWindow viewWithTag:infotag].transform = CGAffineTransformMakeScale(1,1);
            self.blueLight.alpha = 1;
            self.blueLight.transform = CGAffineTransformMakeTranslation(6,-1);
            self.navtitle.alpha = 1;
        } completion:^(BOOL finished) { }];
        //[TestFlight passCheckpoint:@"Tips"];
    } else {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, 0);
            self.view.layer.shadowRadius = 0.0;
            [self.mainWindow viewWithTag:infotag].transform = CGAffineTransformMakeScale(0.95,0.95);
            self.blueLight.alpha = 0;
        } completion:^(BOOL finished) {
            [[self.mainWindow viewWithTag:infotag] removeFromSuperview];
        }];
    }
}

#pragma mark -
#pragma mark Load Settings Views

- (void)loadSettingsView {
    if (![self.mainWindow viewWithTag:settingstag]) {
        [[self.mainWindow viewWithTag:categorytag] removeFromSuperview];
        [[self.mainWindow viewWithTag:infotag] removeFromSuperview];
        [[self.mainWindow viewWithTag:viewtag] removeFromSuperview];
        self.navtitle.alpha = 1;
        SettingsViewController *controller = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
        controller.delegate = self;
        controller.view.tag = settingstag;
        CGRect frame = controller.view.frame;
        frame.origin = CGPointMake(0, 0);
        controller.view.frame = frame;
        controller.view.transform = CGAffineTransformMakeScale(0.95,0.95);;
        [self.mainWindow insertSubview:controller.view belowSubview:self.view];
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.transform=CGAffineTransformMakeTranslation(0,mainviewhideamount);
            self.view.layer.shadowRadius = viewshadowRadius;
            [self.mainWindow viewWithTag:settingstag].transform = CGAffineTransformMakeScale(1,1);
            self.blueLight.alpha = 1;
            self.blueLight.transform = CGAffineTransformMakeTranslation(273,-1);
            self.navtitle.alpha = 1;
        } completion:^(BOOL finished) { }];
        //[TestFlight passCheckpoint:@"Settings"];
    } else {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.transform = CGAffineTransformMakeTranslation(0, 0);
            self.view.layer.shadowRadius = 0.0;
            [self.mainWindow viewWithTag:settingstag].transform = CGAffineTransformMakeScale(0.95,0.95);
            self.blueLight.alpha = 0;
        } completion:^(BOOL finished) {
            [[self.mainWindow viewWithTag:settingstag] removeFromSuperview];
            [self checkForSettingChange];
        }];
    }
}

- (void)checkForSettingChange {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"changeSetting"]) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"changeSetting"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.joblistTable refreshFromServer:YES withLoadingAnimation:YES];
    }
}

#pragma mark -
#pragma mark hide main view

- (void)hideMainView:(BOOL)yes whichSide:(NSString *)side{
    if (yes) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.layer.shadowRadius = 0.0;
            if([side isEqualToString:@"left"]){
                self.view.transform=CGAffineTransformMakeTranslation(0,480);
            } else {
                self.view.transform=CGAffineTransformMakeTranslation(0,480);
            }
        } completion:^(BOOL finished) { }];
    } else {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.view.layer.shadowRadius = viewshadowRadius;
            if([side isEqualToString:@"left"]){
                self.view.transform=CGAffineTransformMakeTranslation(0,mainviewhideamount);
            } else {
                self.view.transform=CGAffineTransformMakeTranslation(0,mainviewhideamount);
            }
        } completion:^(BOOL finished) { }];
    }
}

#pragma mark -
#pragma mark Error Views

- (void)loadErrorViewWith:(NSString *)string orError:(NSError *)error{
    [self.appdelegate loadErrorViewWith:string orError:error];
}

- (void)removeError {
    [self.appdelegate removeError];
}

#pragma mark -
#pragma mark Loading Indicator

- (void)initSpinner {
    [self.appdelegate initSpinner];
}

- (void)spinBegin {
	[self.appdelegate spinBegin];
}

- (void)spinEnd {
	[self.appdelegate spinEnd];
}

- (void) removeOverlay:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	[self.appdelegate removeOverlay:animationID finished:finished context:context];
}

@end
