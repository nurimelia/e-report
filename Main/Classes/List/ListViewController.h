//
//  ListViewController.h
//  E-Report for iOS
//
//  Created by Nur Imelia on 08/03/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailViewController.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>


@class Checklist;
NSArray *colorsArray;
//@interface ListViewController : UITableViewController
@interface ListViewController : PFQueryTableViewController <ItemDetailViewControllerDelegate>

{

}


//@property (nonatomic, strong) Checklist *checklistitem;
@property (nonatomic, strong) Checklist *checklist;
@property (strong, nonatomic) IBOutlet UIButton *button;


-(IBAction) addItem:(id)sender;

@end
