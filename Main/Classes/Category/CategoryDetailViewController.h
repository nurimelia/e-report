//
//  CategoryDetailViewController.h
//  E-Report for iOS
//
//  Created by Nur Imelia on 08/03/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//


#import "IconPickerViewController.h"
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
//#import <"ParseUI/ParseUI.h">

@class CategoryDetailViewController;
@class Checklist;


@protocol ListDetailViewControllerDelegate <NSObject>


- (void)listDetailViewControllerDidCancel:(CategoryDetailViewController *)controller;

- (void)listDetailViewController:(CategoryDetailViewController *)controller didFinishAddingChecklist:(Checklist *)checklist;

- (void)listDetailViewController:(CategoryDetailViewController *)controller didFinishEditingChecklist:(Checklist *)checklist;

@end

@interface CategoryDetailViewController : UITableViewController <
UITextFieldDelegate, IconPickerViewControllerDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
 
    
}

@property (strong, nonatomic) IBOutlet UIImageView *iconImageView;
@property (nonatomic, strong) IBOutlet UITextField *textField;
//@property (nonatomic, strong) IBOutlet UITextField *numberPlateTextField;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneBarButton;

@property (nonatomic, weak) id <ListDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) Checklist *checklistToEdit;

- (IBAction)cancel;

- (IBAction)done;

@end