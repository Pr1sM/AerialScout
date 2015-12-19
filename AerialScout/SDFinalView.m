//
//  SDFinalView.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDFinalView.h"
#import "SDMatch.h"
#import "SDMatchStore.h"
#import "SDViewServer.h"
#import "SDTitleView.h"

@interface SDFinalView ()

- (void) dismissKeypad;
- (void) selectIndex:(int)index fromArray:(NSArray*)array;

@end

@implementation SDFinalView

@synthesize resultButtons, penaltyButtons, robotButtons;

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == 1) {
        if(buttonIndex == 1) {
            if([[SDViewServer getInstance] isNewMatch]) {
                [[SDMatchStore sharedStore] removeMatch:match];
                [[SDViewServer getInstance] finishedEditMatchData:nil showSummary:NO];
            } else {
                [[SDMatchStore sharedStore] replaceMatch:match withMatch:origMatch];
                [[SDViewServer getInstance] finishedEditMatchData:origMatch showSummary:YES];
            }
        } else {
            [self saveMatch:self];
        }
    }
}

- (void) cancelMatch:(id)sender {
    [[self view] endEditing:YES];
    [[SDViewServer getInstance] cancelAlertFor:self matchData:match];
}

- (void) dismissKeypad {
    keypadShown = NO;
    [[self view] endEditing:YES];
    [[[self navigationItem] rightBarButtonItem] setEnabled:YES];
}

