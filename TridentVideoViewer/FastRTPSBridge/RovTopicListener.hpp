//
//  RovTopicListener.hpp
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
#import <Cocoa/Cocoa.h>
#import "TridentVideoViewer-Swift.h"


class RovTopicListener:public eprosima::fastrtps::rtps::ReaderListener
{
public:
    RovTopicListener(const char* topicName);
    ~RovTopicListener();
    void onNewCacheChangeAdded(eprosima::fastrtps::rtps::RTPSReader* reader,
                               const eprosima::fastrtps::rtps::CacheChange_t* const change) override;
    void onReaderMatched(eprosima::fastrtps::rtps::RTPSReader*,
                         eprosima::fastrtps::rtps::MatchingInfo& info) override;
    void on_liveliness_changed(eprosima::fastrtps::rtps::RTPSReader *reader,
                               const eprosima::fastrtps::LivelinessChangedStatus &status) override;
    
    PayloadDecoder *payloadDecoder;
    uint32_t n_matched;
    std::string topicName;
};

#endif /* ORovTopicListener_hpp */
