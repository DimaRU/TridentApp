//
//  FastRTPSBridge.h
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 04/09/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <fastrtps/rtps/RTPSDomain.h>
#include "TestReaderRegistered.h"

NS_ASSUME_NONNULL_BEGIN

@interface FastRTPSBridge : NSObject
{
    TestReaderRegistered* participant;
}
- (id)init;
//- (BOOL)createRTPSParticipant;
@end

NS_ASSUME_NONNULL_END
