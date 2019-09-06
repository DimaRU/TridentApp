//
//  ORovTopicListener.cpp
//  TestIntegration
//
//  Created by Dmitriy Borovikov on 21/08/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

#include "ORovTopicListener.hpp"
#include "RovParticipant.h"

#include <fastrtps/rtps/reader/RTPSReader.h>

#include <fastrtps/rtps/attributes/ReaderAttributes.h>
#include <fastrtps/rtps/attributes/HistoryAttributes.h>

#include <fastrtps/rtps/history/ReaderHistory.h>
#include <fastrtps/attributes/TopicAttributes.h>
#include <fastrtps/qos/ReaderQos.h>

using namespace eprosima::fastrtps;
using namespace eprosima::fastrtps::rtps;

ORovTopicListener::ORovTopicListener(const char* topicName, const char* dataType):n_matched(0)
{
    ORovTopicListener::dataType = std::string(dataType);
    ORovTopicListener::topicName = std::string(topicName);
    payloadDecoder = [[PayloadDecoder alloc] initWithTopicName:(const uint8_t * _Nonnull)topicName dataType:(const uint8_t * _Nonnull)dataType];
}

ORovTopicListener::~ORovTopicListener()
{
    std::cout << "Listener deinit" << std::endl;
}

void ORovTopicListener::onNewCacheChangeAdded(RTPSReader* reader, const CacheChange_t * const change)
{
//    reader->get_unread_count()
    
    [payloadDecoder decodeWithSequence:change->sequenceNumber.to64long()
                           payloadSize:change->serializedPayload.length
                               payload:change->serializedPayload.data];
    reader->getHistory()->remove_change((CacheChange_t*)change);
}

void ORovTopicListener::on_liveliness_changed(RTPSReader *reader, const LivelinessChangedStatus &status)
{
    std::cout << "Liveliness: " << status.alive_count_change << std::endl;
}

void ORovTopicListener::onReaderMatched(eprosima::fastrtps::rtps::RTPSReader* reader,
                                        eprosima::fastrtps::rtps::MatchingInfo& info)
{
    switch (info.status)
    {
        case eprosima::fastrtps::rtps::MATCHED_MATCHING:
            std::cout << "\tMatched:" << topicName << " - " << dataType << " guid: " << info.remoteEndpointGuid <<  std::endl;
            n_matched++;
            break;
        case eprosima::fastrtps::rtps::REMOVED_MATCHING:
            std::cout << "\tRemove matched:" << topicName << " - " <<  dataType << " guid: " << info.remoteEndpointGuid << std::endl;
            n_matched--;
            break;
        default:
            // std::cout << "\tstatus: UNKNOWN (ERROR)\n";
            break;
    }
    
}
