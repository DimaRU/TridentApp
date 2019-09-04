//
//  RovControlDescriptor.swift
//  TestIntegration
//
//  Created by Dmitriy Borovikov on 23/08/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct RovMenuOption: Codable
{
    let value_string: String
    let value_s64: Int64
}

// Topic format: "<topicPrefix_rov_camChannels><channel_id>_ctrl_desc"
// Ex: rov_cam_forward_H2640_ctrl_desc
struct RovControlDescriptor: DDSType {
    let id: UInt32       //@key
    let id_string: String
    let type: UInt32
    let name: String
    let unit: String
    let minimum: Int64
    let maximum: Int64
    let step: UInt64
    let default_value_numeric: Int64
    let default_value_string: String
    let flags: UInt32
    let menu_options: [RovMenuOption]

    static var isKeyed: Bool { true }
    static var ddsTypeName: String { "orov::msg::image::ControlDescriptor" }
}
