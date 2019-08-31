//
//  RovAttitude.swift
//  TestIntegration
//
//  Created by Dmitriy Borovikov on 22/08/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct RovAttitude: Codable, Keyed {
    let header: RovHeader
    let orientation: RovQuaternion
    let angularVelocity: RovVector3
    
    let id: String
    var key: String { return id }
}
