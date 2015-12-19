//
//  SDResizeStepperView.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/12/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDResizeStepperView.h"
#import "SDViewServer.h"

@implementation SDResizeStepperView

@synthesize NameLabel;
@synthesize ScoreLabel;
@synthesize minusButton, plusButton;
@synthesize countValue, maximumValue, minimumValue;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        minimumValue = 0;
        maximumValue = 0;
        countValue = 0;
    }
    return self;
}

- (void) setCountValue:(int)value {
    if (value > maximumValue) value = maximumValue;
    if (value < minimumValue) value = minimumValue;
    
    countValue = value;
    
    [ScoreLabel setText:[NSString stringWithFormat:@"%d", countValue]];

    [minusButton setEnabled:(countValue > minimumValue)];
    [plusButton setEnabled:(countValue < maximumValue)];
    
    if (countValue > minimumValue) {
        [ScoreLabel setTextColor:[UIColor colorWithRed:1.0 green:0.35 blue:0.0 alpha:1.0]];
        [ScoreLabel setBackgroundColor:[UIColor blackColor]];
    } else {
        [ScoreLabel setTextColor:[UIColor whiteColor]];
        [ScoreLabel setBackgroundColor:[UIColor lightGrayColor]];
    }
}

- (void) setMaximumValue:(int)value {
    maximumValue = value;
    if (countValue > maximumValue)  {
        countValue = maximumValue;
    
    } else {
        [minusButton setEnabled:(countValue > minimumValue)];
        [plusButton setEnabled:(countValue < maximumValue)];

        if (countValue > minimumValue) {
            [ScoreLabel setBackgroundColor:[UIColor blackColor]];
        } else {
            [ScoreLabel setBackgroundColor:[UIColor lightGrayColor]];
        }
    }
}

- (IBAction) minusButtonTap:(id)sender {
    [self setCountValue: --countValue];
    [self.delegate stepView:self stepValueDidChange:-1];
}

- (IBAction) plusButtonTap:(id)sender {
    [self setCountValue: ++countValue];
    [self.delegate stepView:self stepValueDidChange:+1];
}

@end