- (id) init {
    self = [super initWithNibName:@"SDFinalView" bundle:nil];
    if(self) {
        keypadShown = NO;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void) setMatch:(SDMatch *)editMatch originalMatch:(SDMatch *)unedittedMatch {
    match = editMatch;
    origMatch = unedittedMatch;
    
    [[SDViewServer getInstance] defineNavButtonsFor:self viewIndex:4 completed:[match isCompleted]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidUnload {
    finalScoreField = nil;
    resultButtons = nil;
    penaltyButtons = nil;
    robotButtons = nil;
    
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if((match.hasViewed & 4) == 0) {
        match.finalPenalty = 0;
        match.finalRobot = 0;
        match.hasViewed |= 4;
    }
    
    SDTitleView* myTitle = [[SDTitleView alloc] initWithNibName:@"SDTitleView" bundle:nil];
    self.navigationItem.titleView = myTitle.view;
    
    [[myTitle matchLabel] setText:[NSString stringWithFormat:@"Match %d: %d", match.matchNumber, match.teamNumber]];
    
    if(match.finalScore >= 0) {
        [finalScoreField setText:[NSString stringWithFormat:@"%d", match.finalScore]];
    } else {
        [finalScoreField setText:@""];
    }
    
    if (match.penaltyScore >= 0) {
        [finalPenalyField setText:[NSString stringWithFormat:@"%d", match.penaltyScore]];
    } else {
        [finalPenalyField setText:@""];
    }
    
    [resultFlag setHidden:(match.finalResult >= 0)];
    [scoreFlag setHidden:([[finalScoreField text] length] != 0)];
    [penaltyFlag setHidden:([[finalPenalyField text] length] != 0)];
    
    [self selectIndex:match.finalResult fromArray:resultButtons];
    
    [(SDGradientButton*)[penaltyButtons objectAtIndex:0] setSelected:(match.finalPenalty & 1) == 1];
    [(SDGradientButton*)[penaltyButtons objectAtIndex:1] setSelected:(match.finalPenalty & 2) == 2];
    [(SDGradientButton*)[penaltyButtons objectAtIndex:2] setSelected:(match.finalPenalty & 4) == 4];
    [(SDGradientButton*)[penaltyButtons objectAtIndex:3] setSelected:(match.finalPenalty & 8) == 8];
    
    [(SDGradientButton*)[robotButtons objectAtIndex:0] setSelected:(match.finalRobot & 1) == 1];
    [(SDGradientButton*)[robotButtons objectAtIndex:1] setSelected:(match.finalRobot & 2) == 2];
    
    
    self.navigationController.toolbar.translucent = NO;
    [[self navigationController] setToolbarHidden:NO animated:NO];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[self view] endEditing:YES];
    [self savePage];
}

- (void) savePage {
    if([[finalScoreField text] length] > 0) {
        match.finalScore = [[finalScoreField text] intValue];
    } else {
        match.finalScore = -1;
    }
    
    if ([[finalPenalyField text] length] > 0) {
        match.penaltyScore = [[finalPenalyField text] intValue];
    } else {
        match.penaltyScore = -1;
    }
}

- (void) saveMatch:(id)sender {
    [self savePage];
    
    if(match.finalResult == 3) {
        if([[SDViewServer getInstance] matchEdit]) {
            match.finalResult = -1;
        } else {
            match.isCompleted = 31;
        }
    }
    
    [[SDMatchStore sharedStore] saveChanges];
    [[SDViewServer getInstance] finishedEditMatchData:match showSummary:YES];
}

- (void) selectIndex:(int)index fromArray:(NSArray *)array {
    bool isSelected;
    
    for(int i = 0; i < [array count]; i++) {
        isSelected = ([(SDGradientButton*)[array objectAtIndex:i] tag] == index);
        [(SDGradientButton*)[array objectAtIndex:i] setSelected:isSelected];
    }
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction) backgroundTap:(id)sender {
    [self dismissKeypad];
    keypadShown = NO;
}

- (IBAction) beginScoreEdit:(id)sender {
    keypadShown = YES;
    [[[self navigationItem] rightBarButtonItem] setEnabled:NO];
}

- (IBAction) isDataComplete:(id)sender {
    BOOL completed = ([[finalScoreField text] length] == 0)  ? NO:
                     ([[finalPenalyField text] length] == 0) ? NO:
                     (match.finalResult < 0)                 ? NO:
                                                              YES;
    
    [resultFlag setHidden:(match.finalResult >= 0)];
    [scoreFlag setHidden:([[finalScoreField text] length] != 0)];
    [penaltyFlag setHidden:([[finalPenalyField text] length] != 0)];
    
    [[SDViewServer getInstance] setMatchEdit:YES];
    
    if(completed) {
        match.isCompleted |= 16;
        UISegmentedControl* segControl = (UISegmentedControl*)[[[self toolbarItems] objectAtIndex:0] customView];
        [segControl setTitle:@"FINAL" forSegmentAtIndex:4];
    } else if(match.isCompleted & 16) {
        match.isCompleted ^= 16;
        UISegmentedControl* segControl = (UISegmentedControl*)[[[self toolbarItems] objectAtIndex:0] customView];
        [segControl setTitle:@"Final" forSegmentAtIndex:4];
    }
}

- (IBAction) penaltyButtonTap:(id)sender {
    if(keypadShown) {
        [self dismissKeypad];
        keypadShown = NO;
        return;
    }
    
    int index = [sender tag];
    int bitValue = 1 << index;
    bool selected;
    
    if((match.finalPenalty & bitValue) == bitValue) {
        match.finalPenalty ^= bitValue;
        selected = NO;
    } else {
        match.finalPenalty |= bitValue;
        selected = YES;
        
        
        if(index == 2) {
            if((match.finalPenalty & 8) == 8) {
                match.finalPenalty ^= 8;
                [(SDGradientButton*)[penaltyButtons objectAtIndex:3] setSelected:NO];
            }
        } else if(index == 3) {
            if((match.finalPenalty & 4) == 4) {
                match.finalPenalty ^= 4;
                [(SDGradientButton*)[penaltyButtons objectAtIndex:2] setSelected:NO];
            }
        }
    }
    
    [[SDViewServer getInstance] setMatchEdit:YES];
    [(SDGradientButton*)[penaltyButtons objectAtIndex:index] setSelected:selected];

}

- (IBAction) resultButtonTap:(id)sender {
    if(keypadShown) {
        [self dismissKeypad];
        keypadShown = NO;
        return;
    }
    
    int index = [sender tag];
    match.finalResult = index;
    [self selectIndex:index fromArray:resultButtons];
    
    [self isDataComplete:self];
}

- (IBAction) robotButtonTap:(id)sender {
    if(keypadShown) {
        [self dismissKeypad];
        keypadShown = NO;
        return;
    }
    
    int index = [sender tag];
    int bitValue = 1 << index;
    bool selected;
    
    if((match.finalRobot & bitValue) == bitValue) {
        match.finalRobot ^= bitValue;
        selected = NO;
    } else {
        match.finalRobot |= bitValue;
        selected = YES;
    }
    
    [[SDViewServer getInstance] setMatchEdit:YES];
    [(SDGradientButton*)[robotButtons objectAtIndex:index] setSelected:selected];
}

- (IBAction) leftSwipe:(id)sender {
    UISegmentedControl* viewSelectionControl = (UISegmentedControl*)[[[self toolbarItems] objectAtIndex:0] customView];
    viewSelectionControl.selectedSegmentIndex--;
    [self selectView:viewSelectionControl];
}

- (IBAction) selectView:(id)sender {
    UISegmentedControl* viewSelectionControl = (UISegmentedControl*)sender;
    
    [[SDViewServer getInstance] showNewViewFor:self oldIndex:4 newIndex:viewSelectionControl.selectedSegmentIndex matchData:match matchCopy:origMatch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
