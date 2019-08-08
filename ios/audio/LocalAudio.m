//
//  LocalAudio.m
//  AFNetworking
//
//  Created by 郑江荣 on 2019/8/4.
//

#import "LocalAudio.h"

@implementation LocalAudio
+(AVPlayer*)sharedManager {
    static dispatch_once_t onceToken;
    static AVPlayer *avPlayerInstance;
    dispatch_once(&onceToken, ^{
        avPlayerInstance = [[AVPlayer alloc] init];
    });
    return avPlayerInstance;
}

+(LocalAudio*)sharedLocalManager {
    static dispatch_once_t LocalonceToken;
    static LocalAudio *LocalAudioInstance;
    dispatch_once(&LocalonceToken, ^{
        LocalAudioInstance = [[LocalAudio alloc] init];
    });
    return LocalAudioInstance;
}


-(NSString*)getUrl{
    if(self.url==nil)return @"";
    return   self.url;
}

-(void)setUrl:(NSString*)url callback:(WXModuleKeepAliveCallback) onPlaying{
//    [LocalAudio sharedManager].
      [self removeObserver];
    self.url=url;
    NSURL * ul  = [NSURL fileURLWithPath:url];
    AVPlayerItem * songItem = [[AVPlayerItem alloc]initWithURL:ul];
    [[LocalAudio sharedManager] replaceCurrentItemWithPlayerItem:songItem];
    [LocalAudio sharedManager].volume=1.0;
    self.onPlaying=onPlaying;
    [self addObserver];
//    [[LocalAudio sharedManager] addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
//        float current = CMTimeGetSeconds(time);
//        float total = CMTimeGetSeconds(songItem.duration);
//        float percent=(float)current/total;
//        if (current) {
//            if(onPlaying)
//                onPlaying(@{@"current":@(current),@"total": @(total),@"percent":@(percent)},true);
//          }
//    }];
}

-(void)setPlaying:(WXModuleKeepAliveCallback) onPlaying{
      self.onPlaying=onPlaying;
}

-(void)play{
    [[LocalAudio sharedManager] play];
}

-(void)seek:(float)time{

    [[LocalAudio sharedManager] seekToTime:CMTimeMake(time, 1000) toleranceBefore:CMTimeMake(1, 1000)
         toleranceAfter:CMTimeMake(1, 1000)];
 
}

-(void)pause{
    [[LocalAudio sharedManager] pause];
}

- (void)addObserver
{
    if (!self.hasObserver) {
        self.hasObserver = YES;
        
        // KVO
        // KVO来观察status属性的变化
        [[LocalAudio sharedManager].currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        // KVO监测加载情况
        [[LocalAudio sharedManager].currentItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
        
        //
        __weak typeof (self) weakSelf = self;
        self.timeObserver = [[LocalAudio sharedManager] addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            float current = CMTimeGetSeconds(time);
            float total = CMTimeGetSeconds([LocalAudio sharedManager].currentItem.duration);
            float percent=(float)current/total;
            if (current) {
                if(weakSelf.onPlaying)
                    weakSelf.onPlaying(@{@"current":@(current),@"total": @(total),@"percent":@(percent)},true);
            }
        }];
        
        // 通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playFinish) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
}


- (void)removeObserver
{
    if (self.hasObserver) {
        self.hasObserver = NO;
        
        [[LocalAudio sharedManager].currentItem removeObserver:self forKeyPath:@"status"];
        [[LocalAudio sharedManager].currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
        
        [[LocalAudio sharedManager] removeTimeObserver:self.timeObserver];
        self.timeObserver = nil;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        // 取出status的新值
        AVPlayerItemStatus status = [change[NSKeyValueChangeNewKey] intValue];
        switch (status) {
            case AVPlayerItemStatusFailed: {
                NSLog(@"item 有误");
            } break;
            case AVPlayerItemStatusReadyToPlay: {
                NSLog(@"准好播放了");
                [[LocalAudio sharedManager] play];
            } break;
            case AVPlayerItemStatusUnknown: {
                NSLog(@"视频资源出现未知错误");
            } break;
            default: break;
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
//        NSArray *array = [LocalAudio sharedManager].currentItem.loadedTimeRanges;
//        // 本次缓冲的时间范围
//        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
//        // 缓冲总长度
//        NSTimeInterval totalBuffer = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
//        // 音乐的总时间
//        NSTimeInterval duration = CMTimeGetSeconds([LocalAudio sharedManager].currentItem.duration);
//        // 计算缓冲百分比例
//        NSTimeInterval scale = totalBuffer / duration;
//        //
//        NSLog(@"总时长：%f, 已缓冲：%f, 总进度：%f", duration, totalBuffer, scale);
    }
}
- (void)playFinish
{
    NSLog(@"播放完成");
}

@end
