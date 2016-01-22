//
//  MasterViewController.m
//  DemoCore
//
//  Created by GAYATHRI_P on 12/01/16.
//  Copyright (c) 2016 GAYATHRI_P. All rights reserved.
//

#import "ListsViewController.h"
#import "TasksTableViewController.h"
#import "List.h"
#define kshowsegue @"segue"
@interface ListsViewController ()
@property (nonatomic)BOOL showRenameButtons;
@end

@implementation ListsViewController

//
//-(void)viewDidAppear:(BOOL)animated
//{
//    List *list1= [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:self.managedObjectContext];
//    list1.title=@" iOS1 Dev";
//    
//    List *list2= [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:self.managedObjectContext];
//    list2.title=@" iOS2 Dev";
//    
//    List *list3= [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:self.managedObjectContext];
//    list3.title=@" iOS3 Dev";
//    
//    List *list4= [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:self.managedObjectContext];
//    list4.title=@" iOS4 Dev";
//    
//    [self saveContext];
//}


-(void)saveContext
{
    NSError *error = nil;
    if ([self.managedObjectContext hasChanges]   && ![self.managedObjectContext save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort    ();

}

}
#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"segue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        List *listforrow = [[self fetchedResultsController] objectAtIndexPath:indexPath];
//        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];
//        [controller setDetailItem:object];
//        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
//        controller.navigationItem.leftItemsSupplementBackButton = YES;
        
        [(TasksTableViewController *)[segue destinationViewController] setList:listforrow];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListsCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
            
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    [self setEditing:NO animated:YES];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
  //  cell.textLabel.text = [[object valueForKey:@"timeStamp"] description];
    List *listforrow = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text=listforrow .title;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%d",(int)listforrow.tasks.count];
    cell.accessoryType=(self.showRenameButtons ? UITableViewCellAccessoryDetailDisclosureButton : UITableViewCellAccessoryDisclosureIndicator);
}

-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    [self showDialogList:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"List" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:@"Lists"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
   return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

- (IBAction)PressedoptionMenu:(id)sender
{
    UIAlertController *ac=[UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *createlist=[UIAlertAction actionWithTitle:@"Create a List" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
    {
    //    NSLog(@"Create a List");
        [self showDialogList:nil];
    }];
    [ac addAction:createlist];
    
    
    UIAlertAction *editlist=[UIAlertAction actionWithTitle:self.editing ? @"Done editing"  :  @"Delete a List" style:self.editing?  UIAlertActionStyleDestructive :UIAlertActionStyleDestructive  handler:^(UIAlertAction *action)
                               {
                                   //NSLog(@"Edit a List");
                                   
                                   [self setEditing:!self.editing animated:YES];
                               }];
    [ac addAction:editlist];
    
    
    UIAlertAction *renameAction=[UIAlertAction actionWithTitle:self.showRenameButtons ? @"Hide rename Buttons" : @"Rename a List"style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                               {
//                                   NSLog(@"Rename a List");
                                   self.showRenameButtons =! self.showRenameButtons;
                                   [self.tableView reloadData];
                               }];
    [ac addAction:renameAction];
    
    
    UIAlertAction *deleteAction=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:deleteAction];
    
    [self presentViewController:ac animated:YES completion:nil];
}

-(void)showDialogList:(List *)listtoEdit
{
    UIAlertController *ac= [UIAlertController alertControllerWithTitle: listtoEdit == nil ?   @"Create the new list" : @"Rename the list" message:listtoEdit.title preferredStyle:UIAlertControllerStyleAlert];
    [ac addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
        textField .placeholder=@"Name for this list";
     }];
    
    UIAlertAction *okaction=[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                             {
                                 UITextField *textfield=ac.textFields.firstObject;
                                 
                                //NSLog(@"Create a List %@",textfield.text);
//                                 [self showDialogList:nil];
                                 
                                 if (listtoEdit ==nil)
                                 {
                                         List *newlist= [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:self.managedObjectContext];
                                         newlist.title=textfield.text;
                                 }
                                 else
                                 {
                                     listtoEdit.title=textfield.text;
                                     self.showRenameButtons=NO;
                                     [self.tableView reloadData];
                                 }
                                 [self saveContext];
                             }];
    [ac addAction:okaction];
    
    
    UIAlertAction *cancelAction=[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:cancelAction];
    
    [self presentViewController:ac animated:YES completion:nil];
}
@end
