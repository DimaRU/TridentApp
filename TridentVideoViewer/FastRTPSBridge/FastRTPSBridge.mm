//
//  FastRTPSBridge.mm
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 04/09/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

#import "FastRTPSBridge.hpp"

@implementation FastRTPSBridge

- (id)init {
    if (!(self = [super init])) {
        return nil;
    }
    participant = new RovParticipant();
    participant->init();
    return self;
}


- (bool)registerReaderWithTopicName:(NSString *)topicName typeName:(NSString*)typeName {
    return participant->addReader([topicName cStringUsingEncoding:NSUTF8StringEncoding],
                                  [typeName cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (bool)removeReaderWithTopicName:(NSString *)topicName {
    return participant->removeReader([topicName cStringUsingEncoding:NSUTF8StringEncoding]);
}

@end
