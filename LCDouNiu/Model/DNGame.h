//
//  DNGame.h
//  LCDouNiu
//
//  Created by Max on 16/9/20.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNPlayer.h"
#import "DNDeck.h"

typedef enum {
    DNGameStateUndetermined,
    DNGameStateSingles,
    DNGameStateDoubles,
    DNGameStateTriples,
    DNGameStateBomb,
    DNGameStateRun
} DNGameState;

@interface DNGame : NSObject

@property (nonatomic) DNGameState gameState;
@property (strong, nonatomic) DNDeck *deck;
@property (strong, nonatomic) NSArray *players;

@property (strong, nonatomic) DNPlayer * player1;
@property (strong, nonatomic) DNPlayer * player2;
@property (strong, nonatomic) DNPlayer * player3;
@property (strong, nonatomic) DNPlayer * player4;

@property (strong, nonatomic) NSMutableArray *selectedCards;

@end
