//
//  FastRTPSBridge.h
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 04/09/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "TridentVideoViewer-Swift.h"

NS_ASSUME_NONNULL_BEGIN

@interface FastRTPSBridge : NSObject
- (id)init;
- (bool)registerReaderWithTopicName:(NSString *)topicName typeName:(NSString*)typeName keyed:(bool) keyed payloadDecoder: (PayloadDecoder*) payloadDecoder;
- (bool)removeReaderWithTopicName:(NSString *)topicName;
@end

NS_ASSUME_NONNULL_END
