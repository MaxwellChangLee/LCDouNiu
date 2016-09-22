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

/*
 基于iOS的手机游戏社区平台应用终端设计
 2013年，微信推出5.0版本，里面包含的一个“打飞机”的简单游戏，引爆了整个手机游戏市场。这个“打飞机”游戏无论是从画面上还是关卡设计上都无法与其它飞行射击类游戏相比，但是其却似病毒式的扩散。腾讯2013年第四季度财报披露，
 手机QQ及微信游戏中心内的游戏，在第四季度贡献收入超过人民币6.00亿元。随后几年，国内的游戏公司纷纷投入大量资源进行移动端游戏开发，但是在激烈的竞争中，腾讯系的手机游戏常年霸榜，究其原因，就在于qq和微信渠道强大的游戏分发能力。
 */
@end

