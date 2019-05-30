//
//  audio.m
//  audio
//
//  Created by 郑江荣 on 2019/2/25.
//  Copyright © 2019 郑江荣. All rights reserved.
//

#import "audio.h"
#import "farwolf.h"

@implementation audio
//+(KVAudioStreamer*)sharedManager {
//    static dispatch_once_t onceToken;
//    static KVAudioStreamer *instance;
//    dispatch_once(&onceToken, ^{
//        instance = [[KVAudioStreamer alloc] init];
//        instance.delegate = self;
//      instance.cacheEnable = NO;    //开启缓存功能
//        //设置httpheader，音乐资源在阿里云OSS开启了防盗链，需要在这里设置referer，如果没有防盗链，那么不需要设置
//        instance.httpHeaders = @{@"Referer" : @"kevinrefer"};
////        instance.strictContentTypeChecking = NO;
////        instance.defaultContentType = @"audio/mpeg";
//    });
//    return instance;
//}

+(audio*)sharedManager {
    static dispatch_once_t onceToken;
    static audio *instance;
    dispatch_once(&onceToken, ^{
        instance = [[audio alloc] init];
          instance.audioStreamer = [[KVAudioStreamer alloc] init];
        instance.audioStreamer.delegate = instance;
        instance.audioStreamer.cacheEnable = NO;    //开启缓存功能
        //设置httpheader，音乐资源在阿里云OSS开启了防盗链，需要在这里设置referer，如果没有防盗链，那么不需要设置
        instance.audioStreamer.httpHeaders = @{@"Referer" : @"kevinrefer"};
        //        instance.strictContentTypeChecking = NO;
        //        instance.defaultContentType = @"audio/mpeg";
    });
    return instance;
}

/**
播放状态改变通知
@param streamer 流媒体
@param status 状态
*/
- (void)audioStreamer:(KVAudioStreamer*)streamer playStatusChange:(KVAudioStreamerPlayStatus)status{
    [self notifyDict:@"audioStateChange" value:@{@"state":@(status)}];
}

/**
 音频时长改变通知
 注意：有些音频文件本身的时长并不准确（音频文件本身的原因导致文件大小与比特率不正确，由此计算出的时长有偏差），如果开发者已经准确知道时长，建议直接使用，不需要使用流媒体内部计算出的时长
 
 @param streamer 流媒体
 @param duration 时长
 */
- (void)audioStreamer:(KVAudioStreamer *)streamer durationChange:(float)duration{
    [audio sharedManager].total=duration;
}

/**
 音频近似时长改变通知
 注意：当解析音频获取不到比特率（用于计算时长）时，流媒体内部将近似地计算音频的时长，内部有两种计算方法，其中之一会导致多次调用该回调，确保时间准确
 @param streamer 流媒体
 @param estimateDuration 时长
 */
- (void)audioStreamer:(KVAudioStreamer *)streamer estimateDurationChange:(float)estimateDuration{
     [audio sharedManager].total=estimateDuration;
}

/**
 播放进度通知
 
 @param streamer 流媒体
 @param location 当前播放位置，以秒为单位
 */
- (void)audioStreamer:(KVAudioStreamer *)streamer playAtTime:(long)location{
     [self notifyDict:@"audioPlaying" value:@{@"position":@(location)}];
}

/**
 文件缓存完成通知，流媒体内部不会处理网络路径与本地路径的映射关系，需要开发者自行处理，例如，第一次播放网络音频，在收到缓存完成后，将缓存文件的路径信息（文件夹，文件名都需要保存，方便下次做路径拼接）保存，下次如果继续播放该网络音频，先获取本地路径，通过本地路径进行音频播放
 说明：当网络文件缓存从头到尾完全加载后，继续seek操作将不会再做网络请求了，如果还未完全加载完毕就使用seek操作，那么将会重新启动网络请求，该文件再不会被判定为完全加载，因为保存起来的文件流数据已经不能当做一个完整文件看待。
 
 @param streamer 流媒体
 @param relativePath 缓存文件相对路径，缓存文件默认保存在系统Ducoment文件夹下
 @param cachepath 缓存文件绝对路径
 @return 返回YES，马上删除缓存文件，返回NO不删除，如果需要自行处理缓存文件的路径，需要自己move文件，然后返回YES
 */
- (BOOL)audioStreamer:(KVAudioStreamer *)streamer cacheCompleteWithRelativePath:(NSString*)relativePath cachepath:(NSString*)cachepath{
    
}

/**
 错误通知
 
 @param streamer 流媒体
 @param errorType 错误类型
 @param msg 错误消息
 @param error 如果是网络错误，将会抛出
 */
- (void)audioStreamer:(KVAudioStreamer *)streamer didFailWithErrorType:(KVAudioStreamerErrorType)errorType msg:(NSString*)msg error:(NSError*)error{
    
}

@end
