//
//  DNDeck.m
//  LCDouNiu
//
//  Created by Max on 16/9/20.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "DNDeck.h"

@interface DNDeck()

@property (strong, nonatomic) NSMutableArray *cards;

@end

@implementation DNDeck

- (instancetype) init {
    self = [super init];
    if (self) {
        for (NSString *suit in [DNPlayingCard validSuits]) {
            for (NSUInteger rank = 1; rank <= [DNPlayingCard maxRank]; rank++) {
                DNPlayingCard *card = [[DNPlayingCard alloc] init];
                card.suit = suit;
                card.rank = rank;
                [self addCard:card];
            }
        }
    }
    return self;
}

- (NSMutableArray *)cards {
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}

- (void) dealCardsToPlayers:(NSArray *)players {
    NSUInteger handCount = [self getCount] / [players count];
    //    NSLog(@"%lu", handCount);
    
    for (DNPlayer *player in players) {
        int count = 1;
        NSMutableArray *hand = [[NSMutableArray alloc] init];
        while (count <= handCount) {
            [hand addObject:[self drawRandomCard]];
            count++;
        }
        player.hand = hand;
    }
}

- (void) addCard:(DNPlayingCard *)card atTop:(BOOL)atTop {
    if (atTop) {
        [self.cards insertObject:card atIndex:0];
    } else {
        [self.cards addObject:card];
    }
}

- (void) addCard:(DNPlayingCard *)card {
    [self addCard:card atTop:NO];
}

- (DNPlayingCard *)drawRandomCard {
    DNPlayingCard *randomCard = nil;
    
    if ([self.cards count]) {
        unsigned index = arc4random() % [self.cards count];
        randomCard = self.cards[index];
        [self.cards removeObjectAtIndex:index];
    }
    
    return randomCard;
}

- (NSUInteger) getCount {
    return [self.cards count];
}

@end
