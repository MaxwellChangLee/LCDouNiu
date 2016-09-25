//
//  DNPlayingCardView.m
//  LCDouNiu
//
//  Created by Max on 16/9/20.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "DNPlayingCardView.h"
#import "Masonry.h"

@interface DNPlayingCardView()

@property (nonatomic, strong) UIImageView *cardKindImageView;
@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *grayBgView;

@end

@implementation DNPlayingCardView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = nil;
        self.opaque = NO;
        self.contentMode = UIViewContentModeRedraw;
        
        [self addSubview:self.bgImageView];
        [self addSubview:self.grayBgView];
        [self addSubview:self.cardKindImageView];

    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat cardWidth = self.frame.size.width * 3 / 5;
    CGFloat topGap = (self.frame.size.height - cardWidth) / 2;
    
    [self.bgImageView setFrame:self.bounds];
    [self.grayBgView setFrame:self.bounds];
    if (!self.bgImageView.image) {
        UIImage *originImage = [UIImage imageNamed:@"bg_zipai_noshadow"];
        CGFloat top = originImage.size.height / 2.0; // 顶端盖高度
        CGFloat bottom = originImage.size.height - top - 1 ; // 底端盖高度
        CGFloat left = originImage.size.width / 2.0; // 左端盖宽度
        CGFloat right = originImage.size.width - left - 1; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        UIImage *image = [originImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        self.bgImageView.image = image;
    }
    if (!self.grayBgView.image) {
        UIImage *originImage = [UIImage imageNamed:@"card_backGround"];
        CGFloat top = originImage.size.height / 2.0; // 顶端盖高度
        CGFloat bottom = originImage.size.height - top - 1 ; // 底端盖高度
        CGFloat left = originImage.size.width / 2.0; // 左端盖宽度
        CGFloat right = originImage.size.width - left - 1; // 右端盖宽度
        UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
        UIImage *image = [originImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
        self.grayBgView.image = image;
    }
    if (topGap > 5) {
        topGap = 5;
    }
    [self.cardKindImageView setFrame:CGRectMake(self.frame.size.width / 2 - cardWidth / 2, topGap, cardWidth, cardWidth)];
}

- (void)setPlayingCard:(DNPlayingCard *)playingCard {
    _playingCard = playingCard;
}

-(void)setFaceUp:(BOOL)faceUp {
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

-(UIImageView *)cardKindImageView
{
    if (!_cardKindImageView) {
        _cardKindImageView = [[UIImageView alloc] init];
        NSString *imageStr = @"card";
        NSArray *arr = @[@"little", @"large"];
        int i = arc4random() % 2;
        if (i < arr.count) {
            imageStr = [NSString stringWithFormat:@"%@_%@", imageStr, arr[i]];
        }
        int j = arc4random() % 10 + 1;
        imageStr = [NSString stringWithFormat:@"%@_%d", imageStr, j];
        _cardKindImageView.image = [UIImage imageNamed:imageStr];
    }
    return _cardKindImageView;
}

-(UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
    }
    return _bgImageView;
}

-(UIImageView *)grayBgView
{
    if (!_grayBgView) {
        _grayBgView = [[UIImageView alloc] init];
    }
    return _grayBgView;
}
@end
