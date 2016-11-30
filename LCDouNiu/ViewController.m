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
#import "DNMenuView.h"
#import "DNShowActivePlayerView.h"
#import "DNHeadView.h"
#import "DNNameView.h"
#import "DNPortraitLargePlayingCardView.h"
#import "DNLandScapeLargePlayingCardView.h"

#define kCoinCountKey   10     //金币总数

#define kLittleCardWidth 20
#define kLittleCardHeight 18

#define kCardWidth 36 //自己手牌宽度
#define kSelfNormalCardHeight 45 //自己手牌第一层的牌高度
#define kSelfFoldCardHeight 30 //自己手牌第二层第三层的牌高度

#define kGiveCardAnimationTime 0.3 //发牌动画时间
#define kMoveCardAnimationTime 0.3 //牌重新布局的动画时间
#define kPlayOutAnimationTime  0.3 //打牌出去的动画时间

#define kPlayOutViewBaseTag 1234

@interface ViewController ()<CAAnimationDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;              //背景图片
@property (nonatomic, strong) DNMenuView *menuView;                  //吃碰胡过
@property (nonatomic, strong) DNShowActivePlayerView *middleBoxView; //中间的View
@property (strong, nonatomic) UIView *player1HandContainer;          //自己手牌的区域

@property (nonatomic, strong) DNHeadView *bottomHeadView;
@property (nonatomic, strong) DNHeadView *leftHeadView;
@property (nonatomic, strong) DNHeadView *rightHeadView;
@property (nonatomic, strong) DNHeadView *topHeadView;

@property (nonatomic, strong) DNNameView *bottomNameView;
@property (nonatomic, strong) DNNameView *leftNameView;
@property (nonatomic, strong) DNNameView *rightNameView;
@property (nonatomic, strong) DNNameView *topNameView;

@property (nonatomic, strong) UILabel *bottomOwnLabel;
@property (nonatomic, strong) UILabel *leftOwnLabel;
@property (nonatomic, strong) UILabel *rightOwnLabel;
@property (nonatomic, strong) UILabel *topOwnLabel;

@property (nonatomic, strong) UIImageView *bottomAnimationView;
@property (nonatomic, strong) UIImageView *leftAnimationView;
@property (nonatomic, strong) UIImageView *rightAnimationView;
@property (nonatomic, strong) UIImageView *topAnimationView;

@property (nonatomic, strong) UILabel *roomInfoLabel;

@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) UIButton *messageButton;
@property (nonatomic, strong) UIButton *voiceButton;

@property (nonatomic, strong) DNPortraitLargePlayingCardView *portraitPlayOutCardView;
@property (nonatomic, strong) DNLandScapeLargePlayingCardView *landScapePlayoutCardView;

//手中的牌
@property (strong, nonatomic) NSMutableArray *playingCardViews;
//选中的牌
@property (strong, nonatomic) NSMutableArray *selectedCardViews;
//打出去的牌
@property (strong, nonatomic) NSMutableArray *playedCardViews;

@property (nonatomic, strong) NSMutableArray *huAnimationImageArr;

@property (nonatomic, strong) NSMutableArray  *coinTagsArr;  //存放生成的所有金币对应的tag值

//拖动之前的位置
@property (nonatomic, assign) CGRect originFrame;

@end

@implementation ViewController
{
    NSTimer *_testTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    return;
    self.player1Name = @"东哥";
    
    [self.view addSubview:self.player1HandContainer];
    [self.view addSubview:self.bgImageView];
    
    [self.view addSubview:self.roomInfoLabel];
    
    [self.view addSubview:self.bottomNameView];
    [self.view addSubview:self.leftNameView];
    [self.view addSubview:self.rightNameView];
    [self.view addSubview:self.topNameView];
    
    [self.view addSubview:self.bottomHeadView];
    [self.view addSubview:self.leftHeadView];
    [self.view addSubview:self.rightHeadView];
    [self.view addSubview:self.topHeadView];
    
    [self.view addSubview:self.bottomOwnLabel];
    [self.view addSubview:self.leftOwnLabel];
    [self.view addSubview:self.rightOwnLabel];
    [self.view addSubview:self.topOwnLabel];
    
    [self.view addSubview:self.bottomAnimationView];
    [self.view addSubview:self.leftAnimationView];
    [self.view addSubview:self.rightAnimationView];
    [self.view addSubview:self.topAnimationView];
    
    [self.view addSubview:self.portraitPlayOutCardView];
    [self.view addSubview:self.landScapePlayoutCardView];
    
    [self.view addSubview:self.settingButton];
    [self.view addSubview:self.messageButton];
    [self.view addSubview:self.voiceButton];
    
    [self.view addSubview:self.middleBoxView];
    [self.view addSubview:self.menuView];
    [self layoutSubviewsOfSelf];
    
    [self makeLeftFakeCards];
    [self makeRightFakeCards];
    [self makeBottomFakeCards];
    [self makeTopFakeCards];
    
    self.game = [[DNGame alloc] init];
    self.game.player1.name = self.player1Name;
    self.selectedCardViews = [[NSMutableArray alloc] init];
    self.playedCardViews = [[NSMutableArray alloc] init];
    self.coinTagsArr = [[NSMutableArray alloc] init];
    [self.game.player1 displayHand];
    
    [self initHuAnimatonPicArr];
}

