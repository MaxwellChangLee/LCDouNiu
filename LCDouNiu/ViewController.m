//
//  ViewController.m
//  LCDouNiu
//
//  Created by Max on 16/8/29.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "DNMacro.h"

#define kCardWidth 43.0 //自己手牌宽度
#define kSelfNormalCardHeight 50.5 //自己手牌第一层的牌高度
#define kSelfFoldCardHeight 36.0 //自己手牌第二层第三层的牌高度

#define kGiveCardAnimationTime 0.3 //发牌动画时间
#define kMoveCardAnimationTime 0.3 //牌重新布局的动画时间

@interface ViewController ()

//中间的View
@property (strong, nonatomic) UIImageView *tableauView;
//自己手牌的区域
@property (strong, nonatomic) UIView *player1HandContainer;
//手中的牌
@property (strong, nonatomic) NSMutableArray *playingCardViews;
//选中的牌
@property (strong, nonatomic) NSMutableArray *selectedCardViews;
//打出去的牌
@property (strong, nonatomic) NSMutableArray *playedCardViews;

@property (nonatomic) CGFloat standardOverlap;

//拖动之前的位置
@property (nonatomic, assign) CGRect originFrame;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.player1Name = @"东哥";
    
    [self.view addSubview:self.tableauView];
    [self.view addSubview:self.player1HandContainer];
    [self layoutSubviewsOfSelf];
    
    self.game = [[DNGame alloc] init];
    self.game.player1.name = self.player1Name;
    self.selectedCardViews = [[NSMutableArray alloc] init];
    self.playedCardViews = [[NSMutableArray alloc] init];
    [self.game.player1 displayHand];
}

-(void)layoutSubviewsOfSelf
{
    CGFloat gap = (DN_SCREEN_WIDTH - 10 * kCardWidth) / 2.0;
    
    [self.tableauView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
        make.width.equalTo(@kCardWidth);
        make.height.equalTo(@kSelfNormalCardHeight);
    }];
    
    [self.player1HandContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kSelfNormalCardHeight*3));
        make.left.equalTo(self.view.mas_left).with.offset(gap);
        make.right.equalTo(self.view.mas_right).with.offset(-gap);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.player1HandContainer.backgroundColor = [UIColor clearColor];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self determineOverlap];
    [self createCardViews];
    [self dealCardViews];
}

- (void) createCardViews {
    self.playingCardViews = [[NSMutableArray alloc] init];
    
    for (DNPlayingCard *card in self.game.player1.hand) {
        DNPlayingCardView *cardView = [[DNPlayingCardView alloc] initWithFrame:self.tableauView.frame];
        cardView.playingCard = card;
        cardView.faceUp = NO;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cardPanGesture:)];
        [cardView addGestureRecognizer:panGesture];
        [self.view addSubview:cardView];
        [self.playingCardViews addObject:cardView];
    }
}

- (void) sortCards:(NSMutableArray *)cards {
    
}


-(void)cardTappedGesture:(UITapGestureRecognizer *)tapGestureRecognizer {
    DNPlayingCardView *tappedPlayingCardView = (DNPlayingCardView *)tapGestureRecognizer.view;
    NSLog(@"The tapped card is %@", tappedPlayingCardView.playingCard.contents);
    [self selectPlayingCard:tappedPlayingCardView];
}

-(void)cardPanGesture:(UIPanGestureRecognizer *)panGesture
{
    DNPlayingCardView *panPlayingCardView = (DNPlayingCardView *)panGesture.view;
    CGPoint rightPoint = [panGesture locationInView:self.view];
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.originFrame = panPlayingCardView.frame;
            [panPlayingCardView setCenter:rightPoint];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [panPlayingCardView setCenter:rightPoint];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self dealWithCardView:panPlayingCardView
                   withCenterPoint:rightPoint];
        }
            break;
        default:
            break;
    }
}

//pan手势结束之后，判断当前牌的位置，决定是
//1.回原来位置
//2.停留在当前section顶部
//3.打出去
-(void)dealWithCardView:(DNPlayingCardView *)cardView withCenterPoint:(CGPoint)centerPoint
{
    NSInteger sectionCount = [self getMaxSection] + 1;
    CGFloat leftSpace = [self getLeftSpaceWithSectionCount:sectionCount];
    CGFloat gap = centerPoint.x - leftSpace;
    //位置太靠左，直接返回原来位置
    if (gap < - kCardWidth / 2.0) {
        [self moveBackToOriginFrameWithView:cardView];
    }else if(gap > sectionCount * kCardWidth + kCardWidth / 2.0){
        [self playOutWithView:cardView];
    }else{
        NSInteger currentPoSection = fabs(gap / kCardWidth);
        NSLog(@"currentPoSection = %ld", (long)currentPoSection);
        NSInteger maxRow = [self getMaxRowOfSection:currentPoSection];
        //当前section已经叠加了3张牌，移动回原来位置
        if (maxRow >= 2) {
            [self moveBackToOriginFrameWithView:cardView];
        }else{ //否则叠在对应section的最上面
            if(currentPoSection > sectionCount){
                currentPoSection = sectionCount;
            }
            cardView.section = (int)currentPoSection;
            cardView.row = (int)maxRow + 1;
            [self reLayoutAllCardView];
        }
    }
}

