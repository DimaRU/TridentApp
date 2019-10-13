//
//  FastRTPS.swift
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 07/09/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation
import CDRCodable

class FastRTPS {
    private static let shared = FastRTPS()
    lazy var fastRTPSBridge: FastRTPSBridge? = FastRTPSBridge()

    class func stopRTPS() {
        FastRTPS.shared.fastRTPSBridge?.stopRTPS()
        FastRTPS.shared.fastRTPSBridge = nil
    }

    class func registerReader<T: DDSType>(topic: RovPubTopic, completion: @escaping (T)->Void) {
        let payloadDecoder = PayloadDecoder(topic: topic, completion: completion)
        FastRTPS.shared.fastRTPSBridge?.registerReader(withTopicName: topic.rawValue,
                                                      typeName: T.ddsTypeName,
                                                      keyed: T.isKeyed,
                                                      payloadDecoder: payloadDecoder)
    }
    
    class func removeReader(topic: RovPubTopic) {
        FastRTPS.shared.fastRTPSBridge?.removeReader(withTopicName: topic.rawValue)
    }

    class func registerWriter(topic: RovSubTopic, ddsType: DDSType.Type) {
        FastRTPS.shared.fastRTPSBridge?.registerWriter(withTopicName: topic.rawValue,
                                                      typeName: ddsType.ddsTypeName,
                                                      keyed: ddsType.isKeyed)
    }
    class func removeWriter(topic: RovSubTopic) {
        FastRTPS.shared.fastRTPSBridge?.removeWriter(withTopicName: topic.rawValue)
    }

    class func send<T: DDSType>(topic: RovSubTopic, ddsData: T) {
        let encoder = CDREncoder()
        do {
            let data = try encoder.encode(ddsData)
            if T.isKeyed {
                let key = (ddsData as! DDSKeyed).key
                FastRTPS.shared.fastRTPSBridge?.send(withTopicName: topic.rawValue, data: data, key: key)
            } else {
                FastRTPS.shared.fastRTPSBridge?.send(withTopicName: topic.rawValue, data: data)
            }
        } catch {
            print(error)
        }
    }

    class func resignAll() {
        FastRTPS.shared.fastRTPSBridge?.resignAll()
    }
}
