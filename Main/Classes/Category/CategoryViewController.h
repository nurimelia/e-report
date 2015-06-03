//
//  CategoryViewController.h
//  E-Report for iOS
//
//  Created by Nur Imelia on 08/03/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CategoryDetailViewController.h"
#import "DataModel.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>


    NSArray *colorsArray;
    
//@interface CategoryViewController : UITableViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>{
@interface CategoryViewController : PFQueryTableViewController{
    
}
    

@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (nonatomic, strong) DataModel *dataModel;


@end
