//
//  SDMatchSummaryView.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/6/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDMatchSummaryView.h"
#import "SDMatch.h"
#import "SDTeamMatchView.h"
#import "SDViewServer.h"
#import "SDTitleView.h"

@interface SDMatchSummaryView ()

@end

@implementation SDMatchSummaryView

@synthesize match;

- (void) dismissSummary:(id)sender {
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

- (void) editMatch:(id)sender {
    SDMatch* matchCopy = [[SDMatch alloc] initWithCopy:[self match]];
    if(match.finalResult == 3) match.isCompleted = 31;
    
    int newIndex = !(match.isCompleted & 2)  ? 1:
                   !(match.isCompleted & 4)  ? 2:
                   !(match.isCompleted & 8)  ? 3:
                   !(match.isCompleted & 16) ? 4:
                                               0;
    
    [[SDViewServer getInstance] setIsNewMatch:NO];
    [[SDViewServer getInstance] setMatchEdit:NO];
    [[SDViewServer getInstance] showNewViewFor:self oldIndex:-1 newIndex:newIndex matchData:match matchCopy:matchCopy];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UIBarButtonItem* doneItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                     target:self
                                     action:@selector(dismissSummary:)];
        
        [[self navigationItem] setRightBarButtonItem:doneItem];
        
        UIBarButtonItem* editItem = [[UIBarButtonItem alloc]
                                     initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                     target:self
                                     action:@selector(editMatch:)];
        
        [[self navigationItem] setLeftBarButtonItem:editItem];
    }
    return self;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIScrollView* scrollView = (UIScrollView*)self.view;
    scrollView.contentSize = CGSizeMake(320, 648);
}

