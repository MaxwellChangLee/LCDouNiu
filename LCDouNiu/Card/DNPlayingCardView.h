//
//  DNPlayingCardView.h
//  LCDouNiu
//
//  Created by Max on 16/9/20.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNPlayingCard.h"

@interface DNPlayingCardView : UIView

@property (strong, nonatomic) DNPlayingCard *playingCard;


@property (nonatomic) BOOL faceUp;
//牌铺满的时候 section 从 0 到 9 共 10个
@property (nonatomic, assign) int section;
//牌叠起来的时候，row从下往上，从0 到 2 最多3行。
@property (nonatomic, assign) int row;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end
