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


@interface CategoryViewController : UITableViewController <ListDetailViewControllerDelegate, UINavigationControllerDelegate>{

//@interface CategoryViewController : UIViewController <UITableViewDelegate> {
    NSArray *colorsArray;

    
}
@property (weak, nonatomic) IBOutlet UITableView *listTable;
@property (nonatomic, strong) DataModel *dataModel;


@end
