//
//  RovBarometer.swift
//  TestIntegration
//
//  Created by Dmitriy Borovikov on 21/08/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct FluidPressure: Codable {
    let header: RovHeader

    let fluidPressure: Double
    let variance: Double
}

struct RovBarometer: DDSKeyed {
    let pressure: FluidPressure
    let id: String

    var key: Data { id.data(using: .utf8)! }
    static var ddsTypeName: String { "orov::sensor::Barometer" }
}

