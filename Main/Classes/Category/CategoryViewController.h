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


@interface CategoryViewController : UITableViewController <ListDetailViewControllerDelegate, UINavigationControllerDelegate>{
    
    
}

@property (nonatomic, strong) DataModel *dataModel;


@end
