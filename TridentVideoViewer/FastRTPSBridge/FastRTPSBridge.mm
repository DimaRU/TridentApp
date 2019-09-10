//
//  FastRTPSBridge.mm
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 04/09/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

#import "FastRTPSBridge.h"
#import "RovParticipant.h"
#include <fastrtps/log/Log.h>
#include "CustomLogConsumer.h"

using namespace eprosima;
using namespace fastrtps;
using namespace rtps;
using namespace std;

@interface FastRTPSBridge()
@property RovParticipant* participant;
@end

@implementation FastRTPSBridge

- (id)init {
    if (!(self = [super init])) {
        return nil;
    }
    
    Log::ClearConsumers();
    Log::RegisterConsumer(std::unique_ptr<LogConsumer>(new CustomLogConsumer));
    Log::SetVerbosity(Log::Kind::Info);
    Log::ReportFilenames(true);
    
    _participant = new RovParticipant();
    _participant->init();
    return self;
}

- (bool)registerReaderWithTopicName:(NSString *)topicName typeName:(NSString*)typeName keyed:(bool) keyed payloadDecoder: (NSObject<PayloadDecoderInterface>*) payloadDecoder {

    return _participant->addReader([topicName cStringUsingEncoding:NSUTF8StringEncoding],
                                   [typeName cStringUsingEncoding:NSUTF8StringEncoding],
                                   keyed,
                                   payloadDecoder);
}

- (bool)removeReaderWithTopicName:(NSString *)topicName {
    return _participant->removeReader([topicName cStringUsingEncoding:NSUTF8StringEncoding]);
}

- (void)stopRTPS {
    _participant->resignAll();
    delete _participant;
}

- (void)resignAll {
    _participant->resignAll();
}

@end