-(void)layoutSubviewsOfSelf
{
    [self.bgImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.roomInfoLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(10);
        make.top.equalTo(self.view.mas_top).with.offset(5);
    }];
    
    [self.bottomHeadView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(28);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-40);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    
    [self.leftHeadView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(28);
        make.top.equalTo(self.view.mas_top).with.offset(92);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    
    [self.rightHeadView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-155);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    
    [self.topHeadView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(5);
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    
    [self.bottomNameView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomHeadView.mas_centerX);
        make.top.equalTo(self.bottomHeadView.mas_bottom).with.offset(0);
        make.width.equalTo(@85);
        make.height.equalTo(@36);
    }];
    
    [self.leftNameView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftHeadView.mas_centerY);
        make.left.equalTo(self.leftHeadView.mas_right).with.offset(0);
        make.width.equalTo(@85);
        make.height.equalTo(@36);
    }];
    
    [self.rightNameView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rightHeadView.mas_centerY);
        make.right.equalTo(self.rightHeadView.mas_left).with.offset(0);
        make.width.equalTo(@85);
        make.height.equalTo(@36);
    }];
    
    [self.topNameView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topHeadView.mas_centerY);
        make.left.equalTo(self.topHeadView.mas_right).with.offset(0);
        make.width.equalTo(@85);
        make.height.equalTo(@36);
    }];
    
    [self.bottomOwnLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomHeadView.mas_centerX);
        make.bottom.equalTo(self.bottomHeadView.mas_top).with.offset(-3);
    }];
    
    [self.leftOwnLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.leftHeadView.mas_centerX);
        make.bottom.equalTo(self.leftHeadView.mas_top).with.offset(-3);
    }];
    
    [self.rightOwnLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.rightHeadView.mas_centerX);
        make.bottom.equalTo(self.rightHeadView.mas_top).with.offset(-3);
    }];
    
    [self.topOwnLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topHeadView.mas_centerY);
        make.right.equalTo(self.topHeadView.mas_left).with.offset(-3);
    }];
    
    [self.leftAnimationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftNameView.mas_right);
        make.centerY.equalTo(self.leftNameView.mas_centerY);
    }];
    
    [self.bottomAnimationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.middleBoxView.mas_centerX);
        make.top.equalTo(self.middleBoxView.mas_bottom).with.offset(-20);
    }];
    
    [self.rightAnimationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rightNameView.mas_centerY);
        make.right.equalTo(self.rightNameView.mas_left);
    }];
    
    [self.topAnimationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topNameView.mas_centerX);
        make.top.equalTo(self.topHeadView.mas_bottom);
    }];
    
    CGFloat gap = (DN_SCREEN_WIDTH - 10 * kCardWidth) / 2.0;
    
    [self.player1HandContainer mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kSelfNormalCardHeight*3));
        make.left.equalTo(self.view.mas_left).with.offset(gap);
        make.right.equalTo(self.view.mas_right).with.offset(-gap);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.menuView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-98);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-122.5);
        make.height.equalTo(@36);
        make.width.equalTo(@172.5);
    }];
    
    [self.middleBoxView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY).with.offset(-40);
        make.width.equalTo(@165);
        make.height.equalTo(@165);
    }];
    
    [self.settingButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.top.equalTo(self.view.mas_top).with.offset(12.5);
        make.width.equalTo(@39);
        make.height.equalTo(@41);
    }];
    
    [self.voiceButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-12.5);
        make.width.equalTo(@39);
        make.height.equalTo(@41);
    }];
    
    [self.messageButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(-10);
        make.bottom.equalTo(self.voiceButton.mas_top).with.offset(-12);
        make.width.equalTo(@39);
        make.height.equalTo(@41);
    }];
    
    [self.portraitPlayOutCardView setCenter:CGPointMake(190, 120)];
    [self.landScapePlayoutCardView setCenter:CGPointMake(DN_SCREEN_WIDTH + 48, 240)];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.player1HandContainer.backgroundColor = [UIColor clearColor];
