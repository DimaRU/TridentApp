//
//  RovAttitude.swift
//  TestIntegration
//
//  Created by Dmitriy Borovikov on 22/08/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct RovAttitude: DDSKeyed {
    let header: RovHeader
    let orientation: RovQuaternion
    let angularVelocity: RovVector3
    
    let id: String

    var key: Data { id.data(using: .utf8)! }
    static var ddsTypeName: String { "orov::msg::sensor::Attitude" }
}
