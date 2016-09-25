//
//  DNLandScapeLargePlayingCardView.m
//  LCDouNiu
//
//  Created by Max on 16/9/25.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "DNLandScapeLargePlayingCardView.h"

@implementation DNLandScapeLargePlayingCardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView
{
    [self addSubview:self.bgImageView];
    [self addSubview:self.normalCardImageView];
    [self addSubview:self.handStandImageView];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat cardWidth = self.frame.size.height * 3 / 5;
    CGFloat topGap = (self.frame.size.width - cardWidth) / 2;
    
    [self.bgImageView setFrame:self.bounds];
    if (!self.bgImageView.image) {
        UIImage *originImage = [UIImage imageNamed:@"card_yellow_bg"];
        CGFloat top = originImage.size.height / 2.0; // 顶端盖高度
        CGFloat bottom = originImage.size.height - top - 1 ; // 底端盖高度
        CGFloat left = originImage.size.width / 2.0; // 左端盖宽度
        CGFloat right = originImage.size.width - left - 1; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        UIImage *image = [originImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        self.bgImageView.image = image;
    }
    if (topGap > 10) {
        topGap = 10;
    }
    [self.normalCardImageView setFrame:CGRectMake(topGap, self.frame.size.height / 2 - cardWidth / 2, cardWidth, cardWidth)];
    [self.handStandImageView setFrame:CGRectMake(self.frame.size.width - topGap - cardWidth, self.frame.size.height / 2 - cardWidth / 2, cardWidth, cardWidth)];
}


#pragma mark - getters

-(UIImageView *)normalCardImageView
{
    if (!_normalCardImageView) {
        _normalCardImageView = [[UIImageView alloc] init];
        _normalCardImageView.image = [UIImage imageNamed:@"card_large_10"];
        _normalCardImageView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }
    return _normalCardImageView;
}

-(UIImageView *)handStandImageView
{
    if (!_handStandImageView) {
        _handStandImageView = [[UIImageView alloc] init];
        _handStandImageView.transform = CGAffineTransformMakeRotation(M_PI_2);
        _handStandImageView.image = [UIImage imageNamed:@"card_large_10"];
    }
    return _handStandImageView;
}

-(UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
    }
    return _bgImageView;
}

@end
