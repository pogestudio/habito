//
//  HAParseLoginSignupHandler.m
//  HABITO
//
//  Created by CAwesome on 2013-12-14.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HAParseLoginSignupHandler.h"
#import "PFInstallation+userHandler.h"

static HAParseLoginSignupHandler* _sharedHandler;

@implementation HAParseLoginSignupHandler

+(HAParseLoginSignupHandler*)sharedHandlerpresentFromView:(UIViewController*)callingView
{
    if (!_sharedHandler) {
        _sharedHandler = [[HAParseLoginSignupHandler alloc] init];
    }
    _sharedHandler.callingView = callingView;
    return _sharedHandler;
}

-(void)makeSureUserIsLoggedIn
{
    if(![PFUser currentUser])
    {
        [[PFInstallation currentInstallation] removeLoggedInUserData];
        [self logInUser];
    }
}

-(void) logInUser
{
    
    // Create the log in view controller
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    logInViewController.fields  = PFLogInFieldsUsernameAndPassword |
    PFLogInFieldsPasswordForgotten |
    PFLogInFieldsFacebook |
    PFLogInFieldsLogInButton |
    PFLogInFieldsSignUpButton;
    
    
    // Create the sign up view controller
    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];
    
    // Present the log in view controller
    [self.callingView presentViewController:logInViewController animated:YES completion:NULL];
    
    self.loginView = logInViewController;
    self.signupView = signUpViewController;
    
}


#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [[PFInstallation currentInstallation] saveLoggedinUserData];
    NSLog(@"we did login user! woohooo");
    [logInController dismissViewControllerAnimated:YES completion:nil];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || !field.length) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    NSLog(@"Did sign up user!!");
    [[PFInstallation currentInstallation] saveLoggedinUserData];

    [signUpController dismissViewControllerAnimated:YES completion:^(void){
        [self.loginView dismissViewControllerAnimated:NO completion:nil];
    }];
    //   [self.loginView dismissViewControllerAnimated:noErr completion:nil];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up.... Eerrors::: %@", [error localizedDescription]);
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}


#pragma mark - ()

- (IBAction)logOutButtonTapAction:(id)sender {
    [PFUser logOut];
    [[PFInstallation currentInstallation] removeLoggedInUserData];
    NSLog(@"user logged out. should pop login view again..?");
}

@end
