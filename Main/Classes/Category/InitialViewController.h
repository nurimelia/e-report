//
//  InitialViewController.h
//  Video Trimming Tool for iOS
//
//  Created by Nur Imelia on 08/03/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CategoryViewController.h"



@interface InitialViewController : UIViewController <UIAlertViewDelegate>
{
    
    CategoryViewController *controller;
}
@property (weak, nonatomic) IBOutlet UITextField *userIDOutlet;
@property (weak, nonatomic) IBOutlet UITextField *passwordOutlet;
@property (weak, nonatomic) IBOutlet UIButton *loginButtonOutlet;

@end
