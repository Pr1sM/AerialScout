//
//  SDMatchSummaryView.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/6/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDMatch;

@interface SDMatchSummaryView : UIViewController {
    
    __weak IBOutlet UIImageView* checkmarkImage;
    
    __weak IBOutlet UILabel* autoStartLabel;
    __weak IBOutlet UILabel* autoMoveLabel;
    __weak IBOutlet UILabel* autoScoreLabel;
    
    __weak IBOutlet UILabel* scoreDropsLabel;
    __weak IBOutlet UILabel* scoreHighLabel;
    __weak IBOutlet UILabel* scoreLowLabel;
    __weak IBOutlet UILabel* scoreTrussPassLabel;
    __weak IBOutlet UILabel* scoreTrussCatchLabel;
    
    __weak IBOutlet UILabel* scoreAssistContributionsLabel;
    
    __weak IBOutlet UILabel* teleDefenseAbility;
    __weak IBOutlet UILabel* teleDriveQualityLabel;
    __weak IBOutlet UILabel* teleTravelSpeedLabel;
    __weak IBOutlet UILabel* telePickupSpeedLabel;
    __weak IBOutlet UILabel* teleInboundSpeedLabel;
    
    __weak IBOutlet UILabel* finalRobotLabel;
    __weak IBOutlet UILabel* finalScoreLabel;
    __weak IBOutlet UILabel* finalResultLabel;
    __weak IBOutlet UILabel* finalPenaltyLabel;
    __weak IBOutlet UILabel* finalPenaltyCardLabel;
}

@property (nonatomic, strong) SDMatch* match;

@end
