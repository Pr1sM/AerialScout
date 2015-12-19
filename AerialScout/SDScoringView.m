//
//  SDScoringView.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDScoringView.h"
#import "SDMatch.h"
#import "SDMatchStore.h"
#import "SDViewServer.h"
#import "SDTitleView.h"

// Match Cycle Data  (0-9)
//
// Bit: 0   Completed       (0=No; 1=Yes)
//      1   Ball Type       (0=Teleop; 1=Auto)
//      2   Assist          (0=No; 1=Yes)
//      3   Truss Pass      (0=No; 1=Yes)
//      4   Truss Catch     (0=No; 1=Yes)
//      5   High Goal       (0=No; 1=Yes)
//      6   Low Goal        (0=No; 1=Yes)
//    7-8   Total Assists   (0=1; 1=2; 2=3)


@interface SDScoringView () {
    bool     cancelEdit;
    int      cycleCount;
    int      cycleData;
    int      cycleIndex;
    bool     newCycleData;
}

- (int)  getCycleData:(int)index;
- (void) putCycleData:(int)data atIndex:(int)index;
- (void) showCycleData;
- (void) sumCycleData;

@end

@implementation SDScoringView

@synthesize goalScoreButtons, assistButtons, ballTypeButtons;

// Delegate Messages

- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ((cycleData & 1) == 0) {     // New Cycle
        if(buttonIndex == 0) {      // Ball Scored
            cycleData |= 1;
            [self putCycleData:cycleData atIndex:cycleIndex];
            
            if (cycleIndex < 9) {
                cycleCount++;
                cycleIndex++;
                cycleData = [self getCycleData:cycleIndex];
                
                [self showCycleData];
            }
            
        } else if(buttonIndex == 1) { // Dead Ball
            cycleData &= 27;
            [self showCycleData];
        }
        
    } else {                        // Delete Cycle
        if (buttonIndex == 0) {
            for (int i = cycleIndex; i < 8; i++) {
                int data = [self getCycleData:i + 1];
                [self putCycleData:data atIndex:i];
            }
            
            [self putCycleData:0 atIndex:9];
            cycleCount--;
            cycleData = [self getCycleData:cycleIndex];
            
            [self showCycleData];
        }
    }
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1) {
        if(buttonIndex == 1) {
            cancelEdit = YES;
            
            if([[SDViewServer getInstance] isNewMatch]) {
                [[SDMatchStore sharedStore] removeMatch:match];
                [[SDViewServer getInstance] finishedEditMatchData:nil showSummary:NO];
            } else {
                [[SDMatchStore sharedStore] replaceMatch:match withMatch:origMatch];
                [[SDViewServer getInstance] finishedEditMatchData:origMatch showSummary:YES];
            }
        
        } else {
            [self putCycleData:cycleData atIndex:cycleIndex];
            [self saveMatch:self];
        }
    }
}

- (void) stepView:(SDResizeStepperView *)stepView stepValueDidChange:(int)value {
    [[SDViewServer getInstance] setMatchEdit:YES];
}


// Class Methods

