//
//  ORovTopicListener.hpp
//  TestIntegration
//
//  Created by Dmitriy Borovikov on 21/08/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

#ifndef ORovTopicListener_hpp
#define ORovTopicListener_hpp

#include <stdio.h>
#include "fastrtps/rtps/rtps_fwd.h"
#include "fastrtps/rtps/reader/ReaderListener.h"
#include <Cocoa/Cocoa.h>
#include "TridentVideoViewer-Swift.h"


class ORovTopicListener:public eprosima::fastrtps::rtps::ReaderListener
{
public:
    ORovTopicListener(const char* topicName, const char* dataType);
    ~ORovTopicListener();
    void onNewCacheChangeAdded(eprosima::fastrtps::rtps::RTPSReader* reader,
                               const eprosima::fastrtps::rtps::CacheChange_t* const change) override;
    void onReaderMatched(eprosima::fastrtps::rtps::RTPSReader*,
                         eprosima::fastrtps::rtps::MatchingInfo& info) override;
    void on_liveliness_changed(eprosima::fastrtps::rtps::RTPSReader *reader,
                               const eprosima::fastrtps::LivelinessChangedStatus &status) override;
    
    PayloadDecoder *payloadDecoder;
    uint32_t n_matched;
    std::string dataType;
    std::string topicName;
};

#endif /* ORovTopicListener_hpp */
