//
//  RovWriterListener.cpp
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 13.09.2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

#include "RovWriterListener.h"

using namespace eprosima::fastrtps;
using namespace eprosima::fastrtps::rtps;

RovWriterListener::RovWriterListener()
{
    n_matched = 0;
}

RovWriterListener::~RovWriterListener()
{
}

void RovWriterListener::onWriterMatched(RTPSWriter* writer, MatchingInfo& info)
{
    switch (info.status)
    {
        case MATCHED_MATCHING:
            std::cout << "\tWriter matched guid: " << info.remoteEndpointGuid <<  std::endl;
            n_matched++;
            break;
        case REMOVED_MATCHING:
            std::cout << "\tWriter remove matched guid: " << info.remoteEndpointGuid << std::endl;
            n_matched--;
            break;
    }
}
