//
//  RovTopicListener.cpp
//  TestIntegration
//
//  Created by Dmitriy Borovikov on 21/08/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

#include "RovTopicListener.h"

#include <fastrtps/rtps/reader/RTPSReader.h>
#include <fastrtps/rtps/history/ReaderHistory.h>

using namespace eprosima::fastrtps;
using namespace eprosima::fastrtps::rtps;

RovTopicListener::RovTopicListener(const char* topicName, NSObject<PayloadDecoderInterface>* payloadDecoder): n_matched(0)
{
    RovTopicListener::topicName = std::string(topicName);
    RovTopicListener::payloadDecoder = payloadDecoder;
}

RovTopicListener::~RovTopicListener()
{
    std::cout << "Listener deinit" << std::endl;
}

void RovTopicListener::onNewCacheChangeAdded(RTPSReader* reader, const CacheChange_t * const change)
{
    [payloadDecoder decodeWithSequence:change->sequenceNumber.to64long()
                           payloadSize:change->serializedPayload.length
                               payload:change->serializedPayload.data];
    reader->getHistory()->remove_change((CacheChange_t*)change);
}

void RovTopicListener::on_liveliness_changed(RTPSReader *reader, const LivelinessChangedStatus &status)
{
    std::cout << "Liveliness: " << status.alive_count_change << std::endl;
}

void RovTopicListener::onReaderMatched(RTPSReader* reader, MatchingInfo& info)
{
    switch (info.status)
    {
        case MATCHED_MATCHING:
            std::cout << "\tReader Matched:" << topicName << " -  guid: " << info.remoteEndpointGuid <<  std::endl;
            n_matched++;
            break;
        case REMOVED_MATCHING:
            std::cout << "\tReader remove matched:" << topicName << " - guid: " << info.remoteEndpointGuid << std::endl;
            n_matched--;
            break;
    }
}