//    [self makeMenuBgImage];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [self createCardViews];
//    [self dealCardViews];
//    [self performSelector:@selector(startTest_bottom) withObject:nil afterDelay:2];
}

- (void) createCardViews {
    self.playingCardViews = [[NSMutableArray alloc] init];
    
    for (DNPlayingCard *card in self.game.player1.hand) {
        DNPlayingCardView *cardView = [[DNPlayingCardView alloc] initWithFrame:CGRectMake(0, 0, kCardWidth, kSelfNormalCardHeight)];
        [cardView setCenter:self.middleBoxView.center];
        cardView.playingCard = card;
        cardView.faceUp = NO;
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cardPanGesture:)];
        [cardView addGestureRecognizer:panGesture];
        [self.bgImageView addSubview:cardView];
        [self.playingCardViews addObject:cardView];
    }
}

-(void)makeMenuBgImage
{
    UIImage *originImage = [UIImage imageNamed:@"rectangle"];
    CGFloat top = 0; // 顶端盖高度
    CGFloat bottom = 0 ; // 底端盖高度
    CGFloat left = originImage.size.width / 2.0; // 左端盖宽度
    CGFloat right = originImage.size.width - left - 1; // 右端盖宽度
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    UIImage *image = [originImage resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    self.menuView.bgImageView.image = image;
}

-(void)initHuAnimatonPicArr
{
    if (!self.huAnimationImageArr) {
        self.huAnimationImageArr = [[NSMutableArray alloc] initWithCapacity:0];
    }
    if (self.huAnimationImageArr.count != 0) {
        [self.huAnimationImageArr removeAllObjects];
    }
    for (int i = 0; i < 20; i ++) {
        NSString *picName = [NSString stringWithFormat:@"hu_%d",i + 1];
        UIImage *image = [UIImage imageNamed:picName];
        [self.huAnimationImageArr addObject:image];
    }
}

#pragma mark - 创建吃的牌碰的牌打出去的牌

-(void)makeLeftFakeCards
{
    CGFloat poX = 90;
    CGFloat poY = 170;
    for (int i = 0; i < 3; i ++) {
        CGFloat cardX = poX;
        CGFloat cardY = poY + i * kLittleCardHeight;
        
        DNPlayingCardView *playingCard = [[DNPlayingCardView alloc] initWithFrame:CGRectMake(cardX,
                                                                                             cardY,
                                                                                             kLittleCardWidth,
                                                                                             kLittleCardHeight)];
        [self.view addSubview:playingCard];
    }
}

-(void)makeRightFakeCards
{
    CGFloat poX = DN_SCREEN_WIDTH - 108;
    CGFloat poY = 80;
    for (int i = 0; i < 9; i ++) {
        CGFloat cardX = poX + i / 3 * kLittleCardWidth;
        CGFloat cardY = poY + (i % 3) * kLittleCardHeight;
        
        DNPlayingCardView *playingCard = [[DNPlayingCardView alloc] initWithFrame:CGRectMake(cardX,
                                                                                             cardY,
                                                                                             kLittleCardWidth,
                                                                                             kLittleCardHeight)];
        [self.view addSubview:playingCard];
    }
}

-(void)makeTopFakeCards
{
    CGFloat poX = DN_SCREEN_WIDTH - 207.5;
    CGFloat poY = 10;
    for (int i = 0; i < 9; i ++) {
        CGFloat cardX = poX + i / 3 * kLittleCardWidth;
        CGFloat cardY = poY + (i % 3) * kLittleCardHeight;
        
        DNPlayingCardView *playingCard = [[DNPlayingCardView alloc] initWithFrame:CGRectMake(cardX,
                                                                                             cardY,
                                                                                             kLittleCardWidth,
                                                                                             kLittleCardHeight)];
        [self.view addSubview:playingCard];
    }
}

-(void)makeBottomFakeCards
{
    CGFloat poX = DN_SCREEN_WIDTH - 120;
    CGFloat poY = DN_SCREEN_HEIGHT - 100;
    for (int i = 0; i < 9; i ++) {
        CGFloat cardX = poX + i / 3 * kLittleCardWidth;
        CGFloat cardY = poY + (i % 3) * kLittleCardHeight;
        
        DNPlayingCardView *playingCard = [[DNPlayingCardView alloc] initWithFrame:CGRectMake(cardX,
                                                                                             cardY,
                                                                                             kLittleCardWidth,
                                                                                             kLittleCardHeight)];
        [self.view addSubview:playingCard];
    }
}

#pragma mark - 移动卡牌逻辑

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
    if (gap < - kCardWidth / 2.0 - kCardWidth) {
        [self moveBackToOriginFrameWithView:cardView];
    }else if (gap < - kCardWidth / 2.0){ //移动到牌左边的情况
        if (sectionCount >= 10) {
            [self moveBackToOriginFrameWithView:cardView];
            return;
        }
        [self resetRowAndSectionWithMovedView:cardView];
        cardView.section = 0;
        cardView.row = 0;
        for (DNPlayingCardView *card in self.playingCardViews) {
            if (card != cardView) {
                card.section ++;
            }
        }
        [self reLayoutAllCardView];
    }else if(gap > self.player1HandContainer.frame.size.width + kCardWidth / 2.0){
        [self playOutWithView:cardView]; //将牌打出
        [self resetRowAndSectionWithMovedView:cardView];
        [self reLayoutAllCardView];
        [self.playingCardViews removeObject:cardView];
        [cardView removeFromSuperview];
    }else{
        NSInteger currentPoSection = fabs(gap / kCardWidth);
        if (currentPoSection == cardView.section || currentPoSection >= 10) {
            [self moveBackToOriginFrameWithView:cardView];
            return;
        }
        NSLog(@"currentPoSection = %ld", (long)currentPoSection);
        NSInteger maxRow = [self getMaxRowOfSection:currentPoSection];
        NSInteger moveSectionMaxRow = [self getMaxRowOfSection:cardView.section];
        //当前section已经叠加了3张牌，移动回原来位置
        if (maxRow >= 2) {
            [self moveBackToOriginFrameWithView:cardView];
        }else{ //否则叠在对应section的最上面
            if(currentPoSection > sectionCount){
                currentPoSection = sectionCount;
            }
            //移走牌后，那个section没有牌了
            BOOL needAdjustSection = NO;
            //移走的不是最顶上的牌
            BOOL needAdjustRow = NO;
            NSInteger originSection = cardView.section;
            NSInteger originRow = cardView.row;
            if (cardView.row == 0 && moveSectionMaxRow == 0)
            {
                needAdjustSection = YES;
            }else if (cardView.row < moveSectionMaxRow){ //说明移动的不是最顶上的牌
                needAdjustRow = YES;
            }
            cardView.section = (int)currentPoSection;
            cardView.row = (int)maxRow + 1;
            [self.bgImageView sendSubviewToBack:cardView];
            if(needAdjustSection){
                for (DNPlayingCardView *card in self.playingCardViews) {
                    if (card.section > originSection) {
                        card.section --;
                    }
                }
            }
            if (needAdjustRow) {
                for (DNPlayingCardView *card in self.playingCardViews) {
                    if (card.section == originSection) {
                        if (card.row > originRow) {
                            card.row --;
                        }
                    }
                }
            }
            [self reLayoutAllCardView];
        }
    }
}

