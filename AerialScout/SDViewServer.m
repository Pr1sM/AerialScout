//
//  SDViewServer.m
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import "SDViewServer.h"
#import "SDMatch.h"
#import "SDMatchStore.h"
#import "SDTeamMatchView.h"
#import "SDAutoView.h"
#import "SDScoringView.h"
#import "SDTeleopView.h"
#import "SDFinalView.h"
#import "SDMatchSummaryView.h"

@interface SDViewServer() {
}

@end

@implementation SDViewServer

@synthesize isNewMatch, matchEdit;

+ (SDViewServer*) getInstance {
    // Get singleton instance of View Server
    
    static SDViewServer* serverInstance = nil;
    
    if(!serverInstance) {
        serverInstance = [[super allocWithZone:nil] init];
    }
    
    return serverInstance;
}

+ (id) allocWithZone:(NSZone *)zone {
    return [self getInstance];
}

- (void) defineNavButtonsFor:(UIViewController *)viewController viewIndex:(NSInteger)vIndex completed:(int)isCompleted {
    // Configure navigation buttons for the five match Views
    
    [[viewController navigationItem] setHidesBackButton:YES animated:NO];
    
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:viewController action:@selector(saveMatch:)];
    
    [[viewController navigationItem] setRightBarButtonItem:doneItem animated:NO];
    
    UIBarButtonItem* cancelItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:viewController action:@selector(cancelMatch:)];
    
    [[viewController navigationItem] setLeftBarButtonItem:cancelItem animated:NO];
    
    // configure labels for Toolbar buttons.  Use all caps if page is completed
    
    NSMutableArray* labels = [[NSMutableArray alloc] init];
    
    if(isCompleted & 1) [labels addObject:@"MATCH"];
    else [labels addObject:@"Match"];
    
    if(isCompleted & 2) [labels addObject:@"AUTO"];
    else [labels addObject:@"Auto"];
    
    if(isCompleted & 4) [labels addObject:@"SCORE"];
    else [labels addObject:@"Score"];
    
    if(isCompleted & 8) [labels addObject:@"TELEOP"];
    else [labels addObject:@"Teleop"];
    
    if(isCompleted & 16) [labels addObject:@"FINAL"];
    else [labels addObject:@"Final"];
    
    // Create Toolbar segmented control and configure
    
    UISegmentedControl *toolButtons = [[UISegmentedControl alloc] initWithItems:labels];
    
    [toolButtons setSelectedSegmentIndex:vIndex];
    [toolButtons setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [toolButtons setSegmentedControlStyle:UISegmentedControlStyleBar];
    [toolButtons setFrame:CGRectMake(0, 0, 300, 30)];
    [toolButtons addTarget:viewController action:@selector(selectView:) forControlEvents:UIControlEventValueChanged];
    
    UIBarButtonItem* viewItem = [[UIBarButtonItem alloc] initWithCustomView:toolButtons];
    [viewController setToolbarItems:[NSArray arrayWithObject:viewItem]];
}

