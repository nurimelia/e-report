//
//  ListViewController.m
//  E-Report for iOS
//
//  Created by Nur Imelia on 08/03/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//

#import <MobileCoreServices/UTCoreTypes.h>
#import "ListViewController.h"
#import "DetailViewController.h"
#import "MBProgressHUB.h"

#import "ChecklistItem.h"
#import "Checklist.h"
#import <QuartzCore/QuartzCore.h>
#import "Parse/Parse.h"
#import <ParseUI/ParseUI.h>


@interface ListViewController ()

@end


@implementation ListViewController
 NSArray *checkItems;

@synthesize checklist;
@synthesize button;
@synthesize tableView = _tableView;

- (id)initWithCoder:(NSCoder *)aDecoder

{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        // Custom the table
        // The className to query on
        
        self.parseClassName = @"Report";

        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"ItemName";
        self.textKey = @"Notes";
        self.textKey = @"Date";
  
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = NO;
 
    }
    return self;
    
}

- (void)viewDidLoad

{
    ///title of view controller
    [super viewDidLoad];
    
    self.title = self.checklist.LabName;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTable:)
     name:@"refreshTable" object:nil];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    ///table view background with our own custom image
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:
                                     [UIImage imageNamed:@"background.png"]];
    
    ///initialize pull to refresh control
    [self.refreshControl
     addTarget:self
     action:@selector(refresh)
     forControlEvents:UIControlEventValueChanged
     
     ];
    
}

- (void)refreshTable:(NSNotification *) notification
{
    // Reload the Report
    [self loadObjects];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshTable" object:nil];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (PFQuery *)queryForTable

{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
   /* [query whereKey:@"objectIdLab" equalTo:@"objectID"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
       //     NSLog(@"Successfully retrieved %d report.", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];*/
    
   // if ([self.objects count] == 0) {
    //    query.cachePolicy = kPFCachePolicyCacheThenNetwork; }

   return query;
    }



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *) object
{
    
    static NSString *CellIdentifier = @"ReportCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
}

    // Configure the cell
    
    PFFile *thumbnail = [object objectForKey:@"Photo"];
    NSLog(@"******* thumbnail - LabImage = %@",thumbnail);
    PFImageView *thumbnailImageView = (PFImageView*)[cell viewWithTag:1777];
    thumbnailImageView.image = [UIImage imageNamed:@"placeholder.jpg"];
    thumbnailImageView.file = thumbnail;
    [thumbnailImageView loadInBackground];

    UILabel *nameLabel = (UILabel*) [cell viewWithTag:1700];
    nameLabel.text = [object objectForKey:@"ItemName"];
    
    UILabel *nextLabel = (UILabel*) [cell viewWithTag:1702];
    nextLabel.text = [object objectForKey:@"Date"];
    
    UILabel *notesLabel = (UILabel*) [cell viewWithTag:1701];
    notesLabel.text = [object objectForKey:@"Notes"];
 
    return cell;
    
}

- (void) objectsDidLoad:(NSError *)error
{
    [super objectsDidLoad:error];
    NSLog(@"error: %@", [error localizedDescription]);
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddItem"]) {
        UINavigationController *navigationController = segue.destinationViewController;
     
     ItemDetailViewController *controller = (ItemDetailViewController *)navigationController.topViewController;
     controller.delegate = self;

        }
    else if
        ([segue.identifier isEqualToString:@"showReportDetail"]) {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            
          DetailViewController *destViewController = segue.destinationViewController;
        
           // PFObject *object=[exerciseArray objectAtIndex:indexPath.row];
            
        PFObject *object = [self.objects objectAtIndex:indexPath.row];
        ChecklistItem *checklistItem = [[ChecklistItem alloc] init];
        
        checklistItem.item = [object objectForKey:@"ItemName"];
        checklistItem.imageF = [object objectForKey:@"Photo"];
             NSLog(@"******* imageF = %@",object );
        checklistItem.notes = [object objectForKey:@"Notes"];
            destViewController.checklistItem =checklistItem;
           
           // destViewController.checklistItem = [checkItems objectAtIndex:indexPath.row];
            //checklistItem;
    }
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation
                                         duration:(NSTimeInterval)duration {
    
}

/*- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(
 NSInteger)section
 {
 return [self.checklist.items count];
 }*/

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    
    }else{
        
        cell.contentView.backgroundColor = [UIColor clearColor];
        UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(7,7,306,70)];
        whiteRoundedCornerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"list-item-bg.png"]];
        whiteRoundedCornerView.layer.masksToBounds = NO;
        whiteRoundedCornerView.layer.cornerRadius = 5.0;
        whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(-1, 1);
        whiteRoundedCornerView.layer.shadowOpacity = 0.5;
        [cell.contentView addSubview:whiteRoundedCornerView];
        [cell.contentView sendSubviewToBack:whiteRoundedCornerView];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return 78;
}

