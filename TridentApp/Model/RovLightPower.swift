//
//  RovLightPower.swift
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 14/09/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct RovLightPower: DDSKeyed
{
    // Light ID: forward, accesory_id, etc
    let id: String       //@key
    let power: Float      // Percent, 0.0 to 1.0
    
    var key: Data { id.data(using: .utf8)! }
    static var ddsTypeName: String { "orov::msg::device::LightPower" }
}


