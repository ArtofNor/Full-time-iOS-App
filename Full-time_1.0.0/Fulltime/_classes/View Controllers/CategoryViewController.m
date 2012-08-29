//
//  CategoryViewController.m
//  Fulltime
//
//  Created by Nor Sanavongsay on 10/3/11.
//  Copyright 2011 nawDsign. All rights reserved.
//
#import "CategoryViewController.h"
#import "CategoryCell.h"

@implementation CategoryViewController

@synthesize delegate;
@synthesize categories;
@synthesize categoryTable;
@synthesize selectedCategory;

- (void) closeThisView{
    if([self.delegate respondsToSelector:@selector(categoryViewDidFinish:)]) {
        [self.delegate categoryViewDidFinish:self];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSData *plistData;  
        NSString *error;  
        NSPropertyListFormat format;
        NSDictionary *plist;
        
        NSString *localizedPath = [[NSBundle mainBundle] pathForResource:@"categories" ofType:@"plist"];  
        plistData = [NSData dataWithContentsOfFile:localizedPath];   
        
        plist = [NSPropertyListSerialization propertyListFromData:plistData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];  
        if (!plist) {  
            NSLog(@"Error reading plist from file '%s', error = '%s'", [localizedPath UTF8String], [error UTF8String]);  
            [error release];  
        } else {
            self.categories = [plist objectForKey:@"category"];
        }
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    self.categoryTable.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background_diagnal.png"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.categories count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
	CategoryCell *cell = (CategoryCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
		cell = (CategoryCell *)[[[CategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSDictionary *category = [self.categories objectAtIndex:indexPath.row];
    cell.textLabel.text = [category objectForKey:@"name"];
    
    if ([[category objectForKey:@"name"] isEqualToString:selectedCategory]) {
        cell.radiobutton.image = [UIImage imageNamed:@"radiobutton_on.png"];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font  = [UIFont boldSystemFontOfSize:16.0];
    } else {
        cell.radiobutton.image = [UIImage imageNamed:@"radiobutton_off.png"];
        cell.textLabel.textColor = [UIColor lightGrayColor];
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(setCategoryTitle:andCategoryId:)]) {
        NSDictionary *category = [self.categories objectAtIndex:indexPath.row];
        NSString *catid = [NSString stringWithFormat:@"%@",[category objectForKey:@"id"]];
        [self.delegate setCategoryTitle:[category objectForKey:@"name"] andCategoryId:catid];
    }
    
    [self closeThisView];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
