// Copyright 2016 Proyectos y Sistemas de Mantenimiento SL (eProsima).
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**
 * @file TestReaderRegistered.cpp
 *
 */

#include "TestReaderRegistered.h"

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

TestReaderRegistered::TestReaderRegistered():
mp_participant(nullptr),
mp_reader(nullptr),
mp_history(nullptr)
{
}

TestReaderRegistered::~TestReaderRegistered()
{
    RTPSDomain::removeRTPSParticipant(mp_participant);
    delete(mp_history);
//    mp_participant->stopRTPSParticipantAnnouncement();
}

bool TestReaderRegistered::init()
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

ORovTopicListener* TestReaderRegistered::reg(const char* name,
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
    mp_reader = RTPSDomain::createRTPSReader(mp_participant, ratt, mp_history, listener);
    mp_reader->enableMessagesFromUnkownWriters(true);
    if (mp_reader == nullptr)
        return nullptr;

    TopicAttributes Tatt(name, dataType, tKind);
    ReaderQos Rqos;
    Rqos.m_partition.push_back("fe39129");
//    Rqos.m_durability.kind = VOLATILE_DURABILITY_QOS;
    auto rezult = mp_participant->registerReader(mp_reader, Tatt, Rqos);
    if (rezult) {
        std::cout << "Registered reader: " << name << " - " << dataType << std::endl;
        return listener;
    }
    return listener;
}

void TestReaderRegistered::run()
{
}
