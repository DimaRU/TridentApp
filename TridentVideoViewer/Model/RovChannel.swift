//
//  RovChannel.swift
//  TestIntegration
//
//  Created by Dmitriy Borovikov on 23/08/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

// See V4L2 API for more details about fields
struct RovPixelFormat: Codable {
    let pixel_format: UInt32       //@key // FOURCC which specifies the exact pixel format
    let pixel_format_id: String    //@key // String representation of the pixel format, i.e. "H264"
    let width: UInt32
    let height: UInt32
    let field: UInt32
    let bytes_per_line: UInt32
    let size_image: UInt32
    let color_space: UInt8
    let priv: UInt32
    let flags: UInt32
    let ycbcr_enc: UInt8
    let hsv_enc: UInt8
    let quantization: UInt8
    let xfer_func: UInt8
}

struct RovChannel: DDSType {
    let id: String              //@key
    let format: RovPixelFormat  //@key
    let extra: [String]

    static var isKeyed: Bool { true }
    static var ddsTypeName: String { "orov::msg::image::Channel" }
}
