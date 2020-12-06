//
//  XPlayer.m
//  YiZhiPai
//
//  Created by FANTEXIX on 2017/11/15.
//  Copyright © 2017年 fantexix Inc. All rights reserved.
//

#import "XPlayer.h"
#import <AVFoundation/AVFoundation.h>

@interface XPlayer ()


@property(nonatomic, strong)AVURLAsset              * urlAsset;
@property(nonatomic, strong)AVPlayerItem            * playerItem;
@property(nonatomic, strong)AVPlayer                * player;
@property(nonatomic, strong)AVPlayerLayer           * playerLayer;
@property(nonatomic, strong)AVAssetImageGenerator   * imageGenerator;
@property(nonatomic, strong)id                      observer;

@property(nonatomic, assign)BOOL isPlay;

@property(nonatomic, weak)UIView * superView;
@property(nonatomic, copy)NSString * urlPath;
@property(nonatomic, assign)BOOL localSource;
@property(nonatomic, assign)BOOL gravityType;
@property(nonatomic, assign)BOOL repeat;


@property(nonatomic, strong)NSValue * xPlayerBounds;



@property(nonatomic, strong)UIButton * backButton;
@property(nonatomic, strong)UITapGestureRecognizer * pTap;
@property(nonatomic, strong)UIImageView * pauseImageView;

@end

@implementation XPlayer

static id _instance;
+ (instancetype)shared {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}
- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}


- (instancetype)init {
    if (self = [super init]) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(audioRouteChangeListenerCallback:) name:AVAudioSessionRouteChangeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
        
        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error: nil];
        
        [self addSubviews];
        
    }
    
    return self;
}

- (void)addSubviews {
    
    self.backgroundColor = RGBColor(0, 0, 0);
    
    _backButton = [[UIButton alloc]init];
    _backButton.hidden = YES;
    [_backButton setImage:UIImageNamed(@"back") forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backButton];
    
    _pTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pTapMethod:)];
    _pTap.enabled = NO;
    [self addGestureRecognizer:_pTap];
    
    _pauseImageView = [[UIImageView alloc]init];
    _pauseImageView.image = UIImageNamed(@"video_icon_play_icon");
    _pauseImageView.hidden = YES;
    [self addSubview:_pauseImageView];

}

- (void)setBackType:(BOOL)backType {
    _backType = backType;
    if (backType) {
        _backButton.hidden = NO;
    }else {
        _backButton.hidden = YES;
    }
}

- (void)setPauseType:(BOOL)pauseType {
    _pauseType = pauseType;
    if (pauseType) {
        _pTap.enabled = YES;
    }else {
        _pTap.enabled = NO;
    }
}


- (void)layoutSubviews {
    _backButton.frame = CGRectMake(20, kStatusHeight+20, 30, 30);
    _pauseImageView.frame = CGRectMake((sWidth-80)/2., (sHeight-80)/2., 80, 80);
}

- (void)backButtonMethod:(UIButton *)button {
    [self removePlayer];
}

- (void)pTapMethod:(UITapGestureRecognizer *)tap {
    if (_pauseImageView.isHidden) {
        _pauseImageView.hidden = NO;
        [self stopPlay];
    }else {
        _pauseImageView.hidden = YES;
        [self startPlay];
    }
}

- (void)appWillResignActive {
    [_player pause];
}
- (void)appDidBecomeActive {
    if (self.isPlay) {
        [self startPlay];
    }
}

- (void)reachabilityChanged:(NSNotification*)notification {
    if (self.isPlay) {
        [self startPlay];
    }
}


- (void)audioRouteChangeListenerCallback:(NSNotification*)notification {
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            // 耳机插入
            break;
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable: {
            // 耳机拔掉
            [self stopPlay];
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            //NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}




- (void)setPlayerItem:(AVPlayerItem *)playerItem {
    
    if (_playerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [_playerItem removeObserver:self forKeyPath:@"status"];
        [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        [_playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
        [_playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];

    }
    
    _playerItem = playerItem;
    
    if (playerItem) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区空了，需要等待数据
        [playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区有足够数据可以播放了
        [playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];

    }
}

- (void)playURL:(NSString *)model videoGravity:(BOOL)isFill repeat:(BOOL)yesOrNo {
    
    [self resetPlayer];
    
    _urlPath = model;
    
    if ([_urlPath hasPrefix:@"http"]) {
        _localSource = YES;
    }else {
        _localSource = NO;
    }

    _gravityType = isFill;
    
    _repeat = yesOrNo;
    

    [self xPlayerLoadParam];
}

- (void)xPlayerLoadParam {
    
    if (_localSource) {
        self.urlAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:_urlPath]];
    }else {
        self.urlAsset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:_urlPath ofType:nil]]];
    }
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.bounds;
    self.playerLayer.videoGravity = _gravityType ? AVLayerVideoGravityResizeAspectFill : AVLayerVideoGravityResizeAspect;
    [self.layer insertSublayer:self.playerLayer atIndex:0];

    [self startPlay];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (self.playerLayer) self.playerLayer.frame = self.bounds;
    self.xPlayerBounds = [NSValue valueWithCGRect:CGRectMake(0, 0, frame.size.width, frame.size.height)];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    if (self.playerLayer) self.playerLayer.frame = self.bounds;
    self.xPlayerBounds = [NSValue valueWithCGRect:CGRectMake(0, 0, bounds.size.width, bounds.size.height)];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    _superView = newSuperview;
    if (!self.xPlayerBounds) self.frame = CGRectMake(0, 0, newSuperview.bounds.size.width, newSuperview.bounds.size.height);
}


- (void)startPlay {
    [_player play];
    self.isPlay = YES;
}
- (void)stopPlay {
    [_player pause];
    self.isPlay = NO;
}

- (void)resetPlayer {
    [self stopPlay];
    self.xPlayerBounds = nil;
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer  = nil;
    self.player = nil;
    self.playerItem = nil;
    self.urlAsset = nil;
    self.pauseImageView.hidden = YES;
}

- (void)removePlayer {
    self.delegate = nil;
    [self resetPlayer];
    [self removeFromSuperview];
}

- (void)removeFromSuperview {
    self.superView = nil;
    [super removeFromSuperview];
}

-(void)playbackFinished:(NSNotification *)notification{
    
    if (_repeat) {
        [_player seekToTime:CMTimeMake(0, 1)];
        [self startPlay];
    }else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(xPlayerEnded)]) {
            [self.delegate xPlayerEnded];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

//    AVPlayerItem * playerItem = object;
//
//    if ([keyPath isEqualToString:@"status"]) {
//        AVPlayerStatus status= [[change objectForKey:@"new"] intValue];
//        if(status==AVPlayerStatusReadyToPlay){
//            //NSLog(@"正在播放...，视频总长度:%.2f",CMTimeGetSeconds(playerItem.duration));
//        }
//    }else if([keyPath isEqualToString:@"loadedTimeRanges"]) {
//        NSArray *array=playerItem.loadedTimeRanges;
//        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];//本次缓冲时间范围
//        float startSeconds = CMTimeGetSeconds(timeRange.start);
//        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
//        NSTimeInterval totalBuffer = startSeconds + durationSeconds;//缓冲总长度
//        //NSLog(@"共缓冲：%.2f",totalBuffer);
//    }

}


- (void)dealloc {
    [self removePlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}

@end
