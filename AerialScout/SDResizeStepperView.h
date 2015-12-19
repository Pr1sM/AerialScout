//
//  SDResizeStepperView.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/12/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDGradientButton.h"

@class SDResizeStepperView;

@protocol SDResizeStepperViewDelegate

- (void)stepView:(SDResizeStepperView*)stepView stepValueDidChange:(int)value;

@end

@interface SDResizeStepperView : UIView

@property IBOutlet UILabel*          NameLabel;
@property IBOutlet UILabel*          ScoreLabel;
@property IBOutlet SDGradientButton* minusButton;
@property IBOutlet SDGradientButton* plusButton;


@property (nonatomic) int countValue;
@property (nonatomic) int maximumValue;
@property int minimumValue;

@property (weak) id <SDResizeStepperViewDelegate> delegate;

- (IBAction)minusButtonTap:(id)sender;
- (IBAction)plusButtonTap:(id)sender;


@end
