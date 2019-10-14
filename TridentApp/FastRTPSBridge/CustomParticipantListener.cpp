//
//  CustomParticipantListener.cpp
//  TestFastRTPS
//
//  Created by Dmitriy Borovikov on 29/07/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

#include "CustomParticipantListener.h"

using namespace eprosima::fastrtps;
using namespace eprosima::fastrtps::rtps;

void CustomParticipantListener::onReaderDiscovery(RTPSParticipant *participant, ReaderDiscoveryInfo &&info)
{
    (void)participant;
    switch(info.status) {
        case ReaderDiscoveryInfo::DISCOVERED_READER:
            std::cout << "Reader for topic '" << info.info.topicName() << "' type '" << info.info.typeName() << "' discovered" << std::endl;
            break;
        case ReaderDiscoveryInfo::CHANGED_QOS_READER:
            break;
        case ReaderDiscoveryInfo::REMOVED_READER:
            std::cout << "Reader for topic '" << info.info.topicName() << "' type '" << info.info.typeName() << "' left the domain." << std::endl;
            break;
    }
}

void CustomParticipantListener::onWriterDiscovery(RTPSParticipant *participant, WriterDiscoveryInfo &&info)
{
    (void)participant;
    switch(info.status) {
        case WriterDiscoveryInfo::DISCOVERED_WRITER:
            std::cout << "Writer for topic '" << info.info.topicName() << "' type '" << info.info.typeName() << "' discovered" << std::endl;
            break;
        case WriterDiscoveryInfo::CHANGED_QOS_WRITER:
            break;
        case WriterDiscoveryInfo::REMOVED_WRITER:
            std::cout << "Writer for topic '" << info.info.topicName() << "' type '" << info.info.typeName() << "' left the domain." << std::endl;
            break;
    }
}

void CustomParticipantListener::onParticipantDiscovery(RTPSParticipant *participant, ParticipantDiscoveryInfo &&info)
{
    (void)participant;
    switch(info.status) {
        case ParticipantDiscoveryInfo::DISCOVERED_PARTICIPANT:
            std::cout << "Participant '" << info.info.m_participantName << "' discovered" << std::endl;
            break;
        case ParticipantDiscoveryInfo::DROPPED_PARTICIPANT:
            std::cout << "Participant '" << info.info.m_participantName << "' dropped" << std::endl;
            break;
        case ParticipantDiscoveryInfo::REMOVED_PARTICIPANT:
            std::cout << "Participant '" << info.info.m_participantName << "' removed" << std::endl;
            break;
        case ParticipantDiscoveryInfo::CHANGED_QOS_PARTICIPANT:
            break;
    }
}
