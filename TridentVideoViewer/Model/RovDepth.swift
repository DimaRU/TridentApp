//
//  RovDepth.swift
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 06/09/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct RovDepth: DDSType {
   
    let pressure: FluidPressure
    let id: String      // @key
    let depth: Float    // Unit: meters
    
    static var isKeyed: Bool { true }
    static var ddsTypeName: String { "orov::msg::sensor::Depth" }
}



// TODO: Use in trident-control
struct DepthConfig {
    enum WaterType: UInt8 {
        case fresh = 0
        case brackish = 1
        case salt = 2
        case count = 3
    }

    let id: String                //@key
    let waterType: WaterType      // See Above. Determines which constant to use for depth calculations
    let user_offset_enabled: Bool
    let zero_offset: Float        // Determined by entity at startup. Used as the zero point to offset depth calculated from sensor outputs. Unit: meters
    let zero_offset_user: Float   // Zero offset provided by user to override the initially determined value. Unit: meters
}