-(void)resetRowAndSectionWithMovedView:(DNPlayingCardView *)cardView
{
    NSInteger moveSectionMaxRow = [self getMaxRowOfSection:cardView.section];
    
    //移走牌后，那个section没有牌了
    BOOL needAdjustSection = NO;
    //移走的不是最顶上的牌
    BOOL needAdjustRow = NO;
    NSInteger originSection = cardView.section;
    NSInteger originRow = cardView.row;
    if (cardView.row == 0 && moveSectionMaxRow == 0)
    {
        needAdjustSection = YES;
    }else if (cardView.row < moveSectionMaxRow){ //说明移动的不是最顶上的牌
        needAdjustRow = YES;
    }
    [self.bgImageView sendSubviewToBack:cardView];
    if(needAdjustSection){
        for (DNPlayingCardView *card in self.playingCardViews) {
            if (card.section > originSection) {
                card.section --;
            }
        }
    }
    if (needAdjustRow) {
        for (DNPlayingCardView *card in self.playingCardViews) {
            if (card.section == originSection) {
                if (card.row > originRow) {
                    card.row --;
                }
            }
        }
    }
}

#pragma mark - event

-(void)huButtonClick:(UIButton *)button
{
    [self huAnimation];
}

-(void)chiButtonClick:(UIButton *)button
{
    [self chiAnimation];
}

