//
//  DNPlayingCard.m
//  LCDouNiu
//
//  Created by Max on 16/8/29.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "DNPlayingCard.h"

@implementation DNPlayingCard

@synthesize suit = _suit;

-(BOOL)isSuitBlack {
    if ([self.suit isEqualToString:@"♠︎"] || [self.suit isEqualToString:@"♣︎"]) {
        return YES;
    }
    return NO;
}

- (BOOL)isSuitRed {
    if ([self.suit isEqualToString:@"♦︎"] || [self.suit isEqualToString:@"♥︎"]) {
        return YES;
    }
    return NO;
}

- (NSString *)contents {
    NSArray *rankStrings = [DNPlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (void) setRank:(NSUInteger)rank {
    if (rank <= [DNPlayingCard maxRank]) {
        _rank = rank;
    }
}

- (NSString *) rankAsString {
    NSArray *rankStrings = [DNPlayingCard rankStrings];
    return rankStrings[self.rank];
}

- (NSString *)suit {
    return _suit ? _suit : @"?";
}

- (void) setSuit:(NSString *)suit {
    if ([[DNPlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSComparisonResult)compare:(DNPlayingCard *)otherCard {
    NSArray *ranksInOrder = @[@"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K", @"A", @"2"];
    NSArray *suitsInOrder = @[@"♠︎", @"♣︎", @"♦︎", @"♥︎"];
    
    NSInteger rankCheck = [ranksInOrder indexOfObject:self.rankAsString] - [ranksInOrder indexOfObject:otherCard.rankAsString];
    NSInteger suitCheck = [suitsInOrder indexOfObject:self.suit] - [suitsInOrder indexOfObject:otherCard.suit];
    
    if (rankCheck > 0) {
        return NSOrderedDescending;
    } else if (rankCheck < 0) {
        return NSOrderedAscending;
    } else { // Ranks are the same
        if (suitCheck > 0) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }
}

+ (NSArray *)validSuits {
    return @[@"♠︎", @"♣︎", @"♦︎", @"♥︎"];
}

+ (NSArray *)rankStrings {
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank {
    return [[DNPlayingCard rankStrings] count] -1;
}

@end
