//
//  WXAudioModule.m
//  AFNetworking
//
//  Created by 郑江荣 on 2019/3/4.
//

#import "WXAudioModule.h"
#import <WeexPluginLoader/WeexPluginLoader.h>
#import "audio.h"
//#import <FSAudioStream.h>
#import "Weex.h"
#import "farwolf_weex.h"
WX_PlUGIN_EXPORT_MODULE(audio, WXAudioModule)
@implementation WXAudioModule
@synthesize weexInstance;
WX_EXPORT_METHOD(@selector(setUrl:))
WX_EXPORT_METHOD(@selector(play))
WX_EXPORT_METHOD(@selector(pause))
WX_EXPORT_METHOD(@selector(stop))
WX_EXPORT_METHOD(@selector(seek:))
WX_EXPORT_METHOD_SYNC(@selector(isPlay))
WX_EXPORT_METHOD(@selector(volume:))
WX_EXPORT_METHOD(@selector(loop:))
WX_EXPORT_METHOD(@selector(setOnPrepared:))
WX_EXPORT_METHOD(@selector(setOnPlaying:))
WX_EXPORT_METHOD(@selector(setOnCompletion:))
WX_EXPORT_METHOD(@selector(setOnError:))
WX_EXPORT_METHOD(@selector(setOnStartPlay:))





-(void)play{
   
    [[audio sharedManager].audioStreamer play];
    if(!self.hasRegist){
         self.hasRegist=true;
         [self regist:@"audioPlaying" method:@selector(onPlaying:)];
         [self regist:@"audioStateChange" method:@selector(onAudioStateChange:)];
    }
//    [[audio sharedManager] playFromURL:self.playurl];
}

-(void)onPlaying:(NSNotification*)no{
    long position= [@"" add:no.userInfo[@"position"]].longLongValue;
    unsigned current=position*1000;
    unsigned total=[audio sharedManager].total*1000;
    float percent=(float)current/total;
    if(self.onPlaying)
        _onPlaying(@{@"current":@(current),@"total": @(total),@"percent":@(percent)},true);

}
-(void)onAudioStateChange:(NSNotification*)no{
    
}

-(void)setUrl:(NSMutableDictionary*)param{
    if(self.playurl!=nil){
         [self stop];
    }
    NSString* url=param[@"url"];
    BOOL autoplay= [@"" add: param[@"autoplay"]].boolValue;
//    url=[Weex getFinalUrl:url weexInstance:weexInstance].absoluteString;
//    self.playurl=[NSURL URLWithString:url];
//
//    [[audio sharedManager] setUrl:self.playurl];
//    if(autoplay){
//        [[audio sharedManager] play];
//    }
    url=[Weex getFinalUrl:url weexInstance:weexInstance].absoluteString;
    NSString *temp=url;
    if(![url startWith:@"http"]){
        temp= [NSURL fileURLWithPath:url].absoluteString;
    }
     [[audio sharedManager].audioStreamer resetAudioURL:temp];
    if(autoplay){
        [self play];
    }

}

-(void)addListener{
    
    
//    __weak typeof (self) weakself=self;
//    [audio sharedManager].onStateChange = ^(FSAudioStreamState state) {
//        if(state==kFsAudioStreamPlaying){
//            //           [audio sharedManager].currentTimePlayed
//            [weakself releaseTimer];
//            _timer = [NSTimer scheduledTimerWithTimeInterval:0.5
//                                                      target:weakself
//                                                    selector:@selector(updateProcess)
//                                                    userInfo:nil
//                                                     repeats:YES];
//            [_timer fire];
//            if(weakself.onStartPlay){
//                weakself.onStartPlay(@{}, true);
//            }
//
//        } if(state==kFsAudioStreamPlaybackCompleted){
//            if(self.loop){
//                [self play];
//            }
//        }
//
//    };
    
  
}

-(void)updateProcess{
    
//    if([audio sharedManager].status==KVAudioStreamerPlayStatusPlaying){
//
//        unsigned current=([audio sharedManager].currentTimePlayed.minute*60+[audio sharedManager].currentTimePlayed.second)*1000;
//        unsigned total=([audio sharedManager].duration.minute*60+[audio sharedManager].duration.second)*1000;
//        float percent=(float)current/total;
//        if(self.onPlaying)
//            _onPlaying(@{@"current":@(current),@"total": @(total),@"percent":@(percent)},true);
//
//    }
   
    
}

-(void)pause{
    [[audio sharedManager].audioStreamer pause];
}

-(void)stop{
    self.playurl=nil;
//     [self releaseTimer];
     [[audio sharedManager].audioStreamer stop];
}

-(void)seek:(float)time{
    

//    dispatch_async(dispatch_get_main_queue(), ^{
//        //    FSStreamPosition position;
//        FSStreamPosition pos = {0};
//
//        unsigned total=([audio sharedManager].duration.minute*60+[audio sharedManager].duration.second)*1000;
//        pos.position = time/total;
//        //     position.position = time;
//        // 跳转进度
//        [[audio sharedManager] seekToPosition:pos];
//        [[audio sharedManager] play];
//    });
    [[audio sharedManager].audioStreamer seekToTime:time/1000];
}

-(BOOL)isPlay{
//    return [audio sharedManager].isPlaying;
    return [audio sharedManager].audioStreamer.status ==KVAudioStreamerPlayStatusPlaying;
}

-(void)volume:(float)time{
    [audio sharedManager].audioStreamer.volume=time;
}

-(void)loop:(BOOL)loop{
    self.loop=loop;
}
-(void)setOnStartPlay:(WXModuleKeepAliveCallback)callback{
    self.onStartPlay=callback;
}
-(void)setOnPrepared:(WXModuleKeepAliveCallback)callback{
    self.onPrepared=callback;
}
-(void)setOnPlaying:(WXModuleKeepAliveCallback)callback{
    _onPlaying=callback;
      [self addListener];
}
-(void)setOnCompletion:(WXModuleKeepAliveCallback)callback{
    
    __weak typeof (self) weakself=self;
//    [audio sharedManager].onCompletion = ^{
//        weakself.playurl=nil;
//        [weakself releaseTimer];
//        callback(@{},true);
//    };
}

-(void)setOnError:(WXModuleKeepAliveCallback)callback{
//    [audio sharedManager].onFailure = ^(FSAudioStreamError error, NSString *errorDescription) {
//        callback(@{},true);
//    };
}

-(void)releaseTimer{
    if (_timer) {
        if ([_timer isValid]) {
            [_timer invalidate];
            _timer = nil;
        }
    }
}

- (void)dealloc {
    [self releaseTimer];
}


@end