-(void)guoButtonClick:(UIButton *)button
{
    [self kanAnimation];
}

-(void)pengButtonClick:(UIButton *)button
{
    [self pengAnimation];
}

-(void)clearBottomImage:(UIImageView *)imageView
{
    self.bottomAnimationView.image = nil;
}

-(void)clearTopImage:(UIImageView *)imageView
{
    self.topAnimationView.image = nil;
}

-(void)clearLeftImage:(UIImageView *)imageView
{
    self.leftAnimationView.image = nil;
}

-(void)clearRightImage:(UIImageView *)imageView
{
    self.rightAnimationView.image = nil;
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
            [self.bgImageView sendSubviewToBack:playingCardView];
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

//获取某一个section内的最大的row
-(NSInteger)getMaxRowOfSection:(NSInteger)section
{
    NSInteger maxRow = -1;
    for (DNPlayingCardView *playingCardView in self.playingCardViews) {
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
    for (DNPlayingCardView *playingCardView in self.playingCardViews) {
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
    for (DNPlayingCardView *playingCardView in self.playingCardViews) {
        CGFloat posX = leftSpace + playingCardView.section * kCardWidth;
        CGFloat posY = 0;
        if (playingCardView.row == 0) {
            posY = standY - kSelfNormalCardHeight;
        }else{
            posY = standY - kSelfNormalCardHeight - playingCardView.row * kSelfFoldCardHeight;
        }
        [UIView animateWithDuration:kMoveCardAnimationTime
                         animations:^{
                             [playingCardView setFrame:CGRectMake(posX,
                                                                  posY,
                                                                  kCardWidth,
                                                                  kSelfNormalCardHeight)];
            
        }];
    }
//    [self.view sendSubviewToBack:self.player1HandContainer];
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
    DNLandScapeLargePlayingCardView *playOutView =  [[DNLandScapeLargePlayingCardView alloc] initWithFrame:CGRectMake(0, 0, 108, 42)];
    BOOL removeTagView = NO;
    if ([self.view viewWithTag:kPlayOutViewBaseTag]) {
        removeTagView = YES;
        playOutView.tag = kPlayOutViewBaseTag + 1;
    }else{
        removeTagView = NO;
        playOutView.tag = kPlayOutViewBaseTag;
    }
    [playOutView setCenter:CGPointMake(DN_SCREEN_WIDTH + 48, 240)];
    [self.view addSubview:playOutView];
    [UIView animateWithDuration:kPlayOutAnimationTime
                     animations:^{
        [playOutView setCenter:CGPointMake(self.view.center.x, self.landScapePlayoutCardView.center.y)];
    } completion:^(BOOL finished) {
        if (removeTagView) {
            [[self.view viewWithTag:kPlayOutViewBaseTag] removeFromSuperview];
        }else{
            [[self.view viewWithTag:kPlayOutViewBaseTag + 1] removeFromSuperview];
        }
    }];
}

#pragma mark - 胡牌动画

-(void)huAnimation
{
    self.leftAnimationView.animationImages = self.huAnimationImageArr;
    self.leftAnimationView.animationRepeatCount = 1;
    self.leftAnimationView.animationDuration = 1;
    [self.leftAnimationView startAnimating];
    
    [self getCoinAction];
}

#pragma mark - 吃 扫 碰 等动画

-(void)chiAnimation
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(clearBottomImage:)
                                               object:self.bottomAnimationView];
    
    self.bottomAnimationView.image = [UIImage imageNamed:@"icon_action_toast_chi"];
    
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.8),@(2.0),@(1.1)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    
    [self.bottomAnimationView.layer addAnimation:k forKey:@"SHOW"];
    
    [self performSelector:@selector(clearBottomImage:)
               withObject:self.bottomAnimationView
               afterDelay:1.5];
}

