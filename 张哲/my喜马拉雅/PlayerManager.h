//
//  PlayerManager.h
//  my喜马拉雅
//
//  Created by lanou3g on 15/11/20.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Block) ();
typedef void (^Block1)(NSInteger);

@interface PlayerManager : NSObject

@property (copy, nonatomic) Block myblock;
@property (copy, nonatomic) Block1 myblock1;
@property(nonatomic,assign)BOOL isPlaying;

+(instancetype)sharedPlayManager;

-(void)playMP4:(NSString *)urlStr;

-(void)pause;
-(void)play;

-(void)sliderChange:(NSTimeInterval)time;
@end
