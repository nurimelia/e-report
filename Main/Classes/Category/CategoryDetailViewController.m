//
//  CategoryDetailViewController.m
//  E-Report for iOS
//
//  Created by Nur Imelia on 08/03/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//

#import "Checklist.h"
#import "CategoryDetailViewController.h"
#import <Parse/Parse.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "MBProgressHUB.h"
#import <ParseUI/ParseUI.h>

@interface CategoryDetailViewController ()

@end

@implementation CategoryDetailViewController {
    NSString *iconName;

}

@synthesize textField;
//@synthesize notesField;
@synthesize doneBarButton;
@synthesize delegate;
@synthesize checklistToEdit;
@synthesize iconImageView;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        iconName = @"Folder";
    }
    return self;
}


- (void)viewDidLoad
{

    [super viewDidLoad];
    
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:
                                     [UIImage imageNamed:@"background.png"]];
    

    textField.delegate = self;
    
    if (self.checklistToEdit != nil) {
        self.title = @"Edit Category";
        self.textField.text = self.checklistToEdit.category;
       // self.notesField.text = self.checklistToEdit.notes;
        
        self.doneBarButton.enabled = YES;
        iconName = self.checklistToEdit.iconName;
        
    } else
        self.title = @"New Category";


    self.iconImageView.image = [UIImage imageNamed:iconName];
   
    
}



- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation
                                         duration:(NSTimeInterval)duration {
   
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.textField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [self setIconImageView:nil];
    [self setTextField:nil];
   // [self setNotesField:nil];
    [self setDoneBarButton:nil];
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancel
{
    [self.delegate listDetailViewControllerDidCancel:self];
}

- (IBAction)done
{

    // Create PFObject with lab (Checklist) information
    PFObject *Checklist = [PFObject objectWithClassName:@"laboratory"];
    [Checklist setObject:textField.text forKey:@"Lab_Name"];
    
    // Lab image
    NSData *iconName = UIImageJPEGRepresentation(iconImageView.image, 0.8);
    NSString *filename = [NSString stringWithFormat:@"%@.png", textField.text];
    PFFile *imageFile = [PFFile fileWithName:filename data:iconName];
    [Checklist setObject:imageFile forKey:@"Lab_Image"];
    
    // Show progress
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Progressing";
    [hud show:YES];
    
    
    // Upload lab to Parse
    [Checklist saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [hud hide:YES];
        
        if (!error) {
            // Show success message
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Complete" message:@"Successfully saved the category" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            // Notify table view to reload the recipes from Parse cloud
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            
            // Dismiss the controller
            [self dismissViewControllerAnimated:YES completion:nil];
            
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            self.checklistToEdit.category = self.textField.text;
            self.checklistToEdit.iconName = iconName;
            [self.delegate listDetailViewController:self didFinishEditingChecklist:self
             .checklistToEdit];

        }
        
    }];
    
   /* if (self.checklistToEdit == nil) {
        Checklist *checklist = [[Checklist alloc] init];
        checklist.category = self.textField.text;
    //    checklist.notes = self.notesField.text;
        checklist.iconName = iconName;
        [self.delegate listDetailViewController:self didFinishAddingChecklist:
         checklist];
    } else {
        self.checklistToEdit.category = self.textField.text;
      //  self.checklistToEdit.notes = self.notesField.text;
        self.checklistToEdit.iconName = iconName;
        [self.delegate listDetailViewController:self didFinishEditingChecklist:self
         .checklistToEdit];
    }*/
  
    }


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1) {
        return indexPath;
    } else {
        return nil;
    }
}

- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newText = [theTextField.text stringByReplacingCharactersInRange:range withString:string];
    self.doneBarButton.enabled = ([newText length] > 0);
    return YES;
    
}





#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
    
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PickIcon"]) {
        IconPickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}


- (void)iconPicker:(IconPickerViewController *)picker didPickIcon:(NSString *)
theIconName
{
    iconName = theIconName;
    self.iconImageView.image = [UIImage imageNamed:iconName];
    [self.navigationController popViewControllerAnimated:YES];
}




- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.textField resignFirstResponder];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textField resignFirstResponder];
    return YES;
}



@end
