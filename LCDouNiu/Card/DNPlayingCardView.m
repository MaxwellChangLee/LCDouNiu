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
        
        /*
        [self addSubview:self.cardKindImageView];
        [self.cardKindImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(5);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(self.mas_width).multipliedBy(56 / 67.0);
        }];
         */
    }
    return self;
}

-(void)drawRect:(CGRect)rect {
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius: [self cornerRadius]];
    
    [roundedRect addClip];
    
    [[UIColor lightGrayColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    roundedRect.lineWidth = 3;
    [roundedRect stroke];
    
    if (self.faceUp) {
        //[self drawRankAndSuit];
        [[UIImage imageNamed:@"card_large_10"] drawInRect:CGRectMake(0,
                                                                     5,
                                                                     self.bounds.size.width,
                                                                     self.bounds.size.width * 56 / 67.0)];
    } else {
        [[UIImage imageNamed:@"cardback"] drawInRect:self.bounds];
    }
}


#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }


- (void)drawRankAndSuit {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    font = [font fontWithSize:font.pointSize * [self cornerScaleFactor]];
    
    
    UIColor *color;
    if (self.playingCard.isSuitRed) {
        color = [UIColor redColor];
    } else {
        color = [UIColor blackColor];
    }
    
    NSString *rankAndSuitString = [NSString stringWithFormat:@"%@\n%@", [self.playingCard rankAsString], self.playingCard.suit];
    NSDictionary * attributes = @{
                                  NSFontAttributeName : font,
                                  NSParagraphStyleAttributeName : paragraphStyle,
                                  NSForegroundColorAttributeName : color};
    NSAttributedString *attributedRankAndSuitString = [[NSAttributedString alloc] initWithString:rankAndSuitString attributes:attributes];
    
    CGRect textBounds;
    textBounds.origin = CGPointMake([self cornerOffset], [self cornerOffset]);
    textBounds.size = [attributedRankAndSuitString size];
    [attributedRankAndSuitString drawInRect:textBounds];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
    
    [attributedRankAndSuitString drawInRect:textBounds];
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
        _cardKindImageView.image = [UIImage imageNamed:@"card_large_10"];
    }
    return _cardKindImageView;
}
@end
