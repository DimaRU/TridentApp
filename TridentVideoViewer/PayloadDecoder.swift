//
//  PayloadDecoder.swift
//  TestIntegration
//
//  Created by Dmitriy Borovikov on 14/08/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation
import CDRCodable

public class PayloadDecoder: NSObject {
    let decoder = CDRDecoder()
    var topic: RovTopic
    
    init(topic: RovTopic) {
        self.topic = topic
    }

    deinit {
        print("deinit PayloadDecoder")
    }
    
    @objc public func decode(sequence: Int,
                             payloadSize: Int,
                             payload: UnsafePointer<CUnsignedChar>) {
        
//            print("Received bytes: \(payloadSize) seqn: \(sequence)")
        let data = Data(bytes: payload + 4, count: payloadSize - 4)
        
        do {
            try decodePayload(sequence: sequence, data: data)
        } catch {
            print(error)
        }
    }
    
    func decodePayload(sequence: Int, data: Data) throws {
        switch topic {
        case .rovTempWater:
            let temperature = try decoder.decode(RovTemperature.self, from: data)
            print("Sqn:\(sequence) \(topic.rawValue) temperature: \(temperature.temperature_.temperature) id: \(temperature.id)")
        default:
            fatalError("Unsupported \(topic.rawValue)")
        }
//        switch dataType {
//        case "orov::msg::sensor::Temperature":
//            let temperature = try decoder.decode(RovTemperature.self, from: data)
//            print("Sqn:\(sequence) \(topicName!) temperature: \(temperature.temperature_.temperature) id: \(temperature.id)")
//        case "orov::sensor::Barometer":
//            let barometer = try decoder.decode(RovBarometer.self, from: data)
//            print("Sqn: \(sequence) \(topicName!) pressure: \(barometer.pressure.fluidPressure) id: \(barometer.id)")
//        case "rov_video_overlay_mode_current":
//            let videoOverlayMode = try decoder.decode(String.self, from: data)
//            print("Sqn: \(sequence) \(topicName!)", videoOverlayMode)
//        case "orov::msg::sensor::Attitude":
//            let attitude = try decoder.decode(RovAttitude.self, from: data)
//            print("Sqn: \(sequence) \(topicName!)", attitude.orientation.x, attitude.orientation.y, attitude.orientation.z, attitude.orientation.w, attitude.id)
//        case "orov::msg::image::VideoData":
//            let videoData = try decoder.decode(RovVideoData.self, from: data)
//            let url = URL(fileURLWithPath: "/Users/dmitry/developer/logs/\(sequence).dmp")
//            try videoData.data.write(to: url)
//            print("Sqn: \(sequence) \(topicName!) id:", videoData.frame_id, videoData.data.count, videoData.timestamp)
//        case "orov::msg::image::ControlDescriptor":
//            let controlDescriptor = try decoder.decode(RovControlDescriptor.self, from: data)
//            let url = URL(fileURLWithPath: "/Users/dmitry/developer/logs/\(controlDescriptor.id_string).data")
//            try data.write(to: url)
//        case "orov::msg::image::Channel":
//            let channel = try decoder.decode(RovChannel.self, from: data)
//            print(channel)
//        default:
//            print("Unkonwn topic:", dataType!)
//        }
    }
}
