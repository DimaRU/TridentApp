//
//  RovCommon.swift
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 31/08/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct RovTime: Codable {
    let sec: Int32
    let nanosec: UInt32
}

struct RovHeader: Codable {
    let stamp: RovTime
    let frameId: String
}
