//
//  LCNetworkManager.h
//  LCDouNiu
//
//  Created by Max on 2016/10/14.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LCNetworkManager : NSObject

+ (LCNetworkManager *)sharedInstance;


-(void)start;

@end