- (void) cancelMatch:(id)sender {
    [[self view] endEditing:YES];
    [[SDViewServer getInstance] cancelAlertFor:self matchData:match];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (int) getCycleData:(int)index {
    switch(index) {
        case 0:     return match.cycle0;
        case 1:     return match.cycle1;
        case 2:     return match.cycle2;
        case 3:     return match.cycle3;
        case 4:     return match.cycle4;
        case 5:     return match.cycle5;
        case 6:     return match.cycle6;
        case 7:     return match.cycle7;
        case 8:     return match.cycle8;
        default:    return match.cycle9;
    }
}

- (id)init {
    self = [super initWithNibName:@"SDScoringView" bundle:nil];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    return [self init];
}

- (void) putCycleData:(int)data atIndex:(int)index {
    switch (index) {
        case 0: match.cycle0 = data;
                break;
        case 1: match.cycle1 = data;
                break;
        case 2: match.cycle2 = data;
                break;
        case 3: match.cycle3 = data;
                break;
        case 4: match.cycle4 = data;
                break;
        case 5: match.cycle5 = data;
                break;
        case 6: match.cycle6 = data;
                break;
        case 7: match.cycle7 = data;
                break;
        case 8: match.cycle8 = data;
                break;
        case 9: match.cycle9 = data;
                break;
        default:;
    }
}

- (void) saveMatch:(id)sender {
    if(match.finalResult == 3) {
        if([[SDViewServer getInstance] matchEdit]) {
            match.finalResult = -1;
        } else {
            match.isCompleted = 31;
        }
    }

    [self sumCycleData];
    [[SDMatchStore sharedStore] saveChanges];
    [[SDViewServer getInstance] finishedEditMatchData:match showSummary:YES];
}

- (void) setMatch:(SDMatch *)editMatch originalMatch:(SDMatch *)unedittedMatch {
    match = editMatch;
    origMatch = unedittedMatch;
    
    cycleCount = cycleIndex = 0;
    if ((match.cycle0 & 1) == 1) cycleCount++;
    if ((match.cycle1 & 1) == 1) cycleCount++;
    if ((match.cycle2 & 1) == 1) cycleCount++;
    if ((match.cycle3 & 1) == 1) cycleCount++;
    if ((match.cycle4 & 1) == 1) cycleCount++;
    if ((match.cycle5 & 1) == 1) cycleCount++;
    if ((match.cycle6 & 1) == 1) cycleCount++;
    if ((match.cycle7 & 1) == 1) cycleCount++;
    if ((match.cycle8 & 1) == 1) cycleCount++;
    cycleIndex = cycleCount;
    
    [[SDViewServer getInstance] defineNavButtonsFor:self viewIndex:2 completed:[match isCompleted]];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) showCycleData {
    for(SDGradientButton* button in goalScoreButtons) {
        [button setSelected:([button tag] == 0) ? (cycleData & 32) == 32 : (cycleData & 64) == 64];
        [button setEnabled:YES];
    }

    [cycleCompletedButton setEnabled:YES];

    if ((cycleData & 2) == 0) {             // Teleop Ball
        for(UIButton* button in assistButtons) {
            [button setEnabled:YES];
        }
        [assistsLabel setTextColor:[UIColor blackColor]];
        
        [assistButton setSelected:(cycleData & 4) == 4];
        [assistButton setEnabled:YES];
        [trussCatchButton setSelected:(cycleData & 16) == 16];
        [trussCatchButton setEnabled:YES];
        [trussPassButton setSelected:(cycleData & 8) ==  8];
        [trussPassButton setEnabled:YES];
        
        [trussPassMisses.minusButton setEnabled:(trussPassMisses.countValue > trussPassMisses.minimumValue)];
        [trussPassMisses.plusButton setEnabled:(trussPassMisses.countValue < trussPassMisses.maximumValue)];
        
    } else {                                // Autonomous Ball
        for(UIButton* button in assistButtons) {
            [button setEnabled:NO];
        }
        
        [assistsLabel setTextColor:[UIColor lightGrayColor]];
        
        [assistButton setSelected:NO];
        [assistButton setEnabled:NO];
        [trussCatchButton setSelected:NO];
        [trussCatchButton setEnabled:NO];
        [trussPassButton setSelected:NO];
        [trussPassButton setEnabled:NO];
        
        [trussPassMisses.minusButton setEnabled:NO];
        [trussPassMisses.plusButton setEnabled:NO];
    }
    
    if ((cycleData & 1) == 0) {
        cycleLabel.text = [NSString stringWithFormat:@"New (%d)", cycleCount];
    } else {
        cycleLabel.text = [NSString stringWithFormat:@"%d of %d",cycleIndex + 1, cycleCount];
    }
    
    for(SDGradientButton* button in ballTypeButtons) {
        [button setSelected:([button tag] == 0) ? (cycleData & 2) == 2 : (cycleData & 2) == 0];
    }
    
    UIImage* startImage = nil;
    int allianceAssists = (cycleData & 384) / 128;
    
    if(match.alliance == 0) { // red alliance
        startImage = [UIImage imageNamed:(allianceAssists == 1) ? @"red2Assist.png" :
                      (allianceAssists == 2) ? @"red3Assist.png" :
                      @"red1Assist.png"];
    } else {
        startImage = [UIImage imageNamed:(allianceAssists == 1) ? @"blue2Assist.png" :
                      (allianceAssists == 2) ? @"blue3Assist.png" :
                      @"blue1Assist.png"];
    }
    
    assistImageView.image = startImage;
    
    [assistButton setSelected:(cycleData & 4) == 4];
    [trussPassButton setSelected:(cycleData & 8) == 8];
    [trussCatchButton setSelected:(cycleData & 16) ==16];
    
    [(SDGradientButton*)[goalScoreButtons objectAtIndex:0] setSelected:(cycleData & 32) ==32];
    [(SDGradientButton*)[goalScoreButtons objectAtIndex:1] setSelected:(cycleData & 64) == 64];
    
    previousCycleButton.enabled = (cycleIndex > 0);
    nextCycleButton.enabled = (cycleIndex < cycleCount);
    
    if (cycleIndex != cycleCount || cycleIndex == 9) {
        [cycleCompletedButton setTitle:@"Delete Cycle" forState:UIControlStateNormal];
    } else {
        [cycleCompletedButton setTitle:@"Finish Cycle" forState:UIControlStateNormal];
    }
}

- (void) sumCycleData {
    match.scoreDrops = drops.countValue;
    match.scoreMissedHigh = highGoalMisses.countValue;
    match.scoreMissedTruss = trussPassMisses.countValue;

    if (!newCycleData) return;

    newCycleData = NO;
    [self putCycleData:cycleData atIndex:cycleIndex];
    
    match.scoreAssists      = 0;
    match.scoreCycles       = 0;
    match.scoreHigh         = 0;
    match.scoreLow          = 0;
    match.scoreTeamAssist1  = 0;
    match.scoreTeamAssist2  = 0;
    match.scoreTeamAssist3  = 0;
    match.scoreTrussCatch   = 0;
    match.scoreTrussPass    = 0;
    
    for (int i = 0; i < 9; i++) {
        int  data = [self getCycleData:i];
        
        if ((data & 8) == 8)    match.scoreTrussPass++;
        if ((data & 16) == 16)  match.scoreTrussCatch++;

        if ((data & 1) == 1) {                      // Cycle Completed
            if ((data & 2) == 0)   match.scoreCycles++;
            if ((data & 32) == 32) match.scoreHigh++;
            if ((data & 64) == 64) match.scoreLow++;

            if ((data & 4) == 4) {                  // Contributed Assist
                match.scoreAssists++;
            
                switch ((data & 384) / 128) {       // Alliance Assists
                    case 0: match.scoreTeamAssist1++;
                            break;
                    case 1: match.scoreTeamAssist2++;
                            break;
                    case 2: match.scoreTeamAssist3++;
                            break;
                    default:;
                }
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    drops.ScoreLabel.layer.cornerRadius = 5.0f;
    highGoalMisses.ScoreLabel.layer.cornerRadius = 5.0f;
    trussPassMisses.ScoreLabel.layer.cornerRadius = 5.0f;
    
    cycleCompletedButton.layer.cornerRadius = 5.0f;
    previousCycleButton.layer.cornerRadius = 5.0f;
    nextCycleButton.layer.cornerRadius = 5.0f;
    
    [drops.minusButton setColor];
    [drops.plusButton setColor];
    drops.minimumValue = 0;
    drops.maximumValue = 100;
    drops.delegate = self;

    [highGoalMisses.minusButton setColor];
    [highGoalMisses.plusButton setColor];
    highGoalMisses.minimumValue = 0;
    highGoalMisses.maximumValue = 100;
    highGoalMisses.delegate = self;
    
    [trussPassMisses.minusButton setColor];
    [trussPassMisses.plusButton setColor];
    trussPassMisses.minimumValue = 0;
    trussPassMisses.maximumValue = 100;
    trussPassMisses.delegate = self;
}

- (void) viewDidUnload {
    
    goalScoreButtons = nil;
    assistButtons = nil;
    ballTypeButtons = nil;
    
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
    SDTitleView* myTitle = [[SDTitleView alloc] initWithNibName:@"SDTitleView" bundle:nil];
    self.navigationItem.titleView = myTitle.view;
    [[myTitle matchLabel] setText:[NSString stringWithFormat:@"Match %d: %d", match.matchNumber, match.teamNumber]];
    
    if((match.isCompleted & 4) == 0) {
        match.isCompleted |= 4;
        UISegmentedControl* segControl = (UISegmentedControl*)[[[self toolbarItems] objectAtIndex:0] customView];
        [segControl setTitle:@"SCORE" forSegmentAtIndex:2];
    }
    
    cycleData = [self getCycleData:cycleIndex];
    newCycleData = NO;
    cancelEdit = NO;

    drops.countValue            = match.scoreDrops;
    highGoalMisses.countValue   = match.scoreMissedHigh;
    trussPassMisses.countValue  = match.scoreMissedTruss;

    [self showCycleData];
    
    self.navigationController.toolbar.translucent = NO;
    [[self navigationController] setToolbarHidden:NO animated:NO];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (!cancelEdit) [self sumCycleData];
    [[self view] endEditing:YES];
}

// IBActions

- (IBAction) assistButtonTap:(id)sender {
    int index = [sender tag];
    cycleData = (cycleData & 127) + index * 128;
    
    UIImage* newImage = nil;
    if(match.alliance == 0) {
        newImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@", (index == 1) ? @"red2Assist.png" :
                                        (index == 2) ? @"red3Assist.png" :
                                        @"red1Assist.png"]];
    } else {
        newImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@", (index == 1) ? @"blue2Assist.png" :
                                        (index == 2) ? @"blue3Assist.png" :
                                        @"blue1Assist.png"]];
    }
    
    assistImageView.image = newImage;
    
    if (index == 2) {
        cycleData |= 4;
        [assistButton setSelected:YES];
    }
    
    [[SDViewServer getInstance] setMatchEdit:YES];
    newCycleData = YES;
}

