//
//  ItemDetailViewController.m
//  E-Report for iOS
//
//  Created by Nur Imelia on 08/03/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "ChecklistItem.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Resize.h"
#import "RadioButton.h"
#import <ParseUI/ParseUI.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "MBProgressHUB.h"
#import <Parse/Parse.h>

@interface ItemDetailViewController () {
  
            UIImage *originalImage;
}

@end

@implementation ItemDetailViewController


{
   NSString *name;
    NSString *notes;
    NSString *itemName;
    NSString *serviceFrequency;
    BOOL shouldRemind;
    NSDate *dueDate;
    NSDate *nextServiceDate;

}
-(IBAction)onRadioBtn:(RadioButton*)sender
{
        statusLabel.text = [NSString stringWithFormat:@"%@", sender.titleLabel.text];
}

@synthesize nameField;
@synthesize notesField;
@synthesize pickerTextField;
@synthesize delegate;
@synthesize itemToEdit;
@synthesize dueDateLabel;
@synthesize imageField, statusLabel;


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        itemName = @"";
        shouldRemind = NO;
        dueDate = [NSDate date];
        nextServiceDate = [NSDate date];

    }
    return self;
}

///method to update due date label
- (void)updateDueDateLabel
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    self.dueDateLabel.text = [formatter stringFromDate:dueDate];
}

///method to format update next service data lable
- (void)updateNextServiceDateLabel
{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    //self.nextServiceDateLabel.text = [formatter stringFromDate:nextServiceDate];
}

///Done bar button will be enabled only when itemName has soeme letters
- (void)updateDoneBarButton
{
    self.doneBarButton.enabled = ([itemName length] > 0);

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // background view with our own image
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];

    if (self.itemToEdit != nil) {
        self.title = @"Edit Item"; // set the title of edit view controller
         self.pickerTextField.text = self.itemToEdit.item;
        
    } else
    
        self.title = @"Add Item";   // set the title of add view controller
        self.nameField.text = name;
        self.notesField.text = notes;
        self.pickerTextField.text = itemName;
        self.imageField.image = self.itemToEdit.imageF;
        [self updateDoneBarButton];
        [self updateDueDateLabel];    
        [self updateNextServiceDateLabel];


    dataArray=[[NSArray alloc]initWithObjects: @"Monitor",@"Keyboard",@"Mouse",@"CPU", @"Air Con",@"Projector",@"Table",@"Chair", @"Door",@"Whiteboard",@"Switch", nil];
    UIPickerView *picker=[[UIPickerView alloc]init];
    picker.dataSource=self;
    picker.delegate=self;
    [self.pickerTextField setInputView:picker];
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(removePicker)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];

     [self.pickerTextField setInputAccessoryView:toolBar];
    
}
-(void)removePicker
{
    [self.pickerTextField resignFirstResponder];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation
                                         duration:(NSTimeInterval)duration {
 }


//To release the memory
- (void)viewDidUnload
{
    [self setNameField:nil];
    [self setNotesField:nil];
    [self setPickerTextField:nil];
    [self setDoneBarButton:nil];
    [self setDueDateLabel:nil];
    [super viewDidUnload];
}


// To dismiss the view
///when user tap cancel, we dismiss the view presented
- (IBAction)cancel
{
    [self.delegate itemDetailViewControllerDidCancel:self];
}


///When user finish adding information and press done button, we update the information in plist and display in cell
- (IBAction)done
{
  /*  if (self.itemToEdit == nil) {
        ChecklistItem *items = [[ChecklistItem alloc] init];
   //     item.text = self.textField.text;
        items.notes = self.notesField.text;
        items.item = self.pickerTextField.text;
        items.serviceFrequency = self.serviceFrequencyField.text;
        items.checked = NO;
        items.shouldRemind = self.switchControl.on;
        items.image = self.imageField.image;
        items.dueDate = dueDate;
        items.nextServiceDate = nextServiceDate;
        [items scheduleNotification];
        [self.delegate itemDetailViewController:self didFinishAddingItem:items];
    } else {

        self.itemToEdit.notes = self.notesField.text;
        self.itemToEdit.item = self.pickerTextField.text;
        self.itemToEdit.serviceFrequency = self.serviceFrequencyField.text;
        self.itemToEdit.shouldRemind = self.switchControl.on;
        self.itemToEdit.image = self.imageField.image;
        self.itemToEdit.dueDate = dueDate;
        self.itemToEdit.nextServiceDate = nextServiceDate;
        [self.itemToEdit scheduleNotification];
        [self.delegate itemDetailViewController:self didFinishEditingItem:self.itemToEdit];
    }*/

    
    // Create PFObject with report (ChecklistItem) information
    PFObject *report = [PFObject objectWithClassName:@"Report"];
    [report setObject:pickerTextField.text forKey:@"ItemName"];
    [report setObject:notesField.text forKey:@"Notes"];
    [report setObject:nameField.text forKey:@"Names"];
    [report setObject:dueDateLabel.text forKey:@"Date"];
    [report setObject:statusLabel.text forKey:@"TypeOfReport"];

    
    // Report image
    NSData *imageName = UIImageJPEGRepresentation(imageField.image, 0.8);
    NSString *filename = [NSString stringWithFormat:@"%@.png", pickerTextField.text];
    PFFile *imageFile = [PFFile fileWithName:filename data:imageName];
    [report setObject:imageFile forKey:@"Photo"];
    
    // Show progress
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"In Progress";
    [hud show:YES];
    
    
    // Upload report to Parse
    [report saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [hud hide:YES];
        
        if (!error) {
            // Show success message
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Complete" message:@"Successfully saved the report" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            // Notify table view to reload the report from Parse cloud
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            
            // Dismiss the controller
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }];
    
}


///Since our table view is a bit long, we can dismiss the keyboard, when user scrolls the tableview

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
  [self.radioButton resignFirstResponder];
    [self.notesField resignFirstResponder];
    [self.pickerTextField resignFirstResponder];

}

