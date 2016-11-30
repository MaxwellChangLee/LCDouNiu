//
//  GCDAsyncSocketConfig.h
//  GCDAsyncSocketManager
//
//  Created by 宫城 on 16/1/17.
//  Copyright © 2016年 宫城. All rights reserved.
//

#ifndef GCDAsyncSocketConfig_h
#define GCDAsyncSocketConfig_h

/**
 *  socket config
 */
//online 1 local 0
#define DEV_STATE_ONLINE 1

static const int TIMEOUT = 30;

#define UPLOAD_ENV_ONLINE @"online"
#define UPLOAD_ENV_LOCAL @"local"

#if DEV_STATE_ONLINE
static NSString *HOST = @"120.24.97.212"; //socket
static const int PORT = 8543;
#else
static NSString *HOST = @"120.24.97.212"; //socket
static const int PORT = 8543;
#endif

/**
 *  socket protocol version
 */
#define PROTOCOL_VERSION 1

static const NSInteger kBeatLimit = 3;

#endif /* GCDAsyncSocketConfig_h */
