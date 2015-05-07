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
}

@synthesize textField;
@synthesize numberPlateTextField;
@synthesize doneBarButton;
@synthesize delegate;
@synthesize checklistToEdit;

@synthesize adMobView;


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
    
    
    GADAdSize adSize = [self adSizeForOrientation:self.interfaceOrientation];
    bannerView_ = [[GADBannerView alloc] initWithAdSize:adSize];
    
    
    bannerView_.adUnitID = MY_BANNER_UNIT_ID;
    
    bannerView_.rootViewController = self;
    [self.adMobView addSubview:bannerView_];
    
    
    [bannerView_ loadRequest:[GADRequest request]];
    
    
    
}



- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)orientation
                                         duration:(NSTimeInterval)duration {
    bannerView_.adSize = [self adSizeForOrientation:orientation];
}





- (GADAdSize)adSizeForOrientation:(UIInterfaceOrientation)orientation {
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        return kGADAdSizeSmartBannerLandscape;
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return kGADAdSizeSmartBannerPortrait;
    } else if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return kGADAdSizeBanner;
    }
    
    return kGADAdSizeBanner;
}





- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.textField becomeFirstResponder];
}

- (void)viewDidUnload
{
    [self setTextField:nil];
    [self setNumberPlateTextField:nil];
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
    
    PFObject *laboratory = [PFObject objectWithClassName:@"laboratory"];
    laboratory[@"Lab_Name"] = @"textField";
    laboratory[@"Lab_Image"] = @"iconName";
    [laboratory saveInBackground];
    
    // Set default ACLs
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    

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
