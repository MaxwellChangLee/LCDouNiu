//
//  DNNameView.m
//  LCDouNiu
//
//  Created by Max on 16/9/24.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "DNNameView.h"
#import "DNMacro.h"

@implementation DNNameView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.blackBgView.alpha = 0.3;
    self.blackBgView.layer.cornerRadius = 2;
    self.blackBgView.layer.masksToBounds = YES;
    self.nameLabel.textColor = RGBColorC(0xff896e);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
