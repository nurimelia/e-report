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
#import "GADBannerView.h"




@interface CategoryViewController : UITableViewController <ListDetailViewControllerDelegate, UINavigationControllerDelegate>{
    
    
    
    // Declare one as an instance variable
    GADBannerView *bannerView_;

    
    
}

@property (nonatomic, strong) DataModel *dataModel;

@property (nonatomic, strong) IBOutlet UIWebView* adMobView;



@end
