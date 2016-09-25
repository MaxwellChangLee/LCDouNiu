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

-(void)pointTo:(DNShowActivePlayerViewDirection)direction
{
    
    self.rightArrow.hidden = YES;
    self.bottomArrow.hidden = YES;
    self.leftArrow.hidden = YES;
    self.topArrow.hidden = YES;
    switch (direction) {
        case DNShowActivePlayerViewDirectionBottom:
        {
            self.bottomArrow.hidden = NO;
        }
            break;
        case DNShowActivePlayerViewDirectionLeft:
        {
            self.leftArrow.hidden = NO;
        }
            break;
        case DNShowActivePlayerViewDirectionRight:
        {
            self.rightArrow.hidden = NO;
        }
            break;
        case DNShowActivePlayerViewDirectionTop:
        {
            self.topArrow.hidden = NO;
        }
            break;
            
        default:
            break;
    }
}

-(void)showScoreResult:(NSDictionary *)resultDic
{
    if (!resultDic) {
        return;
    }
    for (id key in [resultDic allKeys]) {
        NSInteger direction = [key integerValue];
        NSString *score = [resultDic objectForKey:key];
        UIColor *textColor = nil;
        if (score.intValue <= 0) {
            textColor = RGBColorC(0xfa381c);
        }else{
            textColor = RGBColorC(0xf5881e);
        }
        switch (direction) {
            case DNShowActivePlayerViewDirectionBottom:
            {
                self.bottomScoreLabel.hidden = NO;
                self.bottomScoreLabel.text = score;
                self.bottomScoreLabel.textColor = textColor;
            }
                break;
            case DNShowActivePlayerViewDirectionLeft:
            {
                self.leftScoreLabel.hidden = NO;
                self.leftScoreLabel.text = score;
                self.leftScoreLabel.textColor = textColor;
            }
                break;
            case DNShowActivePlayerViewDirectionRight:
            {
                self.rightScoreLabel.hidden = NO;
                self.rightScoreLabel.text = score;
                self.rightScoreLabel.textColor = textColor;
            }
                break;
            case DNShowActivePlayerViewDirectionTop:
            {
                self.topScoreLabel.hidden = NO;
                self.topScoreLabel.text = score;
                self.topScoreLabel.textColor = textColor;
            }
                break;
                
            default:
                break;
        }
    }
}

-(void)hideAllScore
{
    self.leftScoreLabel.hidden = YES;
    self.topScoreLabel.hidden = YES;
    self.rightScoreLabel.hidden = YES;
    self.bottomScoreLabel.hidden = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
