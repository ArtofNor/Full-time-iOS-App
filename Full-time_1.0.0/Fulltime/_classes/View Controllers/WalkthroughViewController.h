//
//  WalkthroughViewController.h
//  Ajobs
//
//  Created by Nor Sanavongsay on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WalkthroughViewControllerDelegate;

@interface WalkthroughViewController : UIViewController <UIScrollViewDelegate> {
    id<WalkthroughViewControllerDelegate>delegate;
    
    UIScrollView *scrollView;
    UIPageControl	*pageControl;
    BOOL pageControlUsed;
    
    UILabel *navtitle;
    UILabel *navtitleShadow;
    UILabel *description;
    
    UIButton *doneButton;
    NSMutableDictionary *walkthroughInfo;
}

@property (nonatomic, assign) id<WalkthroughViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

@property (nonatomic,retain) UILabel *navtitle;
@property (nonatomic,retain) UILabel *navtitleShadow;
@property (nonatomic,retain) IBOutlet UILabel *description;
@property (nonatomic,retain) IBOutlet UIButton *doneButton;
@property (nonatomic,retain) NSMutableDictionary *walkthroughInfo;

- (void) closeThisView;
- (void) setHelpInfo;

@end

// create delegate functions
@protocol WalkthroughViewControllerDelegate <NSObject>
- (void)walkthroughDidFinish:(WalkthroughViewController *)controller;
@end