//
//  SDMatch.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/6/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDMatch.h"

@implementation SDMatch

@synthesize teamNumber, matchNumber, hasViewed, isCompleted, alliance, autoHigh, autoHotHigh, autoHotLow, autoLow, autoMissed, autoMoved, autoStart, scoreCycles, scoreDrops, scoreHigh, scoreLow, scoreMissedHigh, scoreTrussCatch, scoreTrussPass, scoreAssists, scoreTeamAssist1, scoreTeamAssist2, scoreTeamAssist3, scoreMissedTruss, teleDefenseAbility, teleDriveQuality, teleDriveRole, teleInboundSpeed, telePickupSpeed, teleTravelSpeed, finalPenalty, finalResult, finalRobot, finalScore, penaltyScore;

@synthesize cycle0, cycle1, cycle2, cycle3, cycle4, cycle5, cycle6, cycle7, cycle8, cycle9;

//@synthesize cycleAssists, cycleBall, cycleGoal, cycleTeamContribution, cycleTrussCatch, cycleTrussPass, cycleDataUpdated;

- (id) init {
    if (self = [super init]) {
        [self setToDefaults];
    }
    
    return self;
}

- (id) initWithCopy:(SDMatch *)copy {
    if (self = [super init]) {
        
        self.teamNumber            = copy.teamNumber;
        self.matchNumber           = copy.matchNumber;
        self.isCompleted           = copy.isCompleted;
        self.hasViewed             = copy.hasViewed;
        self.alliance              = copy.alliance;
        
        // Auto
        
        self.autoStart             = copy.autoStart;
        self.autoMoved             = copy.autoMoved;
        self.autoHotHigh           = copy.autoHotHigh;
        self.autoHotLow            = copy.autoHotLow;
        self.autoHigh              = copy.autoHigh;
        self.autoLow               = copy.autoLow;
        self.autoMissed            = copy.autoMissed;
        
        // Teleop - Scoring
        
        self.scoreCycles           = copy.scoreCycles;
        self.scoreHigh             = copy.scoreHigh;
        self.scoreLow              = copy.scoreLow;
        self.scoreTrussCatch       = copy.scoreTrussCatch;
        self.scoreTrussPass        = copy.scoreTrussPass;
        self.scoreAssists          = copy.scoreAssists;
        self.scoreTeamAssist1      = copy.scoreTeamAssist1;
        self.scoreTeamAssist2      = copy.scoreTeamAssist2;
        self.scoreTeamAssist3      = copy.scoreTeamAssist3;
        self.scoreDrops            = copy.scoreDrops;
        self.scoreMissedHigh       = copy.scoreMissedHigh;
        self.scoreMissedTruss      = copy.scoreMissedTruss;
        
        // Teleop - Cycle Data
        
        self.cycle0                = copy.cycle0;
        self.cycle1                = copy.cycle1;
        self.cycle2                = copy.cycle2;
        self.cycle3                = copy.cycle3;
        self.cycle4                = copy.cycle4;
        self.cycle5                = copy.cycle5;
        self.cycle6                = copy.cycle6;
        self.cycle7                = copy.cycle7;
        self.cycle8                = copy.cycle8;
        self.cycle9                = copy.cycle9;
        
        // Teleop - Qualitative
        
        self.teleDefenseAbility    = copy.teleDefenseAbility;
        self.teleDriveQuality      = copy.teleDriveQuality;
        self.teleDriveRole         = copy.teleDriveRole;
        self.teleInboundSpeed      = copy.teleInboundSpeed;
        self.telePickupSpeed       = copy.telePickupSpeed;
        self.teleTravelSpeed       = copy.teleTravelSpeed;
        
        // Final
        
        self.finalScore            = copy.finalScore;
        self.penaltyScore          = copy.penaltyScore;
        self.finalResult           = copy.finalResult;
        self.finalPenalty          = copy.finalPenalty;
        self.finalRobot            = copy.finalRobot;
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super init]) {
        
        self.teamNumber         = [aDecoder decodeIntForKey:@"teamNumber"];
        self.matchNumber        = [aDecoder decodeIntForKey:@"matchNumber"];
        self.isCompleted        = [aDecoder decodeIntForKey:@"isCompleted"];
        self.hasViewed          = [aDecoder decodeIntForKey:@"hasViewed"];
        self.alliance           = [aDecoder decodeIntForKey:@"alliance"];
    
    // Auto
    
        self.autoStart          = [aDecoder decodeIntForKey:@"autoStart"];
        self.autoMoved          = [aDecoder decodeIntForKey:@"autoMoved"];
        self.autoHotHigh        = [aDecoder decodeIntForKey:@"autoHotHigh"];
        self.autoHotLow         = [aDecoder decodeIntForKey:@"autoHotLow"];
        self.autoHigh           = [aDecoder decodeIntForKey:@"autoHigh"];
        self.autoLow            = [aDecoder decodeIntForKey:@"autoLow"];
        self.autoMissed         = [aDecoder decodeIntForKey:@"autoMissed"];
    
    // Teleop - Scoring
        
        self.scoreCycles        = [aDecoder decodeIntForKey:@"scoreCycles"];
        self.scoreHigh          = [aDecoder decodeIntForKey:@"scoreHigh"];
        self.scoreLow           = [aDecoder decodeIntForKey:@"scoreLow"];
        self.scoreTrussCatch    = [aDecoder decodeIntForKey:@"scoreTrussCatch"];
        self.scoreTrussPass     = [aDecoder decodeIntForKey:@"scoreTrussPass"];
        self.scoreAssists       = [aDecoder decodeIntForKey:@"scoreAssists"];
        self.scoreTeamAssist1   = [aDecoder decodeIntForKey:@"scoreTeamAssist1"];
        self.scoreTeamAssist2   = [aDecoder decodeIntForKey:@"scoreTeamAssist2"];
        self.scoreTeamAssist3   = [aDecoder decodeIntForKey:@"scoreTeamAssist3"];
        self.scoreDrops         = [aDecoder decodeIntForKey:@"scoreDrops"];
        self.scoreMissedHigh    = [aDecoder decodeIntForKey:@"scoreMissedHigh"];
        self.scoreMissedTruss   = [aDecoder decodeIntForKey:@"scoreMissedTruss"];
        
    // Teleop - Cycle Data
        
        self.cycle0             = [aDecoder decodeIntForKey:@"teleCycle0"];
        self.cycle1             = [aDecoder decodeIntForKey:@"teleCycle1"];
        self.cycle2             = [aDecoder decodeIntForKey:@"teleCycle2"];
        self.cycle3             = [aDecoder decodeIntForKey:@"teleCycle3"];
        self.cycle4             = [aDecoder decodeIntForKey:@"teleCycle4"];
        self.cycle5             = [aDecoder decodeIntForKey:@"teleCycle5"];
        self.cycle6             = [aDecoder decodeIntForKey:@"teleCycle6"];
        self.cycle7             = [aDecoder decodeIntForKey:@"teleCycle7"];
        self.cycle8             = [aDecoder decodeIntForKey:@"teleCycle8"];
        self.cycle9             = [aDecoder decodeIntForKey:@"teleCycle9"];
        
    // Teleop - Qualitative
    
        self.teleDefenseAbility = [aDecoder decodeIntForKey:@"teleDefenseAbility"];
        self.teleDriveQuality   = [aDecoder decodeIntForKey:@"teleDriveQuality"];
        self.teleDriveRole      = [aDecoder decodeIntForKey:@"teleDriveRole"];
        self.teleInboundSpeed   = [aDecoder decodeIntForKey:@"teleInboundSpeed"];
        self.telePickupSpeed    = [aDecoder decodeIntForKey:@"telePickupSpeed"];
        self.teleTravelSpeed    = [aDecoder decodeIntForKey:@"teleTravelSpeed"];
    
    // Final
    
        self.finalScore         = [aDecoder decodeIntForKey:@"finalScore"];
        self.penaltyScore       = [aDecoder decodeIntForKey:@"penaltyScore"];
        self.finalResult        = [aDecoder decodeIntForKey:@"finalResult"];
        self.finalPenalty       = [aDecoder decodeIntForKey:@"finalPenalty"];
        self.finalRobot         = [aDecoder decodeIntForKey:@"finalRobot"];
    
    }
    
    return self;
    
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:teamNumber       forKey:@"teamNumber"];
    [aCoder encodeInt:matchNumber      forKey:@"matchNumber"];
    [aCoder encodeInt:isCompleted      forKey:@"isCompleted"];
    [aCoder encodeInt:hasViewed        forKey:@"hasViewed"];
    
    [aCoder encodeInt:alliance         forKey:@"alliance"];
    
    [aCoder encodeInt:autoStart        forKey:@"autoStart"];
    [aCoder encodeInt:autoMoved        forKey:@"autoMoved"];
    [aCoder encodeInt:autoHotHigh      forKey:@"autoHotHigh"];
    [aCoder encodeInt:autoHotLow       forKey:@"autoHotLow"];
    [aCoder encodeInt:autoHigh         forKey:@"autoHigh"];
    [aCoder encodeInt:autoLow          forKey:@"autoLow"];
    [aCoder encodeInt:autoMissed       forKey:@"autoMissed"];
    
    [aCoder encodeInt:scoreCycles           forKey:@"scoreCycles"];
    [aCoder encodeInt:scoreHigh             forKey:@"scoreHigh"];
    [aCoder encodeInt:scoreLow              forKey:@"scoreLow"];
    [aCoder encodeInt:scoreTrussCatch       forKey:@"scoreTrussCatch"];
    [aCoder encodeInt:scoreTrussPass        forKey:@"scoreTrussPass"];
    [aCoder encodeInt:scoreAssists          forKey:@"scoreAssists"];
    [aCoder encodeInt:scoreTeamAssist1      forKey:@"scoreTeamAssist1"];
    [aCoder encodeInt:scoreTeamAssist2      forKey:@"scoreTeamAssist2"];
    [aCoder encodeInt:scoreTeamAssist3      forKey:@"scoreTeamAssist3"];
    [aCoder encodeInt:scoreDrops            forKey:@"scoreDrops"];
    [aCoder encodeInt:scoreMissedHigh       forKey:@"scoreMissedHigh"];
    [aCoder encodeInt:scoreMissedTruss      forKey:@"scoreMissedTruss"];
    
    [aCoder encodeInt:cycle0                forKey:@"teleCycle0"];
    [aCoder encodeInt:cycle1                forKey:@"teleCycle1"];
    [aCoder encodeInt:cycle2                forKey:@"teleCycle2"];
    [aCoder encodeInt:cycle3                forKey:@"teleCycle3"];
    [aCoder encodeInt:cycle4                forKey:@"teleCycle4"];
    [aCoder encodeInt:cycle5                forKey:@"teleCycle5"];
    [aCoder encodeInt:cycle6                forKey:@"teleCycle6"];
    [aCoder encodeInt:cycle7                forKey:@"teleCycle7"];
    [aCoder encodeInt:cycle8                forKey:@"teleCycle8"];
    [aCoder encodeInt:cycle9                forKey:@"teleCycle9"];
    
    [aCoder encodeInt:teleDefenseAbility    forKey:@"teleDefenseAbility"];
    [aCoder encodeInt:teleDriveQuality      forKey:@"teleDriveQuality"];
    [aCoder encodeInt:teleDriveRole         forKey:@"teleDriveRole"];
    [aCoder encodeInt:teleInboundSpeed      forKey:@"teleInboundSpeed"];
    [aCoder encodeInt:telePickupSpeed       forKey:@"telePickupSpeed"];
    [aCoder encodeInt:teleTravelSpeed       forKey:@"teleTravelSpeed"];
    
    [aCoder encodeInt:finalScore            forKey:@"finalScore"];
    [aCoder encodeInt:penaltyScore          forKey:@"penaltyScore"];
    [aCoder encodeInt:finalResult           forKey:@"finalResult"];
    [aCoder encodeInt:finalPenalty          forKey:@"finalPenalty"];
    [aCoder encodeInt:finalRobot            forKey:@"finalRobot"];
}

