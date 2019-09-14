//
//  RovParticipant.h
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 06/09/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

#pragma once

#include <fastrtps/rtps/rtps_fwd.h>
#include <fastrtps/rtps/common/Types.h>
#include <fastrtps/rtps/attributes/WriterAttributes.h>
#include <fastrtps/rtps/reader/RTPSReader.h>
#include "fastrtps/rtps/writer/RTPSWriter.h"
#include <string>
#include <map>
typedef unsigned char octet;

#import <Cocoa/Cocoa.h>
#import "TridentVideoViewer-Swift.h"

class CustomParticipantListener;
class RovParticipant
{
public:
    RovParticipant();
    virtual ~RovParticipant();
    eprosima::fastrtps::rtps::RTPSParticipant* mp_participant;
    eprosima::fastrtps::rtps::ReaderHistory* mp_reader_history;
    eprosima::fastrtps::rtps::WriterHistory* mp_writer_history;

    CustomParticipantListener* mp_listener;
    std::map<std::string, eprosima::fastrtps::rtps::RTPSReader*> readerList;
    std::map<std::string, eprosima::fastrtps::rtps::RTPSWriter*> writerList;
    bool init(); //Initialization
    bool addReader(const char* name,
                   const char* dataType,
                   const bool keyed,
                   NSObject<PayloadDecoderInterface>* payloadDecoder);
    bool removeReader(const char* name);
    
    bool addWriter(const char* name,
                   const char* dataType,
                   const bool keyed);
    bool removeWriter(const char* name);
    bool send(const char* name, const uint8_t* data, uint32_t length, const void* key, uint32_t keyLenght);
    void resignAll();
};