- (void) showNewViewFor:(UIViewController *)viewController
               oldIndex:(NSInteger)oIndex
               newIndex:(NSInteger)nIndex
              matchData:(SDMatch *)match
              matchCopy:(SDMatch *)origMatch {
    // Create Instance of view selected from Toolbar, reconfigure Navigation Controller view list, present New view
    
    UIViewController *newView;
    NSArray* newViewList;
    NSArray* viewList = [[viewController navigationController] viewControllers];
    
    switch (nIndex) {
        case 0: {
            SDTeamMatchView* teamMatchView = [[SDTeamMatchView alloc] initWithNibName:@"SDTeamMatchView" bundle:nil];
            [teamMatchView setMatch:match originalMatch:origMatch];
            newView = teamMatchView;
        } break;
            
        case 1: {
            SDAutoView* autoView = [[SDAutoView alloc] initWithNibName:@"SDAutoView" bundle:nil];
            [autoView setMatch:match originalMatch:origMatch];
            newView = autoView;
        } break;
            
        case 2: {
            SDScoringView* scoringView = [[SDScoringView alloc] initWithNibName:@"SDScoringView" bundle:nil];
            [scoringView setMatch:match originalMatch:origMatch];
            newView = scoringView;
        } break;
            
        case 3: {
            SDTeleopView* teleopView = [[SDTeleopView alloc] initWithNibName:@"SDTeleopView" bundle:nil];
            [teleopView setMatch:match originalMatch:origMatch];
            newView = teleopView;
        } break;
            
        case 4: {
            SDFinalView* finalView = [[SDFinalView alloc] initWithNibName:@"SDFinalView" bundle:nil];
            [finalView setMatch:match originalMatch:origMatch];
            newView = finalView;
        } break;
            
        default:
            break;
    }
    
    if(oIndex == -1) {
        matchSummary = (SDMatchSummaryView*)viewController;
        
        UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:newView];
        
        if(NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
            [[navController navigationBar] setBarTintColor:[UIColor orangeColor]];
            [[navController navigationBar] setTintColor:[UIColor whiteColor]];
            [[navController toolbar] setBarTintColor:[UIColor orangeColor]];
            [[navController toolbar] setTintColor:[UIColor whiteColor]];
            navController.navigationBar.translucent = NO;
        } else {
            [[navController navigationBar] setTintColor:[UIColor orangeColor]];
            [[navController toolbar] setTintColor:[UIColor orangeColor]];
        }
        [matchSummary presentViewController:navController animated:NO completion:nil];
    } else if(nIndex < oIndex) {
        if([viewList count] == 1) {
            newViewList = [NSArray arrayWithObjects:newView, [viewList objectAtIndex:0], nil];
        } else {
            newViewList = [NSArray arrayWithObjects:[viewList objectAtIndex:0], newView, [viewList objectAtIndex:[viewList count] - 1], nil];
        }
        [[viewController navigationController] setViewControllers:newViewList animated:YES];
        [[viewController navigationController] popViewControllerAnimated:YES];
    } else {
        if([viewList count] == 1) {
            newViewList = [NSArray arrayWithObjects:[viewList objectAtIndex:0], nil];
        } else {
            newViewList = [NSArray arrayWithObjects:[viewList objectAtIndex:0], [viewList objectAtIndex:[viewList count] - 1], nil];
        }
        [[viewController navigationController] setViewControllers:newViewList animated:YES];
        [[viewController navigationController] pushViewController:newView animated:YES];
    }
}

- (void) cancelAlertFor:(UIViewController *)viewController matchData:(SDMatch *)match {
    // Common Alert View for canceling a match edit
    
    NSString* myTitle;
    NSString* myMessage;
    
    if(!matchEdit) {
        if(match.finalResult == 3) match.isCompleted = 31;
        
        if(isNewMatch) {
            [[SDMatchStore sharedStore] removeMatch:match];
            [self finishedEditMatchData:match showSummary:NO];
        } else {
            [self finishedEditMatchData:match showSummary:YES];
        }
        
        return;
    } else if(isNewMatch) {
        myTitle = @"Cancel New";
        myMessage = @"Save the New Match";
    } else {
        myTitle = @"Cancel Edit";
        myMessage = @"Save changes to the Match";
    }
    
    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:myTitle
                                                        message:myMessage
                                                       delegate:viewController
                                              cancelButtonTitle:@"Yes"
                                              otherButtonTitles:@"No", nil];
    
    alertView.tag = 1;
    [alertView show];
}

- (void) finishedEditMatchData:(SDMatch*)match showSummary:(BOOL)show {
    if(show) {
        [matchSummary setMatch:match];
        [matchSummary dismissViewControllerAnimated:YES completion:nil];
    } else {
        [matchSummary dismissViewControllerAnimated:YES completion:nil];
        [[matchSummary navigationController] popToRootViewControllerAnimated:YES];
    }
}

- (IBAction) selectView:(id)sender {
    
}

- (IBAction) saveMatch:(id)sender {
    
}

- (IBAction) cancelMatch:(id)sender {
    
}

@end