- (void)selectPlayingCard:(DNPlayingCardView *)playingCardView {
    CGRect frame = playingCardView.frame;
    
    if (playingCardView.playingCard.isSelected) { // already selected
        playingCardView.playingCard.selected = NO;
        [self.game.player1 removeCardFromCombination:playingCardView.playingCard];
        [self.selectedCardViews removeObject:playingCardView];
        [UIView animateWithDuration:0.3 animations:^{
            playingCardView.frame = CGRectMake(frame.origin.x, frame.origin.y + 40, frame.size.width, frame.size.height);
        }];
    } else { // now it is selected
        playingCardView.playingCard.selected = YES;
        [self.game.player1 addCardToCombination:playingCardView.playingCard];
        [self.selectedCardViews addObject:playingCardView];
        [UIView animateWithDuration:0.3 animations:^{
            playingCardView.frame = CGRectMake(frame.origin.x, frame.origin.y - 40, frame.size.width, frame.size.height);
        }];
    }
}

- (void) determineOverlap {
    self.standardOverlap = 40;
}

#pragma mark - 起始发牌动画

- (void) dealCardViews {
    CGFloat posX = self.player1HandContainer.frame.origin.x;
    CGFloat posY = self.player1HandContainer.frame.origin.y;
    posY += self.player1HandContainer.frame.size.height;
    
    int count = 0;
    int row = 0;
    for (DNPlayingCardView *playingCardView in self.playingCardViews) {
        //大于10张牌，就放到第二行
        if (count >= 10) {
            [self.view sendSubviewToBack:playingCardView];
            row = 1;
        }
        //计算每张牌的起始坐标
        CGFloat cardViewX = 0;
        CGFloat cardViewY = 0;
        if (row == 0) {
            cardViewY = posY - kSelfNormalCardHeight;
        }else{
            cardViewY = posY - kSelfNormalCardHeight - row * kSelfFoldCardHeight;
        }
        if (count < 10) {
            cardViewX = posX + count * kCardWidth;
        }else if(count >= 10){
            cardViewX = posX + (count - 10) * kCardWidth;
        }
        //给每个view赋予section和row，以便知道其位置
        playingCardView.section = count % 10;
        playingCardView.row = row;
        
        //发牌动画
        CGPoint origin = CGPointMake(cardViewX, cardViewY);
        CGSize size = CGSizeMake(playingCardView.frame.size.width, playingCardView.frame.size.height);
        CGRect frame = { origin, size };
        
        NSTimeInterval delay = count * 0.1;
        [UIView animateWithDuration:0.3
                              delay:delay
                            options:UIViewAnimationOptionCurveEaseInOut animations:^{
            playingCardView.frame = frame;
        } completion:^(BOOL finished) {
            if (finished) {
                playingCardView.faceUp = YES;
            }
        }];
        count++;
    }
}

- (void)adjustCardsInHand {
    
    CGFloat containerWidth = self.player1HandContainer.frame.size.width;

    CGFloat gap = (containerWidth - [self.playingCardViews count] * kCardWidth) / 2.0;
    CGFloat startingX = 50 + gap;
    
    int count = 0;
    for (DNPlayingCardView *playingCardView in self.playingCardViews) {
        CGRect cardFrame = CGRectMake(startingX + (count * kCardWidth),
                                      playingCardView.frame.origin.y,
                                      playingCardView.frame.size.width,
                                      playingCardView.frame.size.height);
        [UIView animateWithDuration:0.3 animations:^{
            playingCardView.frame = cardFrame;
        }];
        count++;
    }
}

- (void)backButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:self completion:nil];
}


- (void)playButtonPressed:(UIButton *)sender {
    // Ask the player to play the combination
    // Maybe this should return a BOOL to determine whether these animations should occur
    [self.game.player1 playCombination];
    
    [self condensePlayedCards];
    
    [self layDownSelectedCardsOntoTableau];
    
    [self adjustCardsInHand];
}

