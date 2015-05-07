//
//  ListViewController.h
//  E-Report for iOS
//
//  Created by Nur Imelia on 08/03/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailViewController.h"
#import "GADBannerView.h"


@class Checklist;

@interface ListViewController : UITableViewController   <ItemDetailViewControllerDelegate>
{
    // Declare one as an instance variable
    GADBannerView *bannerView_;

}


@property (nonatomic, strong) Checklist *checklist;
@property (strong, nonatomic) IBOutlet UIButton *button;

@property (nonatomic, strong) IBOutlet UIWebView* adMobView;



-(IBAction) addItem:(id)sender;


@end