-(void)pengAnimation
{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(clearRightImage:)
                                               object:self.rightAnimationView];
    
    self.rightAnimationView.image = [UIImage imageNamed:@"icon_action_toast_kan"];
    
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.8),@(2.0),@(1.1)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    
    [self.rightAnimationView.layer addAnimation:k forKey:@"SHOW"];
    
    [self performSelector:@selector(clearRightImage:)
               withObject:self.rightAnimationView
               afterDelay:1.5];
}

-(void)kanAnimation
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(clearTopImage:)
                                               object:self.bottomAnimationView];
    
    self.topAnimationView.image = [UIImage imageNamed:@"icon_action_toast_sao"];
    
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.8),@(2.0),@(1.1)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    
    [self.topAnimationView.layer addAnimation:k forKey:@"SHOW"];
    
    [self performSelector:@selector(clearTopImage:)
               withObject:self.topAnimationView
               afterDelay:1.5];
}

#pragma mark - 金币移动动画

static int coinCount = 0;

- (void)getCoinAction
{
    //初始化金币生成的数量
    coinCount = 0;
    for (int i = 0; i < kCoinCountKey; i++) {
        
        //延迟调用函数
        [self performSelector:@selector(initCoinViewWithInt:) withObject:[NSNumber numberWithInt:i] afterDelay:i * 0.05];
    }
}

- (void)initCoinViewWithInt:(NSNumber *)i
{
    UIImageView *coin = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_glod"]];
    
    //初始化金币的最终位置
    coin.center = self.leftHeadView.center;
    coin.tag = [i intValue] + 1;
    //每生产一个金币,就把该金币对应的tag加入到数组中,用于判断当金币结束动画时和福袋交换层次关系,并从视图上移除
    [_coinTagsArr addObject:[NSNumber numberWithLong:coin.tag]];
    
    [self.view addSubview:coin];
    
    [self setAnimationWithLayer:coin];
}

- (void)setAnimationWithLayer:(UIView *)coin
{
    CGFloat duration = 1.6f;
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    //绘制从底部到福袋口之间的抛物线
    CGFloat positionX   = coin.layer.position.x;    //终点x
    CGFloat positionY   = coin.layer.position.y;    //终点y
    CGMutablePathRef path = CGPathCreateMutable();
    int fromX       = self.rightHeadView.center.x;//arc4random() % 320;     //起始位置:x轴上随机生成一个位置
    int height      = self.rightHeadView.center.y;//[UIScreen mainScreen].bounds.size.height + coin.frame.size.height; //y轴以屏幕高度为准
    int fromY       = arc4random() % (int)positionY; //起始位置:生成位于福袋上方的随机一个y坐标
    
    CGFloat cpx = positionX + (fromX - positionX)/2;    //x控制点
    CGFloat cpy = fromY / 2 - positionY;                //y控制点,确保抛向的最大高度在屏幕内,并且在福袋上方(负数)
    
    //动画的起始位置
    CGPathMoveToPoint(path, NULL, fromX, height);
    CGPathAddQuadCurveToPoint(path, NULL, cpx, cpy, positionX, positionY);
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setPath:path];
    CFRelease(path);
    path = nil;
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    //图像由大到小的变化动画
    CGFloat from3DScale = 1 + arc4random() % 10 *0.1;
    CGFloat to3DScale = from3DScale * 0.5;
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(from3DScale, from3DScale, from3DScale)], [NSValue valueWithCATransform3D:CATransform3DMakeScale(to3DScale, to3DScale, to3DScale)]];
    scaleAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    
    ////////////////////////////////////////////////////////////////////////////////////////////
    //动画组合
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = duration;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.animations = @[scaleAnimation, animation];
    [coin.layer addAnimation:group forKey:@"position and transform"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        //动画完成后把金币和数组对应位置上的tag移除
        UIView *coinView = (UIView *)[self.view viewWithTag:[[_coinTagsArr firstObject] intValue]];
        
        [coinView removeFromSuperview];
        [_coinTagsArr removeObjectAtIndex:0];
    }
}

#pragma mark - 测试

-(void)startTest_bottom
{
    [self.middleBoxView hideAllScore];
    [self.middleBoxView pointTo:DNShowActivePlayerViewDirectionBottom];
    self.menuView.chiButton.selected = YES;
    [self chiButtonClick:self.menuView.chiButton];
    [self performSelector:@selector(startTest_right) withObject:nil afterDelay:1.5];
}

