//
//  DNPlayer.m
//  LCDouNiu
//
//  Created by Max on 16/8/29.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "DNPlayer.h"

@implementation DNPlayer

- (instancetype)init {
    self = [super init];
    if (self) {
        //        self.combinationToPlay = [[NSMutableArray alloc] init];
    }
    return self;
}
-(DNCardGroup *)combinationToPlay {
    if (!_combinationToPlay) {
        _combinationToPlay = [[DNCardGroup alloc] init];
    }
    
    return _combinationToPlay;
}

- (void)displayHand {
    NSString *handString = [NSString stringWithFormat:@"%@'s hand:", self.name];
    for (DNPlayingCard *card in self.hand) {
        handString = [handString stringByAppendingString:@" "];
        handString = [handString stringByAppendingString:card.contents];
    }
    NSLog(@"%@", handString);
}

- (void) displayCurrentCombination {
    NSString *comboString = @"Current combo: ";
    for (DNPlayingCard *card in self.combinationToPlay.cards) {
        comboString = [comboString stringByAppendingString:@" "];
        comboString = [comboString stringByAppendingString:card.contents];
    }
    NSLog(@"%@", comboString);
}

- (void)addCardToCombination:(DNPlayingCard *)card {
    [self.combinationToPlay.cards addObject:card];
    [self displayCurrentCombination];
}

- (void)removeCardFromCombination:(DNPlayingCard *)card {
    [self.combinationToPlay.cards removeObject:card];
    [self displayCurrentCombination];
}

- (void)playCombination {
    for (DNPlayingCard *card in self.combinationToPlay.cards) {
        [self.hand removeObject:card];
    }
    self.combinationToPlay = nil;
    [self displayCurrentCombination];
    [self displayHand];
}

@end
