//
//  DNDeck.h
//  LCDouNiu
//
//  Created by Max on 16/9/20.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNPlayingCard.h"
#import "DNPlayer.h"

@interface DNDeck : NSObject

- (void) addCard:(DNPlayingCard *)card atTop:(BOOL)atTop;
- (void) addCard:(DNPlayingCard *)card;
- (DNPlayingCard *)drawRandomCard;
- (NSUInteger) getCount;
- (void) dealCardsToPlayers:(NSArray *)players;


@end