-(void)startTest_right
{
    self.menuView.chiButton.selected = NO;
    [self.middleBoxView pointTo:DNShowActivePlayerViewDirectionRight];
    [self pengButtonClick:self.menuView.pengButton];
    [self performSelector:@selector(startTest_top) withObject:nil afterDelay:1.5];
}

-(void)startTest_top
{
    [self.middleBoxView pointTo:DNShowActivePlayerViewDirectionTop];
    [self guoButtonClick:self.menuView.guoButton];
    [self performSelector:@selector(startTest_left) withObject:nil afterDelay:1.5];
}

-(void)startTest_left
{
    [self.middleBoxView pointTo:DNShowActivePlayerViewDirectionLeft];
    [self.middleBoxView showScoreResult:@{@(0):@"-5胡",
                                          @(1):@"+15胡",
                                          @(2):@"-5胡",
                                          @(3):@"-5胡"}];
    [self huButtonClick:self.menuView.huButton];
    [self performSelector:@selector(startTest_bottom) withObject:nil afterDelay:1.5];
}


#pragma mark - getters

-(UIView *)player1HandContainer
{
    if (!_player1HandContainer) {
        _player1HandContainer = [[UIView alloc] init];
        _player1HandContainer.backgroundColor = [UIColor yellowColor];
    }
    return _player1HandContainer;
}

-(UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"game_bg"];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

-(DNMenuView *)menuView
{
    if (!_menuView) {
        _menuView = [[[NSBundle mainBundle] loadNibNamed:@"DNMenuView" owner:self options:nil] firstObject];
        [_menuView.huButton addTarget:self
                               action:@selector(huButtonClick:)
                     forControlEvents:UIControlEventTouchUpInside];
        [_menuView.chiButton addTarget:self
                                action:@selector(chiButtonClick:)
                      forControlEvents:UIControlEventTouchUpInside];
        [_menuView.pengButton addTarget:self
                                 action:@selector(guoButtonClick:)
                       forControlEvents:UIControlEventTouchUpInside];
        [_menuView.guoButton addTarget:self
                                 action:@selector(pengButtonClick:)
                       forControlEvents:UIControlEventTouchUpInside];
        _menuView.backgroundColor = [UIColor clearColor];
    }
    return _menuView;
}

-(DNShowActivePlayerView *)middleBoxView
{
    if (!_middleBoxView) {
        _middleBoxView = [[[NSBundle mainBundle] loadNibNamed:@"DNShowActivePlayerView" owner:self options:nil] firstObject];
        _middleBoxView.backgroundColor = [UIColor clearColor];
    }
    return _middleBoxView;
}

-(DNHeadView *)bottomHeadView
{
    if (!_bottomHeadView) {
        _bottomHeadView = [[DNHeadView alloc] init];
    }
    return _bottomHeadView;
}

-(DNHeadView *)leftHeadView
{
    if (!_leftHeadView) {
        _leftHeadView = [[DNHeadView alloc] init];
    }
    return _leftHeadView;
}

-(DNHeadView *)rightHeadView
{
    if (!_rightHeadView) {
        _rightHeadView = [[DNHeadView alloc] init];
    }
    return _rightHeadView;
}

-(DNHeadView *)topHeadView
{
    if (!_topHeadView) {
        _topHeadView = [[DNHeadView alloc] init];
    }
    return _topHeadView;
}

-(DNNameView *)bottomNameView
{
    if (!_bottomNameView) {
        _bottomNameView = [[[NSBundle mainBundle] loadNibNamed:@"DNNameView" owner:self options:nil] firstObject];
    }
    return _bottomNameView;
}

-(DNNameView *)leftNameView
{
    if (!_leftNameView) {
        _leftNameView = [[[NSBundle mainBundle] loadNibNamed:@"DNNameView" owner:self options:nil] firstObject];
    }
    return _leftNameView;
}

-(DNNameView *)rightNameView
{
    if (!_rightNameView) {
        _rightNameView = [[[NSBundle mainBundle] loadNibNamed:@"DNNameView" owner:self options:nil] firstObject];
    }
    return _rightNameView;
}

-(DNNameView *)topNameView
{
    if (!_topNameView) {
        _topNameView = [[[NSBundle mainBundle] loadNibNamed:@"DNNameView" owner:self options:nil] firstObject];
    }
    return _topNameView;
}

