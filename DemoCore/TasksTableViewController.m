//
//  TasksTableViewController.m
//  DemoCore
//
//  Created by GAYATHRI_P on 13/01/16.
//  Copyright (c) 2016 GAYATHRI_P. All rights reserved.
//

#import "TasksTableViewController.h"
#import "AppDelegate.h"
#import "List.h"
#import "Task.h"
@interface TasksTableViewController ()
@property (nonatomic,strong)NSArray *tasks;
@end

@implementation TasksTableViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title=self.list.title;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    
    if (self.list.tasks.count==0)
    {
        AppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
        NSManagedObjectContext *context=appDelegate .managedObjectContext;
        Task *task1= [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:context];
        task1.task=@" Demo of iOS1 Dev";
        task1.list=self.list;
        task1.starred=@YES;
        [self saveContext];
        self.tasks=nil;
        [self.tableView reloadData];
    }
    
}


-(void)saveContext
{
    NSError *error = nil;
    
    AppDelegate *appDelegate=[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context=appDelegate .managedObjectContext;
    
    if ([context hasChanges]   && ![context save:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
        
    }

}
#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

    
    -(NSArray *)tasks
    {
        if (_tasks==nil)
        {
            _tasks=[self.list.tasks.allObjects sortedArrayUsingComparator:^NSComparisonResult(Task * task1,Task * task2)
                    {
                        if ([task1.starred boolValue] && ![task2.starred boolValue])
                        {
                            return NSOrderedAscending;
                        }
                        else
                            if (![task1.starred boolValue] && [task2.starred boolValue])
                            {
                                return NSOrderedDescending;
                            }
                            else
                            {
                                return [task1.task compare:task2.task options:NSCaseInsensitiveSearch];
                            }
                        
                        
                    }];
        }
        return _tasks;
    }
    
    
    
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.tasks .count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    Task *taskrow=self.tasks[indexPath.row];
    cell.textLabel.text=taskrow.task;
    if ([taskrow.starred boolValue])
    {
        cell.detailTextLabel.text=@"Starred";
    }
    else
    {
        cell.detailTextLabel.text=nil;  
    }
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
