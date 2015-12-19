//
//  SDTeleopView.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDTeleopView.h"
#import "SDMatchStore.h"
#import "SDMatch.h"
#import "SDViewServer.h"
#import "SDTitleView.h"

@interface SDTeleopView ()

- (void) selectIndex:(int)index fromArray:(NSArray*)array;
@end

@implementation SDTeleopView

@synthesize driveQualityButtons, defenseAbilityButtons, inboundSpeedButtons, pickupSpeedButtons, travelSpeedButtons;

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

- (id) init {
    self = [super initWithNibName:@"SDTeleopView" bundle:nil];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void) saveMatch:(id)sender {
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

- (void) setMatch:(SDMatch *)editMatch originalMatch:(SDMatch *)unedittedMatch {
    match = editMatch;
    origMatch = unedittedMatch;
    
    [[SDViewServer getInstance] defineNavButtonsFor:self viewIndex:3 completed:[match isCompleted]];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidUnload {
    driveQualityButtons = nil;
    defenseAbilityButtons = nil;
    inboundSpeedButtons = nil;
    pickupSpeedButtons = nil;
    travelSpeedButtons = nil;
    
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if((match.isCompleted & 8) == 0) {
        match.isCompleted |= 8;
        UISegmentedControl *segControl = (UISegmentedControl*) [[[self toolbarItems] objectAtIndex:0] customView];
        [segControl setTitle:@"TELEOP" forSegmentAtIndex:3];
    }
    
    SDTitleView* myTitle = [[SDTitleView alloc] initWithNibName:@"SDTitleView" bundle:nil];
    self.navigationItem.titleView = myTitle.view;
    [[myTitle matchLabel] setText:[NSString stringWithFormat:@"Match %d: %d", match.matchNumber, match.teamNumber]];
    
    [self selectIndex:match.teleDriveQuality fromArray:driveQualityButtons];
    [self selectIndex:match.teleTravelSpeed fromArray:travelSpeedButtons];
    [self selectIndex:match.teleInboundSpeed fromArray:inboundSpeedButtons];
    [self selectIndex:match.telePickupSpeed fromArray:pickupSpeedButtons];
    [self selectIndex:match.teleDefenseAbility fromArray:defenseAbilityButtons];
    
    self.navigationController.toolbar.translucent = NO;
    [[self navigationController] setToolbarHidden:NO animated:NO];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self view] endEditing:YES];
}

- (IBAction) backgroundTap:(id)sender {
    [[self view] endEditing:YES];
}

- (IBAction) driveQualityButtonTap:(id)sender {
    int index = [sender tag];
    
    if (match.teleDriveQuality == index) index = 0;
    match.teleDriveQuality = index;
    [self selectIndex:index fromArray:driveQualityButtons];
}

- (IBAction) defenseAbilityButtonTap:(id)sender {
    int index = [sender tag];
    
    if (match.teleDefenseAbility == index) index = 0;
    match.teleDefenseAbility = index;
    [self selectIndex:index fromArray:defenseAbilityButtons];
}

- (IBAction) inboundSpeedButtonTap:(id)sender {
    int index = [sender tag];
    
    if (match.teleInboundSpeed == index) index = 0;
    match.teleInboundSpeed = index;
    [self selectIndex:index fromArray:inboundSpeedButtons];
}

- (IBAction) pickupSpeedButtonTap:(id)sender {
    int index = [sender tag];
    
    if (match.telePickupSpeed == index) index = 0;
    match.telePickupSpeed = index;
    [self selectIndex:index fromArray:pickupSpeedButtons];
}

- (IBAction) travelSpeedButtonTap:(id)sender {
    int index = [sender tag];
    
    if (match.teleTravelSpeed == index) index = 0;
    match.teleTravelSpeed = index;
    [self selectIndex:index fromArray:travelSpeedButtons];
}

- (IBAction) leftSwipe:(id)sender {
    UISegmentedControl* viewSelectionControl = (UISegmentedControl*)[[[self toolbarItems] objectAtIndex:0] customView];
    viewSelectionControl.selectedSegmentIndex--;
    [self selectView:viewSelectionControl];
}

- (IBAction) rightSwipe:(id)sender {
    UISegmentedControl* viewSelectionControl = (UISegmentedControl*)[[[self toolbarItems] objectAtIndex:0] customView];
    viewSelectionControl.selectedSegmentIndex++;
    [self selectView:viewSelectionControl];
}

- (IBAction) selectView:(id)sender {
    UISegmentedControl* viewSelectionControl = (UISegmentedControl*)sender;
    
    [[SDViewServer getInstance] showNewViewFor:self
                                      oldIndex:3
                                      newIndex:viewSelectionControl.selectedSegmentIndex
                                     matchData:match
                                     matchCopy:origMatch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
