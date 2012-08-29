//
//  CategoryViewController.h
//  Fulltime
//
//  Created by Nor Sanavongsay on 10/3/11.
//  Copyright 2011 nawDsign. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryViewControllerDelegate;

@interface CategoryViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>{
    id<CategoryViewControllerDelegate> delegate;
    NSArray *categories;
    UITableView *categoryTable;
    NSString *selectedCategory;
}

@property (nonatomic, assign) id<CategoryViewControllerDelegate> delegate;
@property (nonatomic, retain) NSArray *categories;
@property (nonatomic, retain) IBOutlet UITableView *categoryTable;
@property (nonatomic, retain) NSString *selectedCategory;

- (void)closeThisView;

@end

// create delegate functions
@protocol CategoryViewControllerDelegate <NSObject>
- (void)categoryViewDidFinish:(CategoryViewController *)controller;
- (void)setCategoryTitle:(NSString *)title andCategoryId:(NSString *)catid;
@end