- (IBAction) backgroundTap:(id)sender {
    [[self view] endEditing:YES];
}

- (IBAction) ballTypeChanged:(id)sender {
    
    int index = [sender tag];
    
    if (index == 0) {
        cycleData = (cycleData & 97) | 2;
    } else {
        cycleData = (cycleData & 97);
    }
    
    [self showCycleData];
    
    for(SDGradientButton* button in ballTypeButtons) [button setSelected:([button tag] == index)];
    newCycleData = YES;
}

- (IBAction) cycleButtonTap:(id)sender {
    
    if ((cycleData & 1) == 0) {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil               otherButtonTitles:@"Ball Scored", @"Dead Ball", nil];
        
        [actionSheet showFromBarButtonItem:[[self toolbarItems] objectAtIndex:0] animated:YES];
        
    } else {
        UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
        
        [actionSheet showFromBarButtonItem:[[self toolbarItems] objectAtIndex:0] animated:YES];
    }
}

- (IBAction) goalScoreButtonTap:(id)sender {
    int index = [sender tag];
    
    if (index == 0) {
        if ((cycleData & 32) == 32) cycleData ^= 32;
        else cycleData = (cycleData & 415) |32;
    } else {
        if ((cycleData & 64) == 64) cycleData ^= 64;
        else cycleData = (cycleData & 415) | 64;
    }
    
    for(SDGradientButton* button in goalScoreButtons) {
        [button setSelected:([button tag] == 0) ? (cycleData & 32) == 32 : (cycleData & 64) == 64];
    }
    
    [[SDViewServer getInstance] setMatchEdit:YES];
    newCycleData = YES;
}

