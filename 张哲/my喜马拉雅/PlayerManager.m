//
//  PlayerManager.m
//  my喜马拉雅
//
//  Created by lanou3g on 15/11/20.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import "PlayerManager.h"
#import <AVFoundation/AVFoundation.h>

//播放器是创建后就会存在的
static PlayerManager *playerManager = nil;

@interface PlayerManager ()

@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)NSTimer *timer;

@end



@implementation PlayerManager


+(instancetype)sharedPlayManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (playerManager == nil) {
            playerManager = [PlayerManager new];
        }
    });
    return playerManager;
}

-(instancetype)init{
    if (self = [super init]) {
        // 添加通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playItemEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}

-(void)playItemEnd{
    _myblock();
}

-(void)playMP4:(NSString *)urlStr{
    // 若是
    if (self.player.currentItem) {
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    AVPlayerItem *playItem = [[AVPlayerItem alloc]initWithURL:[NSURL URLWithString:urlStr]];
    _player = [[AVPlayer alloc]initWithPlayerItem:playItem];
    [playItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil];
    
   
}
#pragma mark---观察者方法
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    AVPlayerItemStatus status = [change[@"new"] integerValue];
    switch (status) {
        case AVPlayerItemStatusFailed:
            NSLog(@"加载失败");
            break;
        case AVPlayerItemStatusUnknown:
            NSLog(@"资源不对");
            break;
        case AVPlayerItemStatusReadyToPlay:
            NSLog(@"加载完成");
            // 暂停，就是销毁timer。然后再播放，创建timer
            [self pause];
            [self play];
            break;
        default:
            break;
    }
}

-(void)pause{
    [_player pause];
    _isPlaying = NO;
    [self.timer invalidate];
    self.timer = nil;
}
-(void)play{
    [_player play];
    _isPlaying = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playerPlayWithSeconds) userInfo:nil repeats:YES];
    
}
-(void)playerPlayWithSeconds{
//     NSLog(@"%lld",self.player.currentTime.value / self.player.currentTime.timescale);
    NSInteger time = self.player.currentTime.value / self.player.currentTime.timescale;
    _myblock1(time);
}

-(void)sliderChange:(NSTimeInterval)time{
    // 先暂停
    [self pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
        if (finished) {
            // 拖拽后再播放
            [self play];
        }
    }];

}
@end