- (void) viewDidUnload {
    autoStartLabel = nil;
    autoMoveLabel  = nil;
    autoScoreLabel = nil;
    
    scoreDropsLabel = nil;
    scoreHighLabel = nil;
    scoreLowLabel = nil;
    scoreTrussPassLabel = nil;
    scoreTrussCatchLabel = nil;
    scoreAssistContributionsLabel = nil;
    
    teleDriveQualityLabel = nil;
    teleTravelSpeedLabel = nil;
    telePickupSpeedLabel = nil;
    
    finalRobotLabel = nil;
    finalScoreLabel = nil;
    finalResultLabel = nil;
    finalPenaltyLabel = nil;
    finalPenaltyCardLabel = nil;
    
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self navigationController] setToolbarHidden:YES animated:YES];
    
    if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        self.navigationController.navigationBar.translucent = NO;
    }
    
    SDTitleView* myTitle = [[SDTitleView alloc] initWithNibName:@"SDTitleView" bundle:nil];
    self.navigationItem.titleView = myTitle.view;
    
    if (match.matchNumber == 0) {
        [[myTitle matchLabel] setText:@"New Match"];
    } else {
        [[myTitle matchLabel] setText:[NSString stringWithFormat:@"Match: %d: %d", match.matchNumber, match.teamNumber]];
    }
    
    if(match.finalResult == 3) {
        [checkmarkImage setHidden:NO];
        
        autoStartLabel.text         = @"";
        autoScoreLabel.text         = @"";
        autoMoveLabel.text          = @"";
        
        scoreDropsLabel.text        = @"";
        scoreHighLabel.text         = @"";
        scoreLowLabel.text          = @"";
        scoreTrussPassLabel.text    = @"";
        scoreTrussCatchLabel.text   = @"";
        
        scoreAssistContributionsLabel.text = @"";
        
        teleDriveQualityLabel.text  = @"";
        teleTravelSpeedLabel.text   = @"";
        teleDefenseAbility.text     = @"";
        telePickupSpeedLabel.text   = @"";
        teleInboundSpeedLabel.text  = @"";
        
        finalRobotLabel.text        = @"";
        finalScoreLabel.text        = @"";
        finalResultLabel.text       = @"No Show";
        finalPenaltyLabel.text      = @"";
        finalPenaltyCardLabel.text  = @"";
        
        return;
    }
    
    [checkmarkImage setHidden:(match.isCompleted != 31)];
    
    autoStartLabel.text = [NSString stringWithFormat:@"%@", match.autoStart == 0 ? @"Left" :
                                                            match.autoStart == 1 ? @"Center" :
                                                            match.autoStart == 2 ? @"Right" :
                                                            match.autoStart == 3 ? @"Goalie" :
                                                                                   @""];
    
    autoMoveLabel.text = [NSString stringWithFormat:@"%@", match.autoMoved == 0 ? @"Stayed" :
                                                            match.autoMoved == 1 ? @"Moved" :
                                                                                   @""];
    
    if((match.autoHotHigh) == -1) {
        autoScoreLabel.text = @"";
    } else {
        autoScoreLabel.text = [NSString stringWithFormat:@"%i-%i-%i-%i / %i", match.autoHotHigh,
                                                                              match.autoHigh,
                                                                              match.autoHotLow,
                                                                              match.autoLow,
                                                                             (match.autoHotHigh + match.autoHotLow + match.autoHigh + match.autoLow + match.autoMissed)];
    }
    
    
    if((match.isCompleted & 4) == 0) {
        scoreDropsLabel.text = @"";
        scoreHighLabel.text = @"";
        scoreLowLabel.text = @"";
        scoreTrussCatchLabel.text = @"";
        scoreTrussPassLabel.text = @"";
        scoreAssistContributionsLabel.text = @"";
   } else {
    
       scoreDropsLabel.text = [NSString stringWithFormat:@"%d", match.scoreDrops];
       scoreHighLabel.text = [NSString stringWithFormat:@"%d / %d", match.scoreHigh, (match.scoreHigh + match.scoreMissedHigh)];
       scoreLowLabel.text = [NSString stringWithFormat:@"%d", match.scoreLow];
       scoreTrussCatchLabel.text = [NSString stringWithFormat:@"%d", match.scoreTrussCatch];
       scoreTrussPassLabel.text = [NSString stringWithFormat:@"%d / %d", match.scoreTrussPass, (match.scoreTrussPass + match.scoreMissedTruss)];
       
       scoreAssistContributionsLabel.text = [NSString stringWithFormat:@"%d / %d", (match.scoreTeamAssist1+match.scoreTeamAssist2+match.scoreTeamAssist3), match.scoreCycles];
    }
    
    teleDriveQualityLabel.text = [NSString stringWithFormat:@"%@", (match.teleDriveQuality == 1) ? @"Poor" :
                                  (match.teleDriveQuality == 2) ? @"Excellent" : @"---" ];
    
    teleTravelSpeedLabel.text = [NSString stringWithFormat:@"%@", (match.teleTravelSpeed == 1) ? @"Slow" :
                                 (match.teleTravelSpeed == 2) ? @"Fast" : @"---"];
    
    teleDefenseAbility.text = [NSString stringWithFormat:@"%@", (match.teleDefenseAbility == 1) ? @"Poor" :
                                                                (match.teleDefenseAbility == 2) ? @"Excellent" : @"---" ];
    
    teleInboundSpeedLabel.text = [NSString stringWithFormat:@"%@", (match.teleInboundSpeed == 1) ? @"Slow" :
                                                                   (match.teleInboundSpeed == 2) ? @"Fast" : @"---"];
    
    telePickupSpeedLabel.text = [NSString stringWithFormat:@"%@", (match.telePickupSpeed == 1) ? @"Slow" :
                                                                  (match.telePickupSpeed == 2) ? @"Fast" : @"---" ];
    
    finalRobotLabel.text = [NSString stringWithFormat:@"%@", (match.finalRobot == 0) ? @"---" :
                                                             (match.finalRobot == 1) ? @"Stalled" :
                                                             (match.finalRobot == 2) ? @"Tipped Over" :
                                                             (match.finalRobot == 3) ? @"Stall+Tipped" : @""];
    
    if(match.finalScore < 0 || match.penaltyScore < 0) {
        finalScoreLabel.text = @"";
    } else {
        finalScoreLabel.text = [NSString stringWithFormat:@"%d (%d)", match.finalScore, match.penaltyScore];
    }
    
    finalResultLabel.text = [NSString stringWithFormat:@"%@", (match.finalResult == 0) ? @"Loss" :
                                                              (match.finalResult == 1) ? @"Win" :
                                                              (match.finalResult == 2) ? @"Tie" :
                                                              (match.finalResult == 3) ? @"No Show" :
                                                                                       @""];
    
    if(match.finalPenalty == -1 && (match.isCompleted & 16) == 0) {
        finalPenaltyLabel.text = @"";
        finalPenaltyCardLabel.text = @"";
    } else {
        switch (match.finalPenalty & 3) {
            case -1:finalPenaltyLabel.text = @"";          break;
            case 0: finalPenaltyLabel.text = @"None";      break;
            case 1: finalPenaltyLabel.text = @"Foul";      break;
            case 2: finalPenaltyLabel.text = @"Technical"; break;
            case 3: finalPenaltyLabel.text = @"Foul+Tech"; break;
        }
        
        switch (match.finalPenalty & 12) {
            case -1: finalPenaltyCardLabel.text = @"";           break;
            case 0:  finalPenaltyCardLabel.text = @"None";       break;
            case 4:  finalPenaltyCardLabel.text = @"Yellow";     break;
            case 8:  finalPenaltyCardLabel.text = @"Red";        break;
            case 12: finalPenaltyCardLabel.text = @"Yellow+Red"; break;
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
