//
//  TipsViewController.h
//  Ajobs
//
//  Created by Nor Sanavongsay on 4/17/11.
//  Copyright 2011 nawDsign. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WalkthroughViewController.h"
#import "WebBrowserViewController.h"
#import "UIOverlay.h"


@protocol TipsViewControllerDelegate;

@interface TipsViewController : UIViewController <UITableViewDelegate,WalkthroughViewControllerDelegate,
WebBrowserViewControllerDelegate>{
    id<TipsViewControllerDelegate>delegate;
    
    NSMutableArray *tips;
    NSMutableDictionary *tipsData;
    
    UITableView *tipsTable;
    UIView *tableHeader;
}

@property (nonatomic, assign) id<TipsViewControllerDelegate> delegate;
@property (nonatomic, retain) NSMutableArray *tips;
@property (nonatomic, retain) NSMutableDictionary *tipsData;
@property (nonatomic, retain) IBOutlet UITableView *tipsTable;
@property (nonatomic, retain) IBOutlet UIView *tableHeader;

@property (nonatomic, copy) NSString *blogUrl;

- (void)loadFirstStartView;

@end

// create delegate functions
@protocol TipsViewControllerDelegate <NSObject>
- (void)hideMainView:(BOOL)yes whichSide:(NSString *)side;
- (void)loadErrorViewWith:(NSString *)string orError:(NSError *)error;
- (void)removeError;
@end