//
//  SDScoringView.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SDResizeStepperView.h"
#import "SDGradientButton.h"

@class SDMatch;

@interface SDScoringView : UIViewController <UIAlertViewDelegate, UIActionSheetDelegate, SDResizeStepperViewDelegate> {
    SDMatch* match;
    SDMatch* origMatch;
    
    __weak IBOutlet SDGradientButton* trussPassButton;
    __weak IBOutlet SDGradientButton* trussCatchButton;
    __weak IBOutlet SDGradientButton *assistButton;
    
    __weak IBOutlet SDResizeStepperView* drops;
    __weak IBOutlet SDResizeStepperView* highGoalMisses;
    __weak IBOutlet SDResizeStepperView* trussPassMisses;
    
    __weak IBOutlet UIButton* cycleCompletedButton;
    __weak IBOutlet UIButton* previousCycleButton;
    __weak IBOutlet UIButton* nextCycleButton;
    
    __weak IBOutlet UIImageView* assistImageView;
    __weak IBOutlet UILabel* assistsLabel;
    __weak IBOutlet UILabel* cycleLabel;
}

@property (nonatomic, retain) IBOutletCollection(SDGradientButton) NSArray* goalScoreButtons;
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray*         assistButtons;
@property (nonatomic, retain) IBOutletCollection(SDGradientButton) NSArray* ballTypeButtons;

- (IBAction) backgroundTap:(id)sender;

- (IBAction) goalScoreButtonTap:(id)sender;

- (IBAction) trussPassButtonTap:(id)sender;
- (IBAction) trussCatchButtonTap:(id)sender;
- (IBAction) cycleButtonTap:(id)sender;
- (IBAction) assistButtonTap:(id)sender;
- (IBAction) teamAssistButtonTap:(id)sender;
- (IBAction) ballTypeChanged:(id)sender;

- (IBAction) previousCycleTap:(id)sender;
- (IBAction) nextCycleTap:(id)sender;

- (IBAction) leftSwipe:(id)sender;
- (IBAction) rightSwipe:(id)sender;

- (void) setMatch:(SDMatch*)editMatch originalMatch:(SDMatch*)unedittedMatch;


@end
