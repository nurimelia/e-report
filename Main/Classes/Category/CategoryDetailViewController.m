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

@interface CategoryDetailViewController ()

@end

@implementation CategoryDetailViewController {
    NSString *iconName;
    NSString *Lab_Name;
    NSString *Lab_Image;
}

@synthesize textField;
//@synthesize numberPlateTextField;
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
    

    
    
    if (self.checklistToEdit != nil) {
        self.title = @"Edit Category";
        self.textField.text = self.checklistToEdit.category;
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
    [self setTextField:nil];
  //  [self setNumberPlateTextField:nil];
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
  /*  PFObject *lab = [PFObject objectWithClassName:@"laboratory"];
    [lab setObject:textField.text forKey:@"Lab_Name"];
    //[lab setObject:textField.text forKey:@"Lab_Name"];
    
    NSData *imageData = UIImageJPEGRepresentation(iconImageView.image, 0.8);
    NSString *filename = [NSString stringWithFormat:@"%@.png", textField.text];
    PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
    [lab setObject:imageFile forKey:@"Lab_Image"];
    
    // Show progress
   
    [lab saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Show success message
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the recipe" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            // Notify table view to reload the recipes from Parse cloud
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            
            // Dismiss the controller
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }*/
        
        
    if (self.checklistToEdit == nil) {
        Checklist *checklist = [[Checklist alloc] init];
        checklist.category = self.textField.text;
        checklist.iconName = iconName;
        [self.delegate listDetailViewController:self didFinishAddingChecklist:
         checklist];
    } else {
        self.checklistToEdit.category = self.textField.text;
        self.checklistToEdit.iconName = iconName;
        [self.delegate listDetailViewController:self didFinishEditingChecklist:self
         .checklistToEdit];
    }
   /* }];*/
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




@end