// To deactivate user interaction with static cell or row turns blue

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    if ( indexPath.section == 0 ) return nil;
    if ( indexPath.section == 2 ) return nil;

    
     if   ( indexPath.row == 1)
    {
        return indexPath;
        
    } else {
        
        return nil;
    }
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( indexPath.section == 0 ) {

    
    }else {
        
    }
}

// below code is to get the "Done" button in both locations (top bar buton and keyboard) to be available only when there is a text in the text filed

- (BOOL)textField:(UITextField *)theTextField shouldChangeCharactersInRange:(
                                                                             NSRange)range replacementString:(NSString *)string
{
    itemName = [theTextField.text stringByReplacingCharactersInRange:range withString
                                                                :string];
    [self updateDoneBarButton];
    return YES;
}



- (BOOL)notesField:(UITextView *)theNotesField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    notes = [theNotesField.text stringByReplacingCharactersInRange:range withString
                                                                :string];
    [self updateDoneBarButton];
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)theTextField
{
    itemName = theTextField.text;
    [self updateDoneBarButton];
}


///below method sets the information to edit

- (void)setItemToEdit:(ChecklistItem *)newItem
{
    if (itemToEdit != newItem) {
        itemToEdit = newItem;
        notes = itemToEdit.notes;
        itemName= itemToEdit.item;
        serviceFrequency = itemToEdit.serviceFrequency;
        shouldRemind = itemToEdit.shouldRemind;
        dueDate = itemToEdit.dueDate;
        nextServiceDate = itemToEdit.nextServiceDate;
    }
}

///we use segue method to detect and display the view accordingly. When the user tap on the date, we display date picker view and let the user to choose new date

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"PickDate"]) {
        DatePickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.date = dueDate;
    }
}