-(UILabel *)bottomOwnLabel
{
    if (!_bottomOwnLabel) {
        _bottomOwnLabel = [[UILabel alloc] init];
        _bottomOwnLabel.font = [UIFont systemFontOfSize:15];
        _bottomOwnLabel.textColor = [UIColor whiteColor];
        _bottomOwnLabel.text = @"5胡";
    }
    return _bottomOwnLabel;
}

-(UILabel *)leftOwnLabel
{
    if (!_leftOwnLabel) {
        _leftOwnLabel = [[UILabel alloc] init];
        _leftOwnLabel.font = [UIFont systemFontOfSize:15];
        _leftOwnLabel.textColor = [UIColor whiteColor];
        _leftOwnLabel.text = @"5胡";
    }
    return _leftOwnLabel;
}

-(UILabel *)rightOwnLabel
{
    if (!_rightOwnLabel) {
        _rightOwnLabel = [[UILabel alloc] init];
        _rightOwnLabel.font = [UIFont systemFontOfSize:15];
        _rightOwnLabel.textColor = [UIColor whiteColor];
        _rightOwnLabel.text = @"5胡";
    }
    return _rightOwnLabel;
}

-(UILabel *)topOwnLabel
{
    if (!_topOwnLabel) {
        _topOwnLabel = [[UILabel alloc] init];
        _topOwnLabel.font = [UIFont systemFontOfSize:15];
        _topOwnLabel.textColor = [UIColor whiteColor];
        _topOwnLabel.text = @"5胡";
    }
    return _topOwnLabel;
}

-(UILabel *)roomInfoLabel
{
    if (!_roomInfoLabel) {
        _roomInfoLabel = [[UILabel alloc] init];
        _roomInfoLabel.textColor = RGBColorC(0xfecc45);
        _roomInfoLabel.font = [UIFont systemFontOfSize:12];
        _roomInfoLabel.numberOfLines = 0;
        _roomInfoLabel.text = @"房间号：5423\n中庄 X 2\n强制胡牌\n局：2/5";
    }
    return _roomInfoLabel;
}

-(UIImageView *)bottomAnimationView
{
    if (!_bottomAnimationView) {
        _bottomAnimationView = [[UIImageView alloc] init];
    }
    return _bottomAnimationView;
}

-(UIImageView *)leftAnimationView
{
    if (!_leftAnimationView) {
        _leftAnimationView = [[UIImageView alloc] init];
    }
    return _leftAnimationView;
}

-(UIImageView *)rightAnimationView
{
    if (!_rightAnimationView) {
        _rightAnimationView = [[UIImageView alloc] init];
    }
    return _rightAnimationView;
}

-(UIImageView *)topAnimationView
{
    if (!_topAnimationView) {
        _topAnimationView = [[UIImageView alloc] init];
    }
    return _topAnimationView;
}

-(UIButton *)settingButton
{
    if (!_settingButton) {
        _settingButton = [[UIButton alloc] init];
        [_settingButton setImage:[UIImage imageNamed:@"setting"]
                        forState:UIControlStateNormal];
    }
    return _settingButton;
}

-(UIButton *)messageButton
{
    if (!_messageButton) {
        _messageButton = [[UIButton alloc] init];
        [_messageButton setImage:[UIImage imageNamed:@"message"]
                        forState:UIControlStateNormal];
    }
    return _messageButton;
}

-(UIButton *)voiceButton
{
    if (!_voiceButton) {
        _voiceButton = [[UIButton alloc] init];
        [_voiceButton setImage:[UIImage imageNamed:@"voice"]
                      forState:UIControlStateNormal];
    }
    return _voiceButton;
}

-(DNPortraitLargePlayingCardView *)portraitPlayOutCardView
{
    if (!_portraitPlayOutCardView) {
        _portraitPlayOutCardView = [[DNPortraitLargePlayingCardView alloc] initWithFrame:CGRectMake(0, 0, 42, 96)];
    }
    return _portraitPlayOutCardView;
}

-(DNLandScapeLargePlayingCardView *)landScapePlayoutCardView
{
    if (!_landScapePlayoutCardView) {
        _landScapePlayoutCardView = [[DNLandScapeLargePlayingCardView alloc] initWithFrame:CGRectMake(0, 0, 108, 42)];
    }
    return _landScapePlayoutCardView;
}
@end