- (void) setToDefaults {
    
    self.teamNumber       = 0;
    self.matchNumber      = 0;
    self.isCompleted      = 0;
    self.hasViewed        = 0;
    
    self.alliance         = -1;
    
    // Auto
    
    self.autoStart        = -1;
    self.autoMoved        = -1;
    self.autoHotHigh      = -1;
    self.autoHotLow       = -1;
    self.autoHigh         = -1;
    self.autoLow          = -1;
    self.autoMissed       = -1;
    
    // Teleop - Scoring
    
    self.scoreCycles           = 0;
    self.scoreHigh             = 0;
    self.scoreLow              = 0;
    self.scoreTrussCatch       = 0;
    self.scoreTrussPass        = 0;
    self.scoreAssists          = 0;
    self.scoreTeamAssist1      = 0;
    self.scoreTeamAssist2      = 0;
    self.scoreTeamAssist3      = 0;
    self.scoreDrops            = 0;
    self.scoreMissedHigh       = 0;
    self.scoreMissedTruss      = 0;
    
    // Teleop - Cycles
    
    self.cycle0 = 0;
    self.cycle1 = 0;
    self.cycle2 = 0;
    self.cycle3 = 0;
    self.cycle4 = 0;
    self.cycle5 = 0;
    self.cycle6 = 0;
    self.cycle7 = 0;
    self.cycle8 = 0;
    self.cycle9 = 0;
    
    // Teleop - Qualitative
    
    self.teleDefenseAbility = 0;
    self.teleDriveQuality = 0;
    self.teleDriveRole = 0;
    self.teleInboundSpeed = 0;
    self.telePickupSpeed = 0;
    self.teleTravelSpeed = 0;
    
    // Final
    
    self.finalScore       = -1;
    self.penaltyScore     = -1;
    self.finalResult      = -1;
    self.finalPenalty     = 0;
    self.finalRobot       = 0;
    
}

