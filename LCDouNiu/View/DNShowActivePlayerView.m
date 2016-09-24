//
//  DNShowActivePlayerView.m
//  LCDouNiu
//
//  Created by Max on 16/9/24.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "DNShowActivePlayerView.h"
#import "DNMacro.h"

@implementation DNShowActivePlayerView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.leftScoreLabel.textColor = RGBColorC(0xfa381c);
    self.topScoreLabel.textColor = RGBColorC(0xfa381c);
    self.rightScoreLabel.textColor = RGBColorC(0xf5881e);
    self.bottomScoreLabel.textColor = RGBColorC(0xf5881e);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
