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

struct RovBarometer: Codable {
    let pressure: FluidPressure
    let id: String
    
    var key: String { return id }
}