/// following method configures uitableviewcell text when user adds a new item
- (void)configureTextForCell:(UITableViewCell *)cell withChecklistItem:(ChecklistItem *)item
{

    UILabel *itemLabel = (UILabel *)[cell viewWithTag:1700];
    itemLabel.text = item.item;
    UILabel *notesLabel = (UILabel *)[cell viewWithTag:1701];
    notesLabel.text = item.notes;
    //making the image
    if (item.imageF != nil) {
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1100];
        imageView.image = item.imageF;
        CALayer *mask = [CALayer layer];
        mask.contents = (id)[[UIImage imageNamed:@"PersonalChat.png"] CGImage];
        mask.frame = CGRectMake(0, 0, 48, 48);
        imageView.layer.mask = mask;
        imageView.layer.masksToBounds = YES;
   
    }else {
        
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1100];
        imageView.image = [UIImage imageNamed:@"PersonalChat.png"];
        
    }
    
    if (item.shouldRemind == YES) {
 
        UILabel *dueDateLabel = (UILabel *)[cell viewWithTag:1702];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        //  [formatter setTimeStyle:NSDateFormatterShortStyle];
        dueDateLabel.text = [formatter stringFromDate:item.nextServiceDate];
        
        UIButton *calander = (UIButton *)[cell viewWithTag:1703];
        calander.hidden=FALSE;
  
    } else
        
    {
        UILabel *dueDateLabel = (UILabel *)[cell viewWithTag:1702];
        dueDateLabel.text = nil;
        UIButton *calander = (UIButton *)[cell viewWithTag:1703];
        calander.hidden=TRUE;
    }
}


///The delegate handles selections in this method. One of the things it can do is exclusively assign the check-mark image (UITableViewCellAccessoryCheckmark) to one row in a section (radio-list style). This method isn’t called when the editing property of the table is set to YES (that is, the table view is in editing mode)

///when the user tap on the particular cell, we display the item.

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath
                                                                    
                                                                    *)indexPath

{
    
    ChecklistItem *item = [self.checklist.items objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"showReportDetail" sender:item];
    
}

///A swipe motion across a cell does not cause the display of a Delete button unless the table view's data source implements the tableView:commitEditingStyle:forRowAtIndexPath: method.

///When users tap the insertion (green plus) control or Delete button associated with a UITableViewCell object in the table view, the table view sends this message to the data source, asking it to commit the change. (If the user taps the deletion (red minus) control, the table view then displays the Delete button to get confirmation.) The data source commits the insertion or deletion by invoking the UITableView methods insertRowsAtIndexPaths:withRowAnimation: or deleteRowsAtIndexPaths:withRowAnimation:, as appropriate.



///when user swip left to right or right to left, table view enters into editing mode and prepares to delete the data from table view. once user deleted, we remove that particular item from plist.

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
    // Remove the row from data model
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    [object deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self refreshTable:nil];
    }];
    
    [self.checklist.items removeObjectAtIndex:indexPath.row];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationLeft];
  
}

//To recive delegates from additemviewcontroller

- (void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//add the new ChecklistItem to our data model and table view
- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItem *)item

{
    int newRowIndex =(int) [self.checklist.items count];
    [self.checklist.items addObject:item];

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(IBAction) addItem:(id)sender

{
    //execute segue programmatically
    [self performSegueWithIdentifier:@"AddItem" sender:self];
    
}

///we display when the user tap on a cell

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath

{
    
  /*  ChecklistItem *item = [self.checklist.items objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"EditItem" sender:item];
 */
}

///Save the added item and dismiss view controller presented

- (void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem *)item

{
    int index = (int)[self.checklist.items indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self configureTextForCell:cell withChecklistItem:item];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

///A UIRefreshControl object provides a standard control that can be used to initiate the refreshing of a table view’s contents. You link a refresh control to a table through an associated table view controller object. The table view controller handles the work of adding the control to the table’s visual appearance and managing the display of that control in response to appropriate user gestures. In addition to assigning a refresh control to a table view controller’s refreshControl property, you must configure the target and action of the control itself. The control does not initiate the refresh operation directly. Instead, it sends the UIControlEventValueChanged event when a refresh operation should occur. You must assign an action method to this event and use it to perform whatever actions are needed. The UITableViewController object that owns a refresh control is also responsible for setting that control’s frame rectangle. Thus, you do not need to manage the size or position of a refresh control directly in your view hierarchy.



///refresh (aka pulltorefresh activated additem identifier. Upon activation, we stop refreshing.

- (void)refresh

{
    
    [self performSegueWithIdentifier:@"AddItem" sender:self];

    [self.refreshControl endRefreshing];
    
}

@end

