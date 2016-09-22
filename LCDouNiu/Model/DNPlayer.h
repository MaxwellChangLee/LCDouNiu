//
//  DNPlayer.h
//  LCDouNiu
//
//  Created by Max on 16/8/29.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNPlayingCard.h"
#import "DNCardGroup.h"

@interface DNPlayer : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray *hand;
@property (strong, nonatomic) DNCardGroup *combinationToPlay;

- (void)displayHand;
- (void)displayCurrentCombination;
- (void)addCardToCombination:(DNPlayingCard *)card;
- (void)removeCardFromCombination:(DNPlayingCard *)card;
- (void)playCombination;

@end
