//
//  LocalAudio.h
//  AFNetworking
//
//  Created by 郑江荣 on 2019/8/4.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerItem.h>
#import <WeexSDK/WXEventModuleProtocol.h>
#import <WeexSDK/WXModuleProtocol.h>
NS_ASSUME_NONNULL_BEGIN

@interface LocalAudio : NSObject
 @property(nonatomic,weak) WXModuleKeepAliveCallback onPlaying;
@property (nonatomic, strong) id timeObserver;
@property (nonatomic, assign) BOOL hasObserver;
@property (nonatomic, strong) NSString* url;
+(AVPlayer*)sharedManager;
+(LocalAudio*)sharedLocalManager ;
-(void)setUrl:(NSString*)url callback:(WXModuleKeepAliveCallback) onPlaying;
-(void)play;
-(void)pause;
-(void)seek:(float)time;
-(NSString*)getUrl;
@end

NS_ASSUME_NONNULL_END
