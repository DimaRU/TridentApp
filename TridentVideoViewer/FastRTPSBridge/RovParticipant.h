//
//  RovParticipant.h
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 06/09/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

#pragma once

#include <string>
#include <map>
#include "fastrtps/rtps/rtps_fwd.h"
#import <Cocoa/Cocoa.h>
#import "TridentVideoViewer-Swift.h"

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
                   const bool keyed,
                   NSObject<PayloadDecoderInterface>* payloadDecoder);
    bool removeReader(const char* name);
};
