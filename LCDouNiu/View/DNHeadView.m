//
//  DNHeadView.m
//  LCDouNiu
//
//  Created by Max on 16/9/24.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "DNHeadView.h"
#import "Masonry.h"

@implementation DNHeadView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
    [self addSubview:self.headImageView];
    [self addSubview:self.bgImageView];
    [self addSubview:self.bankerMarkImageView];
    [self makeContaits];
}

-(void)makeContaits
{
    [self.bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.headImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@(60 - 2 * 5));
        make.height.equalTo(@(60 - 2 * 5));
    }];
    
    [self.bankerMarkImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).with.offset(45);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@29);
        make.height.equalTo(@33);
    }];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - getters

-(UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"bg_face_circle"];
    }
    return _bgImageView;
}

-(UIImageView *)headImageView
{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        _headImageView.image = [UIImage imageNamed:@"test_header"];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
        _headImageView.layer.cornerRadius = 25;
        _headImageView.layer.masksToBounds = YES;
    }
    return _headImageView;
}

-(UIImageView *)bankerMarkImageView
{
    if (!_bankerMarkImageView) {
        _bankerMarkImageView = [[UIImageView alloc] init];
        _bankerMarkImageView.image = [UIImage imageNamed:@"banker"];
    }
    return _bankerMarkImageView;
}
@end
