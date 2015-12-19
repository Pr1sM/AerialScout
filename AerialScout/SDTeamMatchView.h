//
//  SDTeamMatchView.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDTitleView.h"
#import "SDGradientButton.h"

@class SDMatch;

@interface SDTeamMatchView : UIViewController <UIAlertViewDelegate> {
    SDMatch* match;
    SDMatch* origMatch;
    
    SDTitleView* myTitle;
    bool dataComplete;
    
    __weak IBOutlet UITextField* teamNumberField;
    __weak IBOutlet UITextField* matchNumberField;
    __weak IBOutlet UIButton*    noShowButton;
    __weak IBOutlet UILabel*     teamFlag;
    __weak IBOutlet UILabel*     matchFlag;
    __weak IBOutlet UILabel*     allianceFlag;
}

@property (nonatomic, retain) IBOutletCollection(SDGradientButton) NSArray* allianceButtons;

- (IBAction)backgroundTap:(id)sender;
- (IBAction)isDataComplete:(id)sender;
- (IBAction)noShowButtonTap:(id)sender;
- (IBAction) allianceButtonTap:(id)sender;

- (IBAction) rightSwipe:(id)sender;

- (void) savePage;
- (void) setMatch:(SDMatch*)editMatch originalMatch:(SDMatch*)unedittedMatch;
- (IBAction)beginMatchEdit:(id)sender;
- (IBAction)beginTeamEdit:(id)sender;

@end
