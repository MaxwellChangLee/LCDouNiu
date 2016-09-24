//
//  DNShowActivePlayerView.h
//  LCDouNiu
//
//  Created by Max on 16/9/24.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNShowActivePlayerView : UIView

@property (weak, nonatomic) IBOutlet UIImageView *cardBoxImageView;

@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;
@property (weak, nonatomic) IBOutlet UIImageView *bottomArrow;
@property (weak, nonatomic) IBOutlet UIImageView *leftArrow;
@property (weak, nonatomic) IBOutlet UIImageView *topArrow;

@property (weak, nonatomic) IBOutlet UILabel *rightScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *topScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomScoreLabel;


@end
