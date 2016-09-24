//
//  DNMenuView.m
//  LCDouNiu
//
//  Created by Max on 16/9/24.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "DNMenuView.h"

@implementation DNMenuView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.chiButton setImage:[UIImage imageNamed:@"chi_enable"] forState:UIControlStateSelected];
    [self.chiButton setImage:[UIImage imageNamed:@"chi_disable"] forState:UIControlStateNormal];
    [self.chiButton setImage:[UIImage imageNamed:@"chi_click"] forState:UIControlStateHighlighted];
    [self.chiButton setBackgroundImage:[UIImage imageNamed:@"left_click"] forState:UIControlStateHighlighted];
    
    [self.pengButton setImage:[UIImage imageNamed:@"peng_enable"] forState:UIControlStateSelected];
    [self.pengButton setImage:[UIImage imageNamed:@"peng_disable"] forState:UIControlStateNormal];
    [self.pengButton setImage:[UIImage imageNamed:@"peng_click"] forState:UIControlStateHighlighted];
    [self.pengButton setBackgroundImage:[UIImage imageNamed:@"middle_click"] forState:UIControlStateHighlighted];
    
    [self.huButton setImage:[UIImage imageNamed:@"hu_enable"] forState:UIControlStateSelected];
    [self.huButton setImage:[UIImage imageNamed:@"hu_disable"] forState:UIControlStateNormal];
    [self.huButton setImage:[UIImage imageNamed:@"hu_click"] forState:UIControlStateHighlighted];
    [self.huButton setBackgroundImage:[UIImage imageNamed:@"middle_click"] forState:UIControlStateHighlighted];
    
    [self.guoButton setImage:[UIImage imageNamed:@"guo_enable"] forState:UIControlStateSelected];
    [self.guoButton setImage:[UIImage imageNamed:@"guo_disable"] forState:UIControlStateNormal];
    [self.guoButton setImage:[UIImage imageNamed:@"guo_click"] forState:UIControlStateHighlighted];
    [self.guoButton setBackgroundImage:[UIImage imageNamed:@"right_click"] forState:UIControlStateHighlighted];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
