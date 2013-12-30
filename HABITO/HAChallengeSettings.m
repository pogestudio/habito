//
//  HAChallengeSettings.m
//  HABITO
//
//  Created by CAwesome on 2013-12-29.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HAChallengeSettings.h"
#import "HAChallenge.h"
@implementation HAChallengeSettings

NSString *correctionText = @"I DO NOT WANT TO CHANGE";

-(IBAction)startCancelAction
{
    //pop controller, asking if they want to cancel
    //if they enter the correct shit, call cancelChallenge

	// open an alert with two custom buttons
    NSString *message = [NSString stringWithFormat:@"Do you really want to quit? If so, type '%@' into the box",correctionText];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Really?"
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"I changed my mind!"
                                          otherButtonTitles:@"Yes.. I want to quit", nil];
	alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 1 || alertView.alertViewStyle == UIAlertViewStyleDefault) {
        return;
    }
    
    NSString *text = [alertView textFieldAtIndex:0].text;

    if( [text caseInsensitiveCompare:correctionText] == NSOrderedSame ) // its OK button, and the correct text is entered :'(
    {
        [self.theChallenge cancelChallengeAndNotifyOpponent];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else
    {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Incorrecto"
                                                        message:@"Wrong text"
                                                       delegate:self
                                              cancelButtonTitle:@"Ok, maybe I changed my mind"
                                              otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
    }
    
    
}

@end
