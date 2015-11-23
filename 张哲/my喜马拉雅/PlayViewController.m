//
//  PlayViewController.m
//  my喜马拉雅
//
//  Created by lanou3g on 15/11/18.
//  Copyright © 2015年 张哲. All rights reserved.
//

#import "PlayViewController.h"
#import "UIImageView+WebCache.h"
#import "PlayerManager.h"
#import "AlbumldList.h"

static PlayViewController *playVC = nil;


@interface PlayViewController ()

@property(nonatomic,assign)NSInteger currentNum;
@property(nonatomic,strong)AlbumldList *albumld;

@property (strong, nonatomic) IBOutlet UISlider *slider;

@end


@implementation PlayViewController

// 单例
+(instancetype)sharedPlayVC{
    if (playVC == nil) {
        playVC = [PlayViewController new];
    }
    return playVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    [self startPlay];
    [self updateUI];
    
    
    _currentNum = _choiceNum;
    
}
// 从数组中选择歌曲
// 播放歌曲
-(void)startPlay{
    _albumld = _albumldList[_currentNum];
    PlayerManager *play = [PlayerManager sharedPlayManager];
    play.myblock=^{
        [self next];
    };
    
    play.myblock1=^(NSInteger time){
        //每秒要做的事
        _slider.value = time;
    };
    [play playMP4:_albumld.playPathAacv164];

}

-(void)viewWillAppear:(BOOL)animated{
    if (_choiceNum != _currentNum) {
        _currentNum = _choiceNum;
        // 重选歌曲
       [self startPlay];
       [self updateUI];
    }
}
// 更新UI
-(void)updateUI{
    _slider.maximumValue = _albumld.duration;
//    _slider.value = 0;
    [_upperImgView sd_setImageWithURL:[NSURL URLWithString:_albumld.coverMiddle]];
    _desLabel.text = _albumld.nickname;
    [_headImgView sd_setImageWithURL:[NSURL URLWithString:_albumld.smallLogo]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
// 上一首
-(void)previous{
    _currentNum--;
    if (_currentNum == -1) {
        _currentNum = _albumldList.count;
    }
    [self startPlay];
}
- (IBAction)previousAction:(id)sender {
    [self previous];
}
// 下一首
-(void)next{
    _currentNum++;
    if (_currentNum == _albumldList.count + 1) {
        _currentNum =0;
    }
    [self startPlay];
}
- (IBAction)nextAction:(id)sender {
    [self next];
}

// 暂停或者播放
- (IBAction)playOrPauseAction:(id)sender {
    PlayerManager *player = [PlayerManager sharedPlayManager];
    if (player.isPlaying == YES) {
        [player pause];
    }else{
        [player play];
    }
}
// 播放条
- (IBAction)playSliderAction:(UISlider *)sender {
    PlayerManager *manager = [PlayerManager sharedPlayManager];
    [manager sliderChange:sender.value];
}

// 播放完一首歌

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
