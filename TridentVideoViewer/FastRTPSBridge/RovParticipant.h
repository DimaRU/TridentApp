//
//  RovParticipant.h
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 06/09/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

#ifndef RovParticipant_h
#define RovParticipant_h

#include "fastrtps/rtps/rtps_fwd.h"
#include "fastrtps/rtps/reader/ReaderListener.h"

class ORovTopicListener;
class RovParticipant
{
public:
    RovParticipant();
    virtual ~RovParticipant();
    eprosima::fastrtps::rtps::RTPSParticipant* mp_participant;
    eprosima::fastrtps::rtps::ReaderHistory* mp_history;
    bool init(); //Initialization
    eprosima::fastrtps::rtps::RTPSReader* registerReader(const char* name,
             const char* dataType,
             eprosima::fastrtps::rtps::TopicKind_t tKind= eprosima::fastrtps::rtps::NO_KEY); //Register
};

#endif /* RovParticipant_hpp */
