//
//  RovTopic.swift
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 06/09/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation


enum RovTopic: String {
    // Publishers
    case rovPingReply                = "rov_ping_reply" //  DDS::String
    case rovVideoOverlayModeCurrent  = "rov_video_overlay_mode_current" //  DDS::String
    case rovControllerStateCurrent   = "rov_controller_state_current" // orov::msg::control::ControllerStatus
    case rovEscFaultAlert            = "rov_esc_fault_alert" // orov::msg::control::ESCFaultAlert
    case rovEscFaultWarningInfo      = "rov_esc_fault_warning_info" // orov::msg::control::ESCFaultWarningInfo
    case rovEscFeedback              = "rov_esc_feedback" // orov::msg::control::ESCFeedback
    case pidSetpointCurrent          = "pid_setpoint_current" // orov::msg::control::PIDSetpoint
    case pidState                    = "pid_state" // orov::msg::control::PIDState
    case rovSafety                   = "rov_safety" // orov::msg::control::SafetyState
    case tridentCommandTarget        = "trident_command_target" // orov::msg::control::TridentMotorCommand
    case rovLightPowerCurrent        = "rov_light_power_current" // orov::msg::device::LightPower
    case rovCams                     = "rov_cams" // orov::msg::image::Camera
    case rovCamFwd                   = "rov_cam_fwd" // orov::msg::image::Channel
    case rovCamFwdH2640CtrlDesc      = "rov_cam_fwd_H264_0_ctrl_desc" // orov::msg::image::ControlDescriptor
    case rovCamFwdH2641CtrlDesc      = "rov_cam_fwd_H264_1_ctrl_desc" // orov::msg::image::ControlDescriptor
    case rovCamFwdH2640CtrlCurrent   = "rov_cam_fwd_H264_0_ctrl_current" // orov::msg::image::ControlValue
    case rovCamFwdH2641CtrlCurrent   = "rov_cam_fwd_H264_1_ctrl_current" // orov::msg::image::ControlValue
    case rovCamFwdH2640Video         = "rov_cam_fwd_H264_0_video" // orov::msg::image::VideoData
    case rovCamFwdH2641Video         = "rov_cam_fwd_H264_1_video" // orov::msg::image::VideoData
    case rovRecordingStats           = "rov_recording_stats" // orov::msg::recording::RecordingStats
    case rovVidSessionCurrent        = "rov_vid_session_current" // orov::msg::recording::VideoSession
    case rovVidSessionRep            = "rov_vid_session_rep" // orov::msg::recording::VideoSessionCommand
    case rovAttitude                 = "rov_attitude" // orov::msg::sensor::Attitude
    case rovPressureInternal         = "rov_pressure_internal" // orov::msg::sensor::Barometer
    case rovDepth                    = "rov_depth" // orov::msg::sensor::Depth
    case rovFuelgaugeHealth          = "rov_fuelgauge_health" // orov::msg::sensor::FuelgaugeHealth
    case rovFuelgaugeStatus          = "rov_fuelgauge_status" // orov::msg::sensor::FuelgaugeStatus
    case rovTempInternal             = "rov_temp_internal" // orov::msg::sensor::Temperature
    case rovTempWater                = "rov_temp_water" // orov::msg::sensor::Temperature
    case rovMcuCommStats             = "rov_mcu_comm_stats" // orov::msg::system::CommStats
    case rovFirmwareCommandRep       = "rov_firmware_command_rep" // orov::msg::system::FirmwareCommand
    case rovFirmwareServiceStatus    = "rov_firmware_service_status" // orov::msg::system::FirmwareServiceStatus
    case rovFirmwareStatus           = "rov_firmware_status" // orov::msg::system::FirmwareStatus
    case rovMcuI2cStats              = "rov_mcu_i2c_stats" // orov::msg::system::I2CStats
    case rovImuCalibration           = "rov_imu_calibration" // orov::msg::system::IMUCalibration
    case rovMcuStatus                = "rov_mcu_status" // orov::msg::system::MCUStatus
    case rovMcuWatchdogStatus        = "rov_mcu_watchdog_status" // orov::msg::system::MCUWatchdogStatus
    case rovBeacon                   = "rov_beacon" // orov::msg::system::ROVBeacon
    case rovSubsystemStatus          = "rov_subsystem_status" // orov::msg::system::SubsystemStatus
    
    // Subscibers
    case rovDatetime                 = "rov_datetime" //  DDS::String
    case rovPingRequest              = "rov_ping_request" //  DDS::String
    case rovVideoOverlayModeCommand  = "rov_video_overlay_mode_command" //  DDS::String
    case rovVactestBlinkCommand      = "rov_vactest_blink_command" // orov::msg::common::Command
    case rovControllerStateRequested = "rov_controller_state_requested" // orov::msg::control::ControllerStatus
    case pidParametersRequested      = "pid_parameters_requested" // orov::msg::control::PIDParameters
    case pidSetpointRequested        = "pid_setpoint_requested" // orov::msg::control::PIDSetpoint
    case rovControlTarget            = "rov_control_target" // orov::msg::control::TridentControlTarget
    case rovMotorCommandDebug        = "rov_motor_command_debug" // orov::msg::control::TridentMotorCommand
    case rovLightPowerRequested      = "rov_light_power_requested" // orov::msg::device::LightPower
    case rovCamFwdH2640CtrlRequested = "rov_cam_fwd_H264_0_ctrl_requested" // orov::msg::image::ControlValue
    case rovCamFwdH2641CtrlRequested = "rov_cam_fwd_H264_1_ctrl_requested" // orov::msg::image::ControlValue
    case rovVidSessionReq            = "rov_vid_session_req" // orov::msg::recording::VideoSessionCommand
    case rovFirmwareCommandReq       = "rov_firmware_command_req" // orov::msg::system::FirmwareCommand
    
}

extension RovTopic {
    var ddsTypeName: String {
        return self.ddsType.ddsTypeName
    }
    
    var isKeyed: Bool {
        return self.ddsType.isKeyed
    }
    
    var ddsType: DDSType.Type {
        switch self {
        case .rovPingReply: return String.self
        case .rovVideoOverlayModeCurrent: return String.self
        case .rovCamFwdH2640CtrlDesc: return RovControlDescriptor.self
        case .rovCamFwdH2641CtrlDesc: return RovControlDescriptor.self
        case .rovCamFwdH2640Video: return RovVideoData.self
        case .rovCamFwdH2641Video: return RovVideoData.self
        case .rovAttitude: return RovAttitude.self
        case .rovPressureInternal: return RovBarometer.self
        case .rovDepth: return RovDepth.self
        case .rovFuelgaugeHealth: return RovFuelgaugeHealth.self
        case .rovFuelgaugeStatus: return RovFuelgaugeStatus.self
        case .rovTempInternal: return RovTemperature.self
        case .rovTempWater: return RovTemperature.self
        default:
            fatalError("Unsupported topic type")
       }
    }
}