- (IBAction) leftSwipe:(id)sender {
    UISegmentedControl* viewSelectionControl = (UISegmentedControl*)[[[self toolbarItems] objectAtIndex:0] customView];
    viewSelectionControl.selectedSegmentIndex--;
    [self selectView:viewSelectionControl];
}

- (IBAction) nextCycleTap:(id)sender {
    [self putCycleData:cycleData atIndex:cycleIndex];
    
    cycleIndex++;
    cycleData = [self getCycleData:cycleIndex];
    
    [self showCycleData];
}

- (IBAction) previousCycleTap:(id)sender {
    [self putCycleData:cycleData atIndex:cycleIndex];

    cycleIndex--;
    cycleData = [self getCycleData:cycleIndex];
    
    [self showCycleData];
}

- (IBAction) rightSwipe:(id)sender {
    UISegmentedControl* viewSelectionControl = (UISegmentedControl*)[[[self toolbarItems] objectAtIndex:0] customView];
    viewSelectionControl.selectedSegmentIndex++;
    [self selectView:viewSelectionControl];
}

- (IBAction) selectView:(id)sender {
    UISegmentedControl* viewSelectionControl = (UISegmentedControl*)sender;
    
    [[SDViewServer getInstance] showNewViewFor:self oldIndex:2 newIndex:viewSelectionControl.selectedSegmentIndex matchData:match matchCopy:origMatch];
}

- (IBAction) trussPassButtonTap:(id)sender {
    if ((cycleData & 8) == 8) cycleData ^= 8;
    else cycleData |= 8;
    
    [trussPassButton setSelected:(cycleData & 8) == 8];
    [[SDViewServer getInstance] setMatchEdit:YES];
    newCycleData = YES;
}

- (IBAction) trussCatchButtonTap:(id)sender {
    if ((cycleData & 16) == 16) cycleData ^= 16;
    else cycleData |= 16;
    
    [trussCatchButton setSelected:(cycleData & 16) == 16];
    [[SDViewServer getInstance] setMatchEdit:YES];
    newCycleData = YES;
}

- (IBAction) teamAssistButtonTap:(id)sender {
    if ((cycleData & 4) == 4) cycleData ^= 4;
    else cycleData |= 4;
    
    [assistButton setSelected:(cycleData & 4) == 4];
    [[SDViewServer getInstance] setMatchEdit:YES];
    newCycleData = YES;
}

@end
