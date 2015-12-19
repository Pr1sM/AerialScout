//
//  SDAutoView.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDAutoView.h"
#import "SDMatch.h"
#import "SDMatchStore.h"
#import "SDViewServer.h"
#import "SDTitleView.h"

@interface SDAutoView () {
    NSArray* stepViews;
}
- (void) isDataComplete;
- (void) selectIndex:(int)index fromArray:(NSArray*)array;
- (void) setStepperLimits;
@end

@implementation SDAutoView

@synthesize autoStartPositionButtons, autoMoveBonusButtons;

- (void) stepView:(SDResizeStepperView *)stepView stepValueDidChange:(int)value {
    
    for(SDResizeStepperView* step in stepViews) {
        if(step != stepView) {
            switch (value) {
                case 1:
                    step.maximumValue = step.maximumValue - 1;
                    break;
                case -1:
                    step.maximumValue = step.maximumValue + 1;
                    break;
            }
        }
    }
    
    [[SDViewServer getInstance] setMatchEdit:YES];
    [self savePage];
}

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
    self = [super initWithNibName:@"SDAutoView" bundle:nil];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self init];
}

- (void) isDataComplete {
    bool completed = (match.autoStart>=0 && match.autoMoved >= 0);
    
    [startFlag setHidden:(match.autoStart >= 0)];
    [moveFlag setHidden:(match.autoMoved >= 0)];
    
    [[SDViewServer getInstance] setMatchEdit:YES];
    
    UISegmentedControl* segControl = (UISegmentedControl*)[[[self toolbarItems] objectAtIndex:0] customView];
    
    if(completed) {
        match.isCompleted |= 2;
        [segControl setTitle:@"AUTO" forSegmentAtIndex:1];
    } else if(match.isCompleted & 2) {
        match.isCompleted ^= 2;
        [segControl setTitle:@"Auto" forSegmentAtIndex:1];
    }
}

- (void) savePage {
    match.autoHotHigh = hotHigh.countValue;
    match.autoHotLow = hotLow.countValue;
    match.autoHigh = high.countValue;
    match.autoLow = low.countValue;
    match.autoMissed = missed.countValue;
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

- (void) setMatch:(SDMatch *)editMatch originalMatch:(SDMatch *)unedittedMatch {
    match = editMatch;
    origMatch = unedittedMatch;
    
    [[SDViewServer getInstance] defineNavButtonsFor:self viewIndex:1 completed:[match isCompleted]];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    stepViews = [[NSArray alloc] initWithObjects:hotHigh, hotLow, high, low, missed, nil];
    
    hotHigh.ScoreLabel.layer.cornerRadius = 5.0f;
    hotLow.ScoreLabel.layer.cornerRadius  = 5.0f;
    high.ScoreLabel.layer.cornerRadius    = 5.0f;
    low.ScoreLabel.layer.cornerRadius     = 5.0f;
    missed.ScoreLabel.layer.cornerRadius  = 5.0f;
    
    [hotHigh.minusButton setColor];
    [hotHigh.plusButton setColor];
    hotHigh.minimumValue = 0;
    hotHigh.delegate = self;
    
    [hotLow.minusButton setColor];
    [hotLow.plusButton setColor];
    hotLow.minimumValue = 0;
    hotLow.delegate = self;
    
    [high.minusButton setColor];
    [high.plusButton setColor];
    high.minimumValue = 0;
    high.delegate = self;
    
    [low.minusButton setColor];
    [low.plusButton setColor];
    low.minimumValue = 0;
    low.delegate = self;
    
    [missed.minusButton setColor];
    [missed.plusButton setColor];
    missed.minimumValue = 0;
    missed.delegate = self;
}

- (void) viewDidUnload {
    autoStartPositionButtons = nil;
    autoMoveBonusButtons = nil;
    
    [super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if((match.hasViewed & 2) == 0) {
        match.autoHotHigh      = 0;
        match.autoHotLow       = 0;
        match.autoHigh         = 0;
        match.autoLow          = 0;
        match.autoMissed       = 0;
        
        match.hasViewed |= 2;
    }
    
    SDTitleView* myTitle = [[SDTitleView alloc] initWithNibName:@"SDTitleView" bundle:nil];
    self.navigationItem.titleView = myTitle.view;
    [[myTitle matchLabel] setText:[NSString stringWithFormat:@"Match %d: %d", match.matchNumber, match.teamNumber]];
    
    [self selectIndex:match.autoStart fromArray:autoStartPositionButtons];
    [self selectIndex:match.autoMoved fromArray:autoMoveBonusButtons];

    hotHigh.maximumValue    = 3;
    hotLow.maximumValue     = 3;
    high.maximumValue       = 3;
    low.maximumValue        = 3;
    missed.maximumValue     = 3;

    hotHigh.countValue = match.autoHotHigh;
    hotLow.countValue  = match.autoHotLow;
    high.countValue    = match.autoHigh;
    low.countValue     = match.autoLow;
    missed.countValue  = match.autoMissed;
    
    [self setStepperLimits];
    
    [startFlag setHidden:(match.autoStart >= 0)];
    [moveFlag setHidden:(match.autoMoved >= 0)];
    
    self.navigationController.toolbar.translucent = NO;
    [[self navigationController] setToolbarHidden:NO animated:NO];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[self view] endEditing:YES];
    [self savePage];
}

- (IBAction) backgroundTap:(id)sender {
    [[self view] endEditing:YES];
}

- (IBAction) startButtonTap:(id)sender {
    int index = [sender tag];
    match.autoStart = index;
    [self selectIndex:index fromArray:autoStartPositionButtons];
    [self isDataComplete];
}

- (IBAction) moveButtonTap:(id)sender {
    int index = [sender tag];
    match.autoMoved = index;
    [self selectIndex:index fromArray:autoMoveBonusButtons];
    [self isDataComplete];
}

- (void) setStepperLimits {
    for(SDResizeStepperView* aStep in stepViews) {
        for(SDResizeStepperView* bStep in stepViews) {
            if(aStep != bStep) {
                aStep.maximumValue = aStep.maximumValue - bStep.countValue;
            }
        }
    }
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
    
    [[SDViewServer getInstance] showNewViewFor:self oldIndex:1 newIndex:viewSelectionControl.selectedSegmentIndex matchData:match matchCopy:origMatch];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
