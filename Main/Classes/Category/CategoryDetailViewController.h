//
//  CategoryDetailViewController.h
//  E-Report for iOS
//
//  Created by Nur Imelia on 08/03/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//


#import "IconPickerViewController.h"
#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import <Parse/Parse.h>

@class CategoryDetailViewController;
@class Checklist;


@protocol ListDetailViewControllerDelegate <NSObject>


- (void)listDetailViewControllerDidCancel:(CategoryDetailViewController *)controller;

- (void)listDetailViewController:(CategoryDetailViewController *)controller didFinishAddingChecklist:(Checklist *)checklist;

- (void)listDetailViewController:(CategoryDetailViewController *)controller didFinishEditingChecklist:(Checklist *)checklist;

@end

@interface CategoryDetailViewController : UITableViewController <
UITextFieldDelegate, IconPickerViewControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
 
    
    // Declare one as an instance variable
    GADBannerView *bannerView_;

    
    
}

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) IBOutlet UITextField *numberPlateTextField;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneBarButton;

@property (nonatomic, weak) id <ListDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) Checklist *checklistToEdit;

@property (nonatomic, strong) IBOutlet UIWebView* adMobView;


- (IBAction)cancel;

- (IBAction)done;

//- (IBAction)signUp;


@end