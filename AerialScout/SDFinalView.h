//
//  SDFinalView.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDGradientButton.h"

@class SDMatch;

@interface SDFinalView : UIViewController <UIAlertViewDelegate> {
    SDMatch* match;
    SDMatch* origMatch;
    
    bool keypadShown;
    
    __weak IBOutlet UITextField* finalScoreField;
    __weak IBOutlet UITextField* finalPenalyField;
    __weak IBOutlet UILabel*     resultFlag;
    __weak IBOutlet UILabel*     scoreFlag;
    __weak IBOutlet UILabel*     penaltyFlag;
}

@property (nonatomic, retain) IBOutletCollection(SDGradientButton) NSArray* resultButtons;
@property (nonatomic, retain) IBOutletCollection(SDGradientButton) NSArray* penaltyButtons;
@property (nonatomic, retain) IBOutletCollection(SDGradientButton) NSArray* robotButtons;

- (IBAction) backgroundTap:(id)sender;
- (IBAction) resultButtonTap:(id)sender;
- (IBAction) penaltyButtonTap:(id)sender;
- (IBAction) robotButtonTap:(id)sender;
- (IBAction) isDataComplete:(id)sender;
- (IBAction) beginScoreEdit:(id)sender;

- (IBAction) leftSwipe:(id)sender;

- (void) savePage;
- (void) setMatch:(SDMatch*)editMatch originalMatch:(SDMatch *)unedittedMatch;

@end
