//
//  FastRTPS.swift
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 07/09/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

class FastRTPS {
    let fastRTPSBridge = FastRTPSBridge()
    static let shared = FastRTPS()
    
    class func registerReader(topic: RovTopic) {
        let payloadDecoder = PayloadDecoder(topic: topic)
        FastRTPS.shared.fastRTPSBridge.registerReader(withTopicName: topic.rawValue,
                                                      typeName: topic.ddsTypeName,
                                                      keyed: topic.isKeyed,
                                                      payloadDecoder: payloadDecoder)
    }
    
    class func removeReader(topic: RovTopic) {
        FastRTPS.shared.fastRTPSBridge.removeReader(withTopicName: topic.rawValue)
    }
}
