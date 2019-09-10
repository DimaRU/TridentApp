//
//  RovTemperature.swift
//  TestIntegration
//
//  Created by Dmitriy Borovikov on 21/08/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct RovTemperature: DDSType {
    struct RovTemperature_: Codable{
        let header: RovHeader
        let temperature: Double
        let variance: Double
    }
    
    let temperature: RovTemperature_
    let id: String
    
    static var isKeyed: Bool { true }
    static var ddsTypeName: String { "orov::msg::sensor::Temperature" }

}
