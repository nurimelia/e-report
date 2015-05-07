//
//  InitialViewController.h
//  Video Trimming Tool for iOS
//
//  Created by Nur Imelia on 08/03/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryViewController.h"



@interface InitialViewController : UIViewController {
    
    CategoryViewController *controller;
}

-(IBAction)done:(UIStoryboardSegue *)seque;

@end
