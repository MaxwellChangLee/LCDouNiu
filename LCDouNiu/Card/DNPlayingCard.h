//
//  DNPlayingCard.h
//  LCDouNiu
//
//  Created by Max on 16/8/29.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNPlayingCard : NSObject

@property (strong, nonatomic) NSString *contents;  //牌值加花色，作为唯一标识
@property (nonatomic) NSUInteger rank;     //牌值
@property (strong, nonatomic) NSString *suit;  //花色
@property (nonatomic, getter=isSelected) BOOL selected;  //是否选中

/**
 *  牌面值
 *
 *  @return 牌面值
 */
- (NSString *) rankAsString;

/**
 *  判断是否是黑色的牌，黑桃或者梅花
 *
 *  @return 是否是黑色
 */
- (BOOL)isSuitBlack;

/**
 *  判断是否是红色的牌，红桃或者方块
 *
 *  @return 是否是红色
 */
- (BOOL)isSuitRed;

/**
 *  与其他卡作大小比较，先作花色排序，再作大小排序
 *
 *  @param otherCard 其他卡片
 *
 *  @return 比较结果
 */
- (NSComparisonResult)compare:(DNPlayingCard *)otherCard;

/**
 *  花色数组
 *
 *  @return 返回“梅花，红桃，黑桃，方块”
 */
+ (NSArray *)validSuits;

/**
 *  最大牌值
 *
 *  @return
 */
+ (NSUInteger)maxRank;

@end
