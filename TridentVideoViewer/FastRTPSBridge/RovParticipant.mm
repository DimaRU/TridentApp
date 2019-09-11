//
//  RovParticipant.mm
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 06/09/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

#include "RovParticipant.h"
#include "RovTopicListener.h"
#include "CustomParticipantListener.h"

#include <fastrtps/rtps/RTPSDomain.h>
#include <fastrtps/rtps/participant/RTPSParticipant.h>
#include <fastrtps/rtps/reader/RTPSReader.h>
#include <fastrtps/rtps/attributes/RTPSParticipantAttributes.h>
#include <fastrtps/rtps/attributes/ReaderAttributes.h>
#include <fastrtps/rtps/attributes/HistoryAttributes.h>
#include <fastrtps/rtps/history/ReaderHistory.h>

#include <fastrtps/attributes/TopicAttributes.h>
#include <fastrtps/qos/ReaderQos.h>


using namespace eprosima::fastrtps;
using namespace eprosima::fastrtps::rtps;

RovParticipant::RovParticipant():
mp_participant(nullptr),
mp_history(nullptr),
mp_listener(nullptr)
{
}

RovParticipant::~RovParticipant()
{
    mp_participant->stopRTPSParticipantAnnouncement();
    std::cout << "Delete participant" << std::endl;
    resignAll();
    RTPSDomain::removeRTPSParticipant(mp_participant);
    delete(mp_history);
    delete(mp_listener);
//    RTPSDomain::stopAll();
}

void RovParticipant::resignAll() {
    for(auto it = readerList.begin(); it != readerList.end(); it++)
    {
        std::cout << "Remove reader: " << it->first << std::endl;
        auto reader = it->second;
        auto listener = reader->getListener();
        RTPSDomain::removeRTPSReader(reader);
        delete listener;
    }
    readerList.clear();
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
    PParam.setName("TridentVideoViewer");
    
    mp_listener = new CustomParticipantListener();
    mp_participant = RTPSDomain::createParticipant(PParam, mp_listener);
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

bool RovParticipant::addReader(const char* name,
                               const char* dataType,
                               const bool keyed,
                               NSObject<PayloadDecoderInterface>* payloadDecoder)
{
    auto topicName = std::string(name);
    auto tKind = keyed ? eprosima::fastrtps::rtps::WITH_KEY : eprosima::fastrtps::rtps::NO_KEY;
    if (readerList.find(topicName) != readerList.end()) {
        // aready registered
        return false;
    }
    //CREATE READER
    ReaderAttributes readerAttributes;
    readerAttributes.endpoint.topicKind = tKind;
    auto listener = new RovTopicListener(name, payloadDecoder);
    auto reader = RTPSDomain::createRTPSReader(mp_participant, readerAttributes, mp_history, listener);
    if (reader == nullptr) {
        delete listener;
        return false;
    }
    readerList[topicName] = reader;
  
    reader->enableMessagesFromUnkownWriters(true);
    
    TopicAttributes Tatt(name, dataType, tKind);
    ReaderQos Rqos;
    Rqos.m_partition.push_back("*");
    auto rezult = mp_participant->registerReader(reader, Tatt, Rqos);
    if (!rezult) {
        RTPSDomain::removeRTPSReader(reader);
        readerList.erase(topicName);
        delete listener;
        return false;
    }
    std::cout << "Registered reader: " << name << " - " << dataType << std::endl;
    return true;
}

bool RovParticipant::removeReader(const char* name)
{
    std::cout << "Remove reader: " << name << std::endl;
    auto topicName = std::string(name);
    if (readerList.find(topicName) == readerList.end()) {
        return false;
    }
    auto reader = readerList[topicName];
    auto listener = reader->getListener();
    if (!RTPSDomain::removeRTPSReader(reader))
        return false;
    delete listener;
    readerList.erase(topicName);
    return true;
}
