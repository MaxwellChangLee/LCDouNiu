//
//  DNGame.m
//  LCDouNiu
//
//  Created by Max on 16/9/20.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "DNGame.h"

@implementation DNGame

-(instancetype)init {
    self = [super init];
    if (self) {
        self.gameState = DNGameStateUndetermined;
        
        self.player1 = [[DNPlayer alloc] init];
        self.player1.name = @"东哥";
        self.player2 = [[DNPlayer alloc] init];
        self.player2.name = @"南哥";
        self.player3 = [[DNPlayer alloc] init];
        self.player3.name = @"西哥";
        self.player4 = [[DNPlayer alloc] init];
        self.player4.name = @"北哥";
        self.players = @[self.player1, self.player2, self.player3, self.player4];
        
        self.deck = [[DNDeck alloc] init];
        [self.deck dealCardsToPlayers:self.players];
        NSArray *sortedHand = [self.player1.hand sortedArrayUsingSelector:@selector(compare:)];
        self.player1.hand = [NSMutableArray arrayWithArray:sortedHand];
        [self.player1 displayHand];
    }
    
    return self;
}

@end
