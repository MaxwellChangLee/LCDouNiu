//
//  LCNetworkManager.m
//  LCDouNiu
//
//  Created by Max on 2016/10/14.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "LCNetworkManager.h"
#import "GCDAsyncSocketManager.h"
#import "GCDAsyncSocket.h"
#import "Room.pb.h"

@interface LCNetworkManager()<GCDAsyncSocketDelegate>

@end

@implementation LCNetworkManager

+ (LCNetworkManager *)sharedInstance {
    static LCNetworkManager *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)start
{
    [[GCDAsyncSocketManager sharedInstance] connectSocketWithDelegate:self];
}


#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"success");
    
    PenHuProtocolBuilder *messageBuilder = [PenHuProtocolBuilder new];
    [messageBuilder setUri:PenHuProtocolMsgTypeUirCreateRoomReq];
    
    PBCS_CreateRoomReqBuilder *reqBuild = [PBCS_CreateRoomReqBuilder new];
    [reqBuild setSeqId: 1];
    [reqBuild setUid: 2];
    [reqBuild setRoomType: 1];
    [reqBuild setRounds: 10];
    [reqBuild setPlayMask: 0x01];
    [reqBuild setPasswd: @"{111:111}"];
    [reqBuild setExtInfo: @"{111:111}"];

    [messageBuilder setCreateRoomReqBuilder:reqBuild];
    
    PenHuProtocol *pro = [messageBuilder buildPartial];
    
    NSData *data = [pro data];
    
    [[GCDAsyncSocketManager sharedInstance] socketSendData:data];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [sock readDataToLength:4 withTimeout:30 tag:0];
    NSLog(@"recevive data = %@", data);
}

@end
