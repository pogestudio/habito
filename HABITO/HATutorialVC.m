//
//  HATutorialVC.m
//  HABITO
//
//  Created by CAwesome on 2013-12-31.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import "HATutorialVC.h"

#define tutorialCompletionKey @"TUTORIALISCOMPLETE"

@implementation HATutorialVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tapCount = 0;
    
    //labels should be positioned left, right, left, right .... until last one which is in the middle.
    self.labels = [NSArray arrayWithObjects:self.label1,self.label2,self.label3,self.label4,self.label5, nil];
    [self hideLabelsInitially];
}

-(void)hideLabelsInitially
{
    CGFloat screenWidth = self.view.frame.size.width;
    for (int i = 0; i + 1 < self.labels.count; i++) {
        UILabel *theLabel = [self.labels objectAtIndex:i];
        if (i%2 == 0) {
            //hide to the left
            theLabel.frame = CGRectOffset(theLabel.frame, -screenWidth, 0);
        } else
        {
            //hide to the right
            theLabel.frame = CGRectOffset(theLabel.frame, screenWidth, 0);
            
        }
    }
    
    //hide the last!
    self.label5.frame = CGRectOffset(self.label5.frame, 0, self.view.frame.size.height/2);
}

-(IBAction)screenTapped:(id)sender
{
    if (self.tapCount >= self.labels.count) {
        [self saveCompletionValueInUserDefaults];
        [self dismissViewControllerAnimated:NO completion:nil];
        return;
    } else {
        [self animateInLabelWithIndex:self.tapCount];
    }
    self.tapCount++;
    
}

-(void)animateInLabelWithIndex:(NSUInteger)index
{
    UILabel *theLabel = [self.labels objectAtIndex:index];
    CGFloat screenWidth = self.view.frame.size.width;
    CGFloat extraBumpLength = 20;
    CGFloat offsetDx = 0;
    CGFloat offsetDy = 0;
    CGFloat extraBumpAnimationX = 0;
    CGFloat extraBumpAnimationY = 0;
    if (index == 4) {
        //come from below!
        theLabel = self.label5;
        offsetDy = -(self.view.frame.size.height/2 + extraBumpLength/2);
        extraBumpAnimationY = extraBumpLength/2;
        
    } else if (index%2 !=0) {
        //should animate in from the right, so the offset should be negative
        offsetDx = -( screenWidth + extraBumpLength);
        extraBumpAnimationX = extraBumpLength; //bump back in positive direction
    } else {
        offsetDx = screenWidth + extraBumpLength;
        extraBumpAnimationX = -extraBumpLength;
    }
    
    [UIView animateWithDuration:0.5 animations:^(void){
        theLabel.frame = CGRectOffset(theLabel.frame, offsetDx, offsetDy);
    } completion:^(BOOL finished){
        [UIView animateWithDuration:0.2 animations:^(void){
            theLabel.frame = CGRectOffset(theLabel.frame, extraBumpAnimationX, extraBumpAnimationY);
        }];
        
    }];
}

+(void)revokeTutorialCompletion
{
    NSNumber *valueToSave = [NSNumber numberWithBool:NO];
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:tutorialCompletionKey];
    
    //tap info! for first time you open challenge view
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"firstTimeWatchViewChallenge"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)shouldShowTutorialView
{
    BOOL hasDoneBefore = NO;
    NSNumber *completed = (NSNumber*)[[NSUserDefaults standardUserDefaults] stringForKey:tutorialCompletionKey];
    if (completed && [completed boolValue]) {
        hasDoneBefore = YES;
    }
    BOOL shouldSHow = !hasDoneBefore;
    return shouldSHow;
}

-(void)saveCompletionValueInUserDefaults
{
    NSNumber *valueToSave = [NSNumber numberWithBool:YES];
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:tutorialCompletionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString*)storyBoardId
{
    return @"TutorialVC";
}

@end
