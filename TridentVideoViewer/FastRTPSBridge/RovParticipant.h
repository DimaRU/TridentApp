//
//  RovParticipant.h
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 06/09/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

#ifndef RovParticipant_h
#define RovParticipant_h

#include <map>
#include <string>
#include "fastrtps/rtps/rtps_fwd.h"
//#include "fastrtps/rtps/reader/ReaderListeћner.h"

//class RovTopicListener;
class RovParticipant
{
public:
    RovParticipant();
    virtual ~RovParticipant();
    eprosima::fastrtps::rtps::RTPSParticipant* mp_participant;
    eprosima::fastrtps::rtps::ReaderHistory* mp_history;
    std::map<std::string, eprosima::fastrtps::rtps::RTPSReader*> readerList;
    bool init(); //Initialization
    bool addReader(const char* name,
             const char* dataType,
             eprosima::fastrtps::rtps::TopicKind_t tKind= eprosima::fastrtps::rtps::NO_KEY); //Register
    bool removeReader(const char* name);
};

#endif /* RovParticipant_hpp */
