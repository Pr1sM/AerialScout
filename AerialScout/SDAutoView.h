//
//  SDAutoView.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SDGradientButton.h"
#import "SDResizeStepperView.h"

@class SDMatch;

@interface SDAutoView : UIViewController <UIAlertViewDelegate, SDResizeStepperViewDelegate> {
    SDMatch* match;
    SDMatch* origMatch;
        
    __weak IBOutlet SDResizeStepperView* hotHigh;
    __weak IBOutlet SDResizeStepperView* hotLow;
    __weak IBOutlet SDResizeStepperView* high;
    __weak IBOutlet SDResizeStepperView* low;
    __weak IBOutlet SDResizeStepperView* missed;
    __weak IBOutlet UILabel* startFlag;
    __weak IBOutlet UILabel* moveFlag;
    __weak IBOutlet UILabel* resizeStartLabel;
    __weak IBOutlet UILabel* resizeMoveLabel;
}

@property (nonatomic, retain) IBOutletCollection(SDGradientButton) NSArray* autoStartPositionButtons;

@property (nonatomic, retain) IBOutletCollection(SDGradientButton) NSArray* autoMoveBonusButtons;

- (IBAction) backgroundTap:(id)sender;
- (IBAction) startButtonTap:(id)sender;
- (IBAction) moveButtonTap:(id)sender;

- (IBAction) leftSwipe:(id)sender;
- (IBAction) rightSwipe:(id)sender;

- (void) savePage;
- (void) setMatch:(SDMatch*)editMatch originalMatch:(SDMatch*)unedittedMatch;

@end