//if the user cancel date picker viw controller, we dismiss the view
- (void)datePickerDidCancel:(DatePickerViewController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


///if the user pick a new date from date view controller, then we need to update this new date to the date lable

- (void)datePicker:(DatePickerViewController *)picker didPickDate:(NSDate *)date
{
    dueDate = date;
    [self updateDueDateLabel];
    
    nextServiceDate = date;
    [self updateNextServiceDateLabel];

    [self dismissViewControllerAnimated:YES completion:nil];
}


 ///User have an option to tap on the frequecy button and choose the interval from presented picker ction sheet list

- (IBAction)frequency:(id)sender
{
    
    if (sheet) {
        [sheet dismissWithClickedButtonIndex:-1 animated:YES];
    }
    sheet = [[UIActionSheet alloc]
             initWithTitle:@"Select the interval?"
             delegate:self
             cancelButtonTitle:@"Cancel"
             destructiveButtonTitle:nil
             otherButtonTitles:@"Daily", @"Weekly", @"Monthly", @"Quarterly", @"Half Yearly", @"Yearly", nil];
    
    
    sheet.tag = 2; //assign a tag
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        UIButton * disclosureButton = (UIButton *)sender;

       // [sheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem  animated:YES];
        [sheet showFromRect:disclosureButton.bounds inView:sender animated:YES];

    }else{
        
        [sheet showInView:self.view];
        
    }
    
  }



///if the user choose to cancel

- (void)pickerActionSheetDidCancel:(UIActionSheet*)aPickerActionSheet
{
    // User cancelled
}



//when the user tap on the "+" button, we display uiaction sheet and ask the user to choose how he wanted to get the photo
-(IBAction) photoButtonClicked:(id)sender
{
    
    if (sheet) {
        [sheet dismissWithClickedButtonIndex:-1 animated:YES];
    }
    sheet = [[UIActionSheet alloc]
             initWithTitle:@"How do you want to get the Photo??"
             delegate:self
             cancelButtonTitle:@"Cancel"
             destructiveButtonTitle:nil
             otherButtonTitles:@"Camera",@"Album", nil];
    
    
    sheet.tag = 1; //assign a tag
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        UIButton * addbutton = (UIButton *)sender;
        
        // [sheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem  animated:YES];
        [sheet showFromRect:addbutton.bounds inView:sender animated:YES];

    }else{
        
        [sheet showInView:self.view];
        
    }
}

