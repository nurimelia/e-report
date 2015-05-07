//
//  InitialViewController.m
//  Video Trimming Tool for iOS
//
//  Created by Nur Imelia on 08/03/15.
//  Copyright (c) 2015 Nur Imelia. All rights reserved.
//

#import "InitialViewController.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/*- (void)viewDidLoad
{
    [super viewDidLoad];


    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"Left" style:UIBarButtonItemStylePlain target:self action:@selector(openVideoController)];
    
    self.navigationItem.leftBarButtonItem = left;

}*/


-(void)openVideoController
{
    
    [self performSegueWithIdentifier:@"open" sender:nil]; //call trim segue

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)done:(UIStoryboardSegue *)seque { [self.navigationController popViewControllerAnimated:YES];
}


@end
