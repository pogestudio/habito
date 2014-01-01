//
//  HADatePicker.h
//  HABITO
//
//  Created by CAwesome on 2013-12-14.
//  Copyright (c) 2013 CAwesome. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WantDatePicked

-(void)setPickedDate:(NSDate*)pickedDate;

@end

@interface HADatePicker : UIViewController <UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) id <WantDatePicked>objectThatWantsDatePicked;
@property (assign) NSUInteger maxAmountOfDaysInFuture;

@end
