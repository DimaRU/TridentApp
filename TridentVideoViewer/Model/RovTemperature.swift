//
//  RovTemperature.swift
//  TestIntegration
//
//  Created by Dmitriy Borovikov on 21/08/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

protocol Keyed {
    var key: String { get }
}

struct RovTime: Codable {
    let sec: Int32
    let nanosec: UInt32
}

struct RovHeader: Codable {
    let stamp: RovTime
    let frameId: String
}

struct OrovTemperature_: Codable{
    let header: RovHeader
    let temperature: Double
    let variance: Double
}

struct RovTemperature: Codable, Keyed {
    let temperature_: OrovTemperature_
    let id: String
    
    var key: String { return id }
}
