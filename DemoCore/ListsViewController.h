//
//  MasterViewController.h
//  DemoCore
//
//  Created by GAYATHRI_P on 12/01/16.
//  Copyright (c) 2016 GAYATHRI_P. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class DetailViewController;

@interface ListsViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)PressedoptionMenu:(id)sender;

@end

