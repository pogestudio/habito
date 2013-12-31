//
//  HATutorialVC.h
//  HABITO
//
//  Created by CAwesome on 2013-12-31.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HATutorialVC : UIViewController


@property (retain) NSArray *labels;

@property (retain) IBOutlet UILabel *label1;
@property (retain) IBOutlet UILabel *label2;
@property (retain) IBOutlet UILabel *label3;
@property (retain) IBOutlet UILabel *label4;
@property (retain) IBOutlet UILabel *label5;

@property (assign) NSUInteger tapCount;

@property (assign) BOOL tappingIsEnabled;

+(BOOL)shouldShowTutorialView;
+(NSString*)storyBoardId;
+(void)revokeTutorialCompletion;

@end
