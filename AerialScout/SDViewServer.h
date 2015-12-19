//
//  SDViewServer.h
//  AerialScout
//
//  Created by Srinivas Dhanwada on 1/7/14.
//  Copyright (c) 2014 Srinivas Dhanwada. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDMatch;
@class SDMatchSummaryView;

@interface SDViewServer : NSObject {
    SDMatchSummaryView* matchSummary;
}

@property (nonatomic) BOOL isNewMatch;
@property (nonatomic) BOOL matchEdit;

+ (SDViewServer*) getInstance;

- (void) defineNavButtonsFor:(UIViewController*)viewController
                   viewIndex:(NSInteger)vIndex
                   completed:(int)isCompleted;

- (void) showNewViewFor:(UIViewController*)viewController
               oldIndex:(NSInteger)oIndex
               newIndex:(NSInteger)nIndex
              matchData:(SDMatch*)match
              matchCopy:(SDMatch*)origMatch;

- (void) cancelAlertFor:(UIViewController*)viewController
              matchData:(SDMatch*)match;

- (void) finishedEditMatchData:(SDMatch*)match
                   showSummary:(BOOL)show;

@end
