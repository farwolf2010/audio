//
//  audio.h
//  audio
//
//  Created by 郑江荣 on 2019/2/25.
//  Copyright © 2019 郑江荣. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <FSAudioStream.h>
#import "KVAudioStreamer.h"
@interface audio : NSObject<KVAudioStreamerDelegate>
+(audio*)sharedManager;
@property(nonatomic,strong) KVAudioStreamer *audioStreamer;
@property(nonatomic) long total;
@end
