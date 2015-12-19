//
//  SDTeleopView.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDGradientButton.h"

@class SDMatch;

@interface SDTeleopView : UIViewController <UIAlertViewDelegate> {
    SDMatch* match;
    SDMatch* origMatch;
}

@property (nonatomic, retain) IBOutletCollection(SDGradientButton) NSArray* driveQualityButtons;
@property (nonatomic, retain) IBOutletCollection(SDGradientButton) NSArray* defenseAbilityButtons;
@property (nonatomic, retain) IBOutletCollection(SDGradientButton) NSArray* inboundSpeedButtons;
@property (nonatomic, retain) IBOutletCollection(SDGradientButton) NSArray* pickupSpeedButtons;
@property (nonatomic, retain) IBOutletCollection(SDGradientButton) NSArray* travelSpeedButtons;

- (IBAction) backgroundTap:(id)sender;
- (IBAction) driveQualityButtonTap:(id)sender;
- (IBAction) defenseAbilityButtonTap:(id)sender;
- (IBAction) inboundSpeedButtonTap:(id)sender;
- (IBAction) pickupSpeedButtonTap:(id)sender;
- (IBAction) travelSpeedButtonTap:(id)sender;

- (IBAction) leftSwipe:(id)sender;
- (IBAction) rightSwipe:(id)sender;

- (void) setMatch:(SDMatch*)editMatch originalMatch:(SDMatch*)unedittedMatch;

@end
