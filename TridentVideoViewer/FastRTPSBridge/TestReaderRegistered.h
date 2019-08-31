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
 * @file TestReaderRegistered.h
 *
 */

#ifndef TESTREADERREGISTERED_H_
#define TESTREADERREGISTERED_H_

#include "fastrtps/rtps/rtps_fwd.h"
#include "fastrtps/rtps/reader/ReaderListener.h"


class ORovTopicListener;
class TestReaderRegistered
{
public:
    TestReaderRegistered();
    virtual ~TestReaderRegistered();
    eprosima::fastrtps::rtps::RTPSParticipant* mp_participant;
    eprosima::fastrtps::rtps::RTPSReader* mp_reader;
    eprosima::fastrtps::rtps::ReaderHistory* mp_history;
    bool init(); //Initialization
    ORovTopicListener* reg(const char* name,
             const char* dataType,
             eprosima::fastrtps::rtps::TopicKind_t tKind= eprosima::fastrtps::rtps::NO_KEY); //Register
    void run(); //Run
};

#endif /* TESTREADER_H_ */
