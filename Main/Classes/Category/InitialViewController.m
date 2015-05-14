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
                _userIDOutlet.text = nil;
                _passwordOutlet.text = nil;
                
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
    if ([_usernameField.text isEqualToString:@""] || [_passwordField.text isEqualToString:@""] || [_reEnterPasswordField.text isEqualToString:@""] || [_emailField.text isEqualToString:@""]) {
        NSLog(@"Error, all fields must be filled in");
        
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"You must complete all fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [error show];
    }
    else {
        [self checkPasswordsMatch];
    }
}

- (void) checkPasswordsMatch {
    if ([_passwordField.text isEqualToString:_reEnterPasswordField.text]){
        NSLog(@"Passwords match");
       // [self registerNewUser];
        
        UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have registered a new user" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [success show];
        
        [self performSegueWithIdentifier:@"login" sender:self];
        
    }else{
        _passwordField.text = _reEnterPasswordField.text = @"";
        
        UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Oooops" message:@"Your entered passwords do not match" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        
        [error show];
    }
}

-(void)registerNewUser {
    PFUser *user = [PFUser user];
    
    user.username = _usernameField.text;
    user.password = _passwordField.text;
    user.email = _emailField.text;
    
    [_registerBtn setTitle:@"Registering..." forState:UIControlStateNormal];
    [_registerBtn setEnabled:NO];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if(succeeded)
        {
            UIAlertView *success = [[UIAlertView alloc] initWithTitle:@"Success" message:@"You have registered a new user" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [success show];
        }
        else
        {
            UIAlertView *failed = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"%@", error.description] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            
            [failed show];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    
}


-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
       [self performSegueWithIdentifier:@"signupSegue" sender:self];
}

- (IBAction)done:(UIStoryboardSegue *)seque { [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)forgotPassword:(id)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Email Address"
                                                        message:@"Enter the email for your account:"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Ok", nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView show];
}


- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        
        UITextField *emailAddress = [alertView textFieldAtIndex:0];
        
        [PFUser requestPasswordResetForEmailInBackground: emailAddress.text];
        
        UIAlertView *alertViewSuccess = [[UIAlertView alloc] initWithTitle:@"Success! A reset email was sent to you" message:@""
                                                                  delegate:self
                                                         cancelButtonTitle:@"Ok"
                                                         otherButtonTitles:nil];
        [alertViewSuccess show];
    }
}
@end