/// from user selection in action sheet, we displa the image picker controller

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {

    
    if (buttonIndex == 0) // display camera
    {
        if ([UIImagePickerController isSourceTypeAvailable:  // we check whether camera is available or not
             UIImagePickerControllerSourceTypeCamera])
        { // if available, we present the camera
            
            UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
            photoPicker.delegate = self;
            photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            photoPicker.allowsEditing = YES;
            self.imageField.image = nil;
            [self presentViewController:photoPicker animated:YES completion:NULL];
            
        }else
            
        { // if camera is not available, we display an alert message to the user to inform them
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle: @"Camera Not Found!"
                                  message: @"Camera not available in your device"
                                  delegate: nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
            [alert show];
            
        }
    }
        
    
    else  if (buttonIndex == 1) // display photo library
    {
        UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
        photoPicker.delegate = self;
        photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        photoPicker.allowsEditing = YES;
        self.imageField.image = nil;
        [self presentViewController:photoPicker animated:YES completion:NULL];
        
    } else  if (buttonIndex == 2) // cancel the action sheet
        
    {
        
    }
    }
    /*if (actionSheet.tag == 2) {
        
        if (buttonIndex == 0)
        {
            //self.serviceFrequencyField.text = @"Daily"; // we update the label
            
            //we also set the next service label to one day later
            NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
            [dateComponents setDay:1];
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDate* newDate = [calendar dateByAddingComponents:dateComponents toDate:dueDate options:0];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            
           // self.nextServiceDateLabel.text = [formatter stringFromDate:newDate];
            
            nextServiceDate = newDate;

        }
        if (buttonIndex == 1)
        {
        self.serviceFrequencyField.text = @"Weekly";
        
        
        //we also set the next service label to one week later
        NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
        [dateComponents setWeekOfMonth:1];
        NSCalendar* calendar = [NSCalendar currentCalendar];
        NSDate* newDate = [calendar dateByAddingComponents:dateComponents toDate:dueDate options:0];
        
        
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        
        self.nextServiceDateLabel.text = [formatter stringFromDate:newDate];
        
        nextServiceDate = newDate;
        
        }
        if (buttonIndex == 2)
        {
            self.serviceFrequencyField.text = @"Monthly";
            
            //we also set the next service label to one month later
            NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
            [dateComponents setMonth:1];
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDate* newDate = [calendar dateByAddingComponents:dateComponents toDate:dueDate options:0];
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            //        [formatter setTimeStyle:NSDateFormatterShortStyle];
            self.nextServiceDateLabel.text = [formatter stringFromDate:newDate];
            
            nextServiceDate = newDate;

        }
        
        if (buttonIndex == 3)
        {
            self.serviceFrequencyField.text = @"Quarterly";
            
            //we also set the next service label to three months later
            NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
            [dateComponents setMonth:3];
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDate* newDate = [calendar dateByAddingComponents:dateComponents toDate:dueDate options:0];
            
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            
            self.nextServiceDateLabel.text = [formatter stringFromDate:newDate];
            
            nextServiceDate = newDate;
            
            
        }
        if (buttonIndex == 4)
        {
            self.serviceFrequencyField.text = @"Half Yearly";
            
            //we also set the next service label to six months later
            NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
            [dateComponents setMonth:6];
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDate* newDate = [calendar dateByAddingComponents:dateComponents toDate:dueDate options:0];
            
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            
            self.nextServiceDateLabel.text = [formatter stringFromDate:newDate];
            
            nextServiceDate = newDate;
            
            
        }        if (buttonIndex == 5)
        {
            self.serviceFrequencyField.text = @"Yearly";
            
            //we also set the next service label to one year later
            NSDateComponents* dateComponents = [[NSDateComponents alloc]init];
            [dateComponents setYear:1];
            NSCalendar* calendar = [NSCalendar currentCalendar];
            NSDate* newDate = [calendar dateByAddingComponents:dateComponents toDate:dueDate options:0];
            
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            
            self.nextServiceDateLabel.text = [formatter stringFromDate:newDate];
            
            nextServiceDate = newDate;

            }
        
    }*/
}

//once the user take / pick the image, we let the user to edit the image 

- (void)imagePickerController:(UIImagePickerController *)photoPicker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    originalImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    originalImage = [info valueForKey:UIImagePickerControllerEditedImage];

    //we resize it
    UIImage *img=[UIImage_Resize imageWithImage:originalImage scaledToSize:CGSizeMake(100.0, 100.0)];

    
  // we apply this new image to the image field
   [self.imageField setImage:img];
    
    [photoPicker dismissViewControllerAnimated:YES completion:nil];
    

    //we mask the new photo with the personalchat image. the out put will be shaped according to the personalchat image
    CALayer *mask = [CALayer layer];
    mask.contents = (id)[[UIImage imageNamed:@"PersonalChat.png"] CGImage];
    mask.frame = CGRectMake(0, 0, 48, 48);
    imageField.layer.mask = mask;
    imageField.layer.masksToBounds = YES;
}

///if the user didn't pick or take any photo we assign a empty image

-(void)imagePickerControllerDidCancel: (UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.imageField.image = [UIImage imageNamed:@"PersonalChat.png"];

}

- (void)viewWillAppear
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UIPickerView DataSourde Method
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [dataArray count];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [dataArray objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
   // self.pickerRadioButton.selected=[dataArray objectAtIndex:row];
    self.pickerTextField.text=[dataArray objectAtIndex:row];
}



@end
