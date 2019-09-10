//
//  FastRTPSBridge.h
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 04/09/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol PayloadDecoderInterface;
@interface FastRTPSBridge : NSObject
- (id)init;
- (bool)registerReaderWithTopicName:(NSString *)topicName typeName:(NSString*)typeName keyed:(bool) keyed payloadDecoder: (NSObject<PayloadDecoderInterface>*) payloadDecoder;
- (bool)removeReaderWithTopicName:(NSString *)topicName;
- (void)stopRTPS;
- (void)resignAll;
@end

NS_ASSUME_NONNULL_END