+ (NSString*) writeHeader {
    return [NSString stringWithFormat:@"Team, Match, isCompleted, Start Position, Auto Moved, Auto Hot High, Auto Hot Low, Auto High, Auto Low, Auto Missed, Cycles, 1 Assist, 2 Assist, 3 Assist, Truss Pass, Truss Catch, High Goal, Low Goal, Ball Drops, High Missed, Truss Missed, Drive Quality, Travel Speed, Defense Ability, Pickup Speed, Inbound Speed, Final Score, Penalty Score, Result, Penalty, Robot, Cycle1, Cycle2, Cycle3, Cycle4, Cycle5, Cycle6, Cycle7, Cycle8, Cycle9, Cycle10  \r\n"];
}

- (NSString*) writeMatch {
    if(self.finalResult == 3) {
        return [NSString stringWithFormat:@"  %i, %i, %i, , , , , , , , , , , , , , , , , , , , , , , , , , %i,   \r\n",
                self.teamNumber,
                self.matchNumber,
                self.isCompleted,
                self.finalResult];
    } else {
        return [NSString stringWithFormat:@"  %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i  \r\n",
         self.teamNumber,
         self.matchNumber,
         self.isCompleted,
         self.autoStart,
         self.autoMoved,
         self.autoHotHigh,
         self.autoHotLow,
         self.autoHigh,
         self.autoLow,
         self.autoMissed,
         self.scoreCycles,
         self.scoreTeamAssist1,
         self.scoreTeamAssist2,
         self.scoreTeamAssist3,
         self.scoreTrussPass,
         self.scoreTrussCatch,
         self.scoreHigh,
         self.scoreLow,
         self.scoreDrops,
         self.scoreMissedHigh,
         self.scoreMissedTruss,
         self.teleDriveQuality,
         self.teleTravelSpeed,
         self.teleDefenseAbility,
         self.telePickupSpeed,
         self.teleInboundSpeed,
         self.finalScore,
         self.penaltyScore,
         self.finalResult,
         self.finalPenalty,
         self.finalRobot,
         self.cycle0,
         self.cycle1,
         self.cycle2,
         self.cycle3,
         self.cycle4,
         self.cycle5,
         self.cycle6,
         self.cycle7,
         self.cycle8,
         self.cycle9];
    }
}

@end
