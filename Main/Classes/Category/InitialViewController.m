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

- (void)viewDidLoad
{
    [super viewDidLoad];

    //UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"Left" style:UIBarButtonItemStylePlain target:self action:@selector(openVideoController)];
    //self.navigationItem.leftBarButtonItem = left;
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:gestureRecognizer];
    
    
  /*  _emailField.returnKeyType = UIReturnKeyDone;
    [_emailField setDelegate:self];
    _usernameField.returnKeyType = UIReturnKeyDone;
    [_usernameField setDelegate:self];
    _passwordField.returnKeyType = UIReturnKeyDone;
    [_passwordField setDelegate:self];*/
}

-(void)dismissKeyboard
{
    [self.userIDOutlet resignFirstResponder];
    [self.passwordOutlet resignFirstResponder];
}

-(void)displayKeyboard
{
    [self.userIDOutlet becomeFirstResponder];
}

-(void)openVideoController
{
    
    [self performSegueWithIdentifier:@"open" sender:nil]; //call trim segue

}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Action listener method when Log In button get pressed
- (IBAction)loginPressed:(id)sender
{
    NSString *username = self.userIDOutlet.text;
    NSString *password = self.passwordOutlet.text;
    
    if(![username isEqualToString:@""] && ![password isEqualToString:@""])
    {
        [self.loginButtonOutlet setTitle:@"Loading..." forState:UIControlStateNormal];
        [self.loginButtonOutlet setEnabled:NO];
        
        [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
            
            NSString *alertTitle = nil;
            NSString *alertMessage = nil;
            NSString *cancelButton = nil;
            NSString *otherButtonTitles = nil;
            
            if(user)
            {
                alertTitle = [NSString stringWithFormat:@"Welcome %@",[user.username capitalizedString]];
                cancelButton = @"OK";
               // _userIDOutlet.text = nil;
               // _passwordOutlet.text = nil;
                
                [self performSegueWithIdentifier:@"openSegue" sender:self];
            }
            else
            {
                alertTitle = @"Login Failed";
                alertMessage = @"Invalid Username and Password";
                cancelButton = @"Dismiss";
                otherButtonTitles = @"Sign Up";
            }
            
            [self.loginButtonOutlet setTitle:@"Login" forState:UIControlStateNormal];
            [self.loginButtonOutlet setEnabled:YES];
            
            UIAlertView *alertLoginFailed = [[UIAlertView alloc] initWithTitle:alertTitle
                                                                       message:alertMessage
                                                                      delegate:self
                                                             cancelButtonTitle:cancelButton
                                                             otherButtonTitles:otherButtonTitles, nil];
            
            [alertLoginFailed show];
        }];

    }
    else
    {
        UIAlertView *alertLoginFailed = [[UIAlertView alloc] initWithTitle:@"Please enter Username & Password"
                                                                   message:nil
                                                                  delegate:self
                                                         cancelButtonTitle:@"Okay"
                                                         otherButtonTitles:nil];
        
        [alertLoginFailed show];
    }
}

//Action listener method when Sign Up button get pressed

- (IBAction)registerUser:(id)sender
{
    PFUser *user = [PFUser objectWithClassName:@"e-report"];

    user.username = _usernameField.text;
    user.password = _passwordField.text;
    user.email = _emailField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
    if ([_usernameField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""] || [_reEnterPasswordField.text isEqualToString:@""] || [_emailField.text isEqualToString:@""]) {
        NSLog(@"Error, all fields must be filled in");
        
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"You must complete all fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [error show];
    }
    else {
        [self checkPasswordsMatch];
    }
    }];
}

- (void) checkPasswordsMatch {
    if ([_passwordField.text isEqualToString:_reEnterPasswordField.text]){
        NSLog(@"Passwords match");
        [self registerNewUser];
        
    }else{
    
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"Your entered passwords do not match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [error show];
    }
}

-(void)registerNewUser {
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    
    [defaults setObject:_usernameField.text forKey:@"username"];
    [defaults setObject:_passwordField.text forKey:@"password"];
    //[defaults setBool:YES forKey:@"registered"];
    
    [defaults synchronize];
    
    UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have registered a new user" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [success show];
    
    [self performSegueWithIdentifier:@"login" sender:self];
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
       [self performSegueWithIdentifier:@"signupSegue" sender:self];
}

- (IBAction)done:(UIStoryboardSegue *)seque { [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signUp;
{
    UIAlertView *helloWorldAlert = [[UIAlertView alloc]
                                    initWithTitle:@"My First App" message:@"Hello, World!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    // Display the Hello World Message
    [helloWorldAlert show];
}

@end