- (void)layDownSelectedCardsOntoTableau {
    // Determine positions of frames for selected cards
    CGRect tableauFrame = self.tableauView.frame;
    CGFloat totalWidthOfSelection = tableauFrame.size.width + (self.standardOverlap * ([self.selectedCardViews count] - 1));
    CGFloat startingXPos = tableauFrame.origin.x + (tableauFrame.size.width / 2) - (totalWidthOfSelection / 2);
    
    int count = 0;
    for (DNPlayingCardView *playingCardView in self.selectedCardViews) {
        // Remove from the playingCardViews array and add to the playedCardViews array
        [self.playingCardViews removeObject:playingCardView];
        [self.playedCardViews addObject:playingCardView];
        
        CGRect frame = CGRectMake(startingXPos + self.standardOverlap * count,
                                  tableauFrame.origin.y,
                                  playingCardView.frame.size.width,
                                  playingCardView.frame.size.height);
        
        [UIView animateWithDuration:0.9 animations:^{
            [self.view bringSubviewToFront:playingCardView];
            playingCardView.frame = frame;
        }];
        count++;
    }
    [self.selectedCardViews removeAllObjects];
}

- (void)condensePlayedCards {
    // Condense previously played card views
    for (DNPlayingCardView *playingCardView in self.playedCardViews) {
        [UIView animateWithDuration:0.3 animations:^{
            playingCardView.frame = self.tableauView.frame;
        }];
    }
    [self.playedCardViews removeAllObjects];
}

//获取某一个section内的最大的row
-(NSInteger)getMaxRowOfSection:(NSInteger)section
{
    NSInteger maxRow = 0;
    for (DNPlayingCardView *playingCardView in self.playedCardViews) {
        if (playingCardView.section == section) {
            maxRow = maxRow > playingCardView.row ? maxRow : playingCardView.row;
        }
    }
    return maxRow;
}

//查看当前最大的section，以便找出当前有多少个section
-(NSInteger)getMaxSection
{
    NSInteger maxSection = 0;
    for (DNPlayingCardView *playingCardView in self.playedCardViews) {
        maxSection = maxSection > playingCardView.section ? maxSection : playingCardView.section;
    }
    return maxSection;
}

//根据当前的section个数，判断左侧的距离
-(CGFloat)getLeftSpaceWithSectionCount:(NSInteger)sectionCount
{
    return (DN_SCREEN_WIDTH - kCardWidth * sectionCount) / 2.0;
}

#pragma mark - 移动卡牌之后，重新布局

-(void)reLayoutAllCardView
{
    NSInteger sectionCount = [self getMaxSection] + 1;
    CGFloat leftSpace = [self getLeftSpaceWithSectionCount:sectionCount];
    CGFloat standY = self.player1HandContainer.frame.origin.y + self.player1HandContainer.frame.size.height;
    for (DNPlayingCardView *playingCardView in self.playedCardViews) {
        CGFloat posX = leftSpace + playingCardView.section * kCardWidth;
        CGFloat posY = 0;
        if (playingCardView.row == 0) {
            posY = standY - kSelfNormalCardHeight;
        }else{
            posY = standY - kSelfNormalCardHeight - playingCardView.row * kSelfFoldCardHeight;
            [self.view sendSubviewToBack:playingCardView];
        }
        [UIView animateWithDuration:kMoveCardAnimationTime
                         animations:^{
                             [playingCardView setFrame:CGRectMake(posX,
                                                                  posY,
                                                                  kCardWidth,
                                                                  kSelfNormalCardHeight)];
            
        }];
    }
    [self.view sendSubviewToBack:self.player1HandContainer];
}

#pragma mark - 拖动卡牌之后的操作

//拖完牌之后，牌回到原来位置
-(void)moveBackToOriginFrameWithView:(DNPlayingCardView *)cardView
{
    [UIView animateWithDuration:0.25
                     animations:^{
                         [cardView setFrame:_originFrame];
                     }];
}

//把牌打出去
-(void)playOutWithView:(DNPlayingCardView *)cardView
{
    
}

#pragma mark - getters

-(UIImageView *)tableauView
{
    if (!_tableauView) {
        _tableauView = [[UIImageView alloc] init];
        _tableauView.backgroundColor = [UIColor redColor];
    }
    return _tableauView;
}

-(UIView *)player1HandContainer
{
    if (!_player1HandContainer) {
        _player1HandContainer = [[UIView alloc] init];
        _player1HandContainer.backgroundColor = [UIColor yellowColor];
    }
    return _player1HandContainer;
}
@end
