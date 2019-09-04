//
//  RovTemperature.swift
//  TestIntegration
//
//  Created by Dmitriy Borovikov on 21/08/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct OrovTemperature_: Codable{
    let header: RovHeader
    let temperature: Double
    let variance: Double
}

struct RovTemperature: DDSType {
    let temperature_: OrovTemperature_
    let id: String
    
    static var isKeyed: Bool { true }
    static var ddsTypeName: String { "orov::msg::sensor::Temperature" }

}
