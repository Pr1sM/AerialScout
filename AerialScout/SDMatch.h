//
//  SDMatch.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/6/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDScoringView.h"

@interface SDMatch : NSObject <NSCoding>

@property (nonatomic) int teamNumber;
@property (nonatomic) int matchNumber;
@property (nonatomic) int isCompleted;
@property (nonatomic) int hasViewed;
@property (nonatomic) int alliance;

// Auto

@property (nonatomic) int autoStart;
@property (nonatomic) int autoMoved;
@property (nonatomic) int autoHotHigh;
@property (nonatomic) int autoHotLow;
@property (nonatomic) int autoHigh;
@property (nonatomic) int autoLow;
@property (nonatomic) int autoMissed;

// Teleop - Scoring

@property (nonatomic) int scoreHigh;
@property (nonatomic) int scoreLow;
@property (nonatomic) int scoreTrussPass;
@property (nonatomic) int scoreTrussCatch;
@property (nonatomic) int scoreCycles;
@property (nonatomic) int scoreAssists;
@property (nonatomic) int scoreTeamAssist1;
@property (nonatomic) int scoreTeamAssist2;
@property (nonatomic) int scoreTeamAssist3;
@property (nonatomic) int scoreDrops;
@property (nonatomic) int scoreMissedHigh;
@property (nonatomic) int scoreMissedTruss;

// Cycle Data

@property (nonatomic) int cycle0;
@property (nonatomic) int cycle1;
@property (nonatomic) int cycle2;
@property (nonatomic) int cycle3;
@property (nonatomic) int cycle4;
@property (nonatomic) int cycle5;
@property (nonatomic) int cycle6;
@property (nonatomic) int cycle7;
@property (nonatomic) int cycle8;
@property (nonatomic) int cycle9;

// Teleop - Qualitative

@property (nonatomic) int teleDefenseAbility;
@property (nonatomic) int teleDriveRole;
@property (nonatomic) int teleDriveQuality;
@property (nonatomic) int teleTravelSpeed;
@property (nonatomic) int telePickupSpeed;
@property (nonatomic) int teleInboundSpeed;


// Final

@property (nonatomic) int finalScore;
@property (nonatomic) int penaltyScore;
@property (nonatomic) int finalResult;
@property (nonatomic) int finalPenalty;
@property (nonatomic) int finalRobot;

+ (NSString*) writeHeader;

- (id)        initWithCopy:(SDMatch*)copy;
- (void)      setToDefaults;
- (NSString*) writeMatch;

@end
