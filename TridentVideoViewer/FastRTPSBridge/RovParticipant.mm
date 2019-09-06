//
//  RovParticipant.mm
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 06/09/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

#include "RovParticipant.h"

#include <fastrtps/rtps/reader/RTPSReader.h>
#include <fastrtps/rtps/participant/RTPSParticipant.h>
#include <fastrtps/rtps/RTPSDomain.h>

#include <fastrtps/rtps/attributes/RTPSParticipantAttributes.h>
#include <fastrtps/rtps/attributes/ReaderAttributes.h>
#include <fastrtps/rtps/attributes/HistoryAttributes.h>

#include <fastrtps/rtps/history/ReaderHistory.h>

#include <fastrtps/attributes/TopicAttributes.h>
#include <fastrtps/qos/ReaderQos.h>

#include "ORovTopicListener.hpp"

using namespace eprosima::fastrtps;
using namespace eprosima::fastrtps::rtps;

RovParticipant::RovParticipant():
mp_participant(nullptr),
mp_history(nullptr)
{
}

RovParticipant::~RovParticipant()
{
    RTPSDomain::removeRTPSParticipant(mp_participant);
    delete(mp_history);
//    mp_participant->stopRTPSParticipantAnnouncement();
}

bool RovParticipant::init()
{
    //CREATE PARTICIPANT
    RTPSParticipantAttributes PParam;
    PParam.builtin.use_WriterLivelinessProtocol = true;
    PParam.builtin.discovery_config.discoveryProtocol = eprosima::fastrtps::rtps::DiscoveryProtocol::SIMPLE;
    PParam.builtin.discovery_config.leaseDuration_announcementperiod.seconds = 1;
    PParam.builtin.discovery_config.leaseDuration.seconds = 20;
    PParam.builtin.readerHistoryMemoryPolicy = PREALLOCATED_WITH_REALLOC_MEMORY_MODE;
    PParam.builtin.writerHistoryMemoryPolicy = PREALLOCATED_WITH_REALLOC_MEMORY_MODE;
    PParam.builtin.domainId = 0;
    PParam.setName("Temp_reader");
    mp_participant = RTPSDomain::createParticipant(PParam);
    if (mp_participant == nullptr)
        return false;

    //CREATE READERHISTORY
    HistoryAttributes hatt;
    hatt.payloadMaxSize = 10000;
    hatt.memoryPolicy = PREALLOCATED_WITH_REALLOC_MEMORY_MODE;
    hatt.maximumReservedCaches = 0;
    mp_history = new ReaderHistory(hatt);

    return true;
}

RTPSReader* RovParticipant::registerReader(const char* name,
                               const char* dataType,
                               rtps::TopicKind_t tKind)
{

    //CREATE READER
    ReaderAttributes ratt;
    //    ratt.disable_positive_acks = false;
//    Locator_t loc(22222);
//    ratt.endpoint.unicastLocatorList.push_back(loc);
    ratt.endpoint.topicKind = tKind;

    auto listener = new ORovTopicListener(name, dataType);
    auto reader = RTPSDomain::createRTPSReader(mp_participant, ratt, mp_history, listener);
    reader->enableMessagesFromUnkownWriters(true);
    if (reader == nullptr)
        return nullptr;

    TopicAttributes Tatt(name, dataType, tKind);
    ReaderQos Rqos;
    Rqos.m_partition.push_back("fe39129");
//    Rqos.m_durability.kind = VOLATILE_DURABILITY_QOS;
    auto rezult = mp_participant->registerReader(reader, Tatt, Rqos);
    if (rezult) {
        std::cout << "Registered reader: " << name << " - " << dataType << std::endl;
        return reader;
    }
    return reader;
}
