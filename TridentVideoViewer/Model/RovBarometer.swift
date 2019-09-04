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

struct RovBarometer: DDSType {
    let pressure: FluidPressure
    let id: String

    static var isKeyed: Bool { true }
    static var ddsTypeName: String { "orov::sensor::Barometer" }
}

