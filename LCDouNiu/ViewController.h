//
//  ViewController.h
//  LCDouNiu
//
//  Created by Max on 16/8/29.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNGame.h"
#import "DNPlayingCardView.h"


@interface ViewController : UIViewController

@property (strong, nonatomic) DNGame *game;
@property (strong, nonatomic) NSString *player1Name;


@end

