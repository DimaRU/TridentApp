//
//  RovFuelgauge.swift
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 06/09/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

struct RovFuelgaugeStatus: DDSType {
    let state: BatteryState

    let id: String //@key
    let averageCurrent: Float
    let averagePower: Float
    let batteryTemperature: Float

    static var isKeyed: Bool { true }
    static var ddsTypeName: String { "orov::msg::sensor::FuelgaugeStatus" }
}

struct RovFuelgaugeHealth: DDSType {
    let state: BatteryState

    let id: String //@key
    let full_charge_capacity: Float
    let average_time_to_empty_mins: Int32
    let cycle_count: Int32
    let state_of_health_pct: Float

    static var isKeyed: Bool { true }
    static var ddsTypeName: String { "orov::msg::sensor::FuelgaugeHealth" }
}
