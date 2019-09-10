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
    
    class func registerReader<T: DDSType>(topic: RovTopic, completion: @escaping (T)->Void) {
        let payloadDecoder = PayloadDecoder(topic: topic, completion: completion)
        FastRTPS.shared.fastRTPSBridge.registerReader(withTopicName: topic.rawValue,
                                                      typeName: topic.ddsTypeName,
                                                      keyed: topic.isKeyed,
                                                      payloadDecoder: payloadDecoder)
    }
    
    class func removeReader(topic: RovTopic) {
        FastRTPS.shared.fastRTPSBridge.removeReader(withTopicName: topic.rawValue)
    }
}
