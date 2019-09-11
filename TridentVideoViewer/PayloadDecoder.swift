//
//  PayloadDecoder.swift
//  TestIntegration
//
//  Created by Dmitriy Borovikov on 14/08/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation
import CDRCodable

@objc public protocol PayloadDecoderInterface {
    func decode(sequence: Int,
                payloadSize: Int,
                payload: UnsafePointer<CUnsignedChar>)
}

class PayloadDecoder<T: DDSType>:NSObject, PayloadDecoderInterface {
    typealias Completion = (T) -> Void
    let decoder = CDRDecoder()
    var topic: RovTopic
    var completion: Completion?
    
    init(topic: RovTopic, completion: Completion? = nil) {
        self.topic = topic
        self.completion = completion
        super.init()
    }

    deinit {
        print("deinit PayloadDecoder")
    }
    
    func decode(sequence: Int,
                payloadSize: Int,
                payload: UnsafePointer<CUnsignedChar>) {
        
        let data = Data(bytes: payload + 4, count: payloadSize - 4)
        do {
            let t = try decoder.decode(T.self, from: data)
            completion?(t)
        } catch {
            print("\(topic.rawValue): \(sequence) \(payloadSize) error decoding")
            print(error)
        }
    }
}
