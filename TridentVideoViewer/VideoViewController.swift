//
//  VideoViewController.swift
//  TestH264Decode
//
//  Created by Dmitriy Borovikov on 26/08/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Cocoa
import AVFoundation
import VideoToolbox

class VideoViewController: NSViewController, NSWindowDelegate, VideoDecoderDelegate {
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var depthLabel: NSTextField!
    @IBOutlet weak var tempLabel: NSTextField!
    @IBOutlet weak var batteryTimeLabel: NSTextField!
    @IBOutlet weak var cameraTimeLabel: NSTextField!
    @IBOutlet weak var recordingTimeLabel: NSTextField!

    @IBOutlet weak var indicatorsView: NSView!
    @IBOutlet weak var cameraControlView: CameraControlView!
    @IBOutlet weak var xConstraint: NSLayoutConstraint!
    @IBOutlet weak var yConstraint: NSLayoutConstraint!
    @IBOutlet weak var lightButton: NSButton!
    
    private var videoDecoder: VideoDecoder!
    private let videoDecoderQueue = DispatchQueue.init(label: "in.ioshack.Trident", qos: .background)
    private let dispatchGroup = DispatchGroup()
    
    private var lightOn = false
    private var depth: Float = 0 {
        didSet { depthLabel.stringValue = String(format: "Depth: %.1f", depth) }
    }
    private var temperature: Double = 0 {
        didSet { tempLabel.stringValue = String(format: "\u{1001ec} %.1f℃", temperature) }
    }
    
    private var batteryTime: Int32 = 0 {
        didSet {
            var time = "\u{1006e8} "
            if batteryTime / 60 != 0 {
                time += String(batteryTime / 60) + "h "
            }
            if batteryTime % 60 != 0 {
                time += String(batteryTime % 60) + "m"
            }
            batteryTimeLabel.stringValue = time
        }
    }

    private var cameraTime: UInt32 = 0 {
        didSet {
            var time = "Cam: "
            if cameraTime / 60 != 0 {
                time += String(cameraTime / 60) + "h "
            }
            if cameraTime % 60 != 0 {
                time += String(cameraTime % 60) + "m"
            }
            cameraTimeLabel.stringValue = time
        }
    }
    
    deinit {
        print("Deinit VideoViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.stringValue = ""
        depthLabel.stringValue = ""
        tempLabel.stringValue = ""
        batteryTimeLabel.stringValue = ""
        cameraTimeLabel.stringValue = ""
        recordingTimeLabel.stringValue = ""

        cameraControlView.xConstraint = xConstraint
        cameraControlView.yConstraint = yConstraint
        indicatorsView.wantsLayer = true
        indicatorsView.layer?.backgroundColor = NSColor(named: "cameraControlBackground")!.cgColor

        videoDecoder = VideoDecoder()
        imageView.image = NSImage(named: "Trident")
        statusLabel.stringValue = "Connecting to Trident..."
        statusLabel.textColor = NSColor.lightGray

        start()
    }

    func windowWillClose(_ notification: Notification) {
        stop()
        FastRTPS.stopRTPS()
    }
    
    func windowDidResize(_ notification: Notification) {
        cameraControlView.windowDidResize()
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        view.window?.delegate = self
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        videoDecoder.delegate = self

        FastRTPS.registerReader(topic: .rovCamFwdH2640Video) { (videoData: RovVideoData) in
            self.videoDecoderQueue.async { [weak self] in
                self?.dispatchGroup.enter()
                self?.videoDecoder.decodeVideo(data: videoData.data)
                self?.dispatchGroup.leave()
            }
        }
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()
        videoDecoder.delegate = nil
        FastRTPS.removeReader(topic: .rovCamFwdH2640Video)
    }
    
    private func start() {
        registerReaders()
        registerWriters()

        let timeMs = UInt(Date().timeIntervalSince1970 * 1000)
        FastRTPS.send(topic: .rovDatetime, ddsData: String(timeMs))
        FastRTPS.send(topic: .rovVideoOverlayModeCommand, ddsData: "on")
    }

    private func stop() {
        FastRTPS.resignAll()
        stopVideo()
    }

    private func stopVideo() {
        // terminate the video processing
        dispatchGroup.wait()
        videoDecoder.delegate = nil
        videoDecoder.destroyVideoSession()

    }
    
    func decompressed(ciImage: CIImage, size: CGSize) {
        let rep = NSCIImageRep(ciImage: ciImage)
        let nsImage = NSImage(size: rep.size)
        nsImage.addRepresentation(rep)
        DispatchQueue.main.async {
            self.imageView.image = nsImage
        }
    }
    
    private func registerReaders() {
        FastRTPS.registerReader(topic: .rovTempWater) { (temp: RovTemperature) in
            DispatchQueue.main.async { [weak self] in
                self?.statusLabel.isHidden = true
                self?.temperature = temp.temperature.temperature
            }
        }
        
        FastRTPS.registerReader(topic: .rovDepth) { (depth: RovDepth) in
            DispatchQueue.main.async { [weak self] in
                self?.depth = depth.depth
            }
        }
        
        FastRTPS.registerReader(topic: .rovFuelgaugeHealth) { (health: RovFuelgaugeHealth) in
            DispatchQueue.main.async { [weak self] in
                self?.batteryTime = health.average_time_to_empty_mins
            }
        }
        
        FastRTPS.registerReader(topic: .rovRecordingStats) { (recordingStats: RovRecordingStats) in
            DispatchQueue.main.async { [weak self] in
                self?.cameraTime = recordingStats.estRemainingRecTimeS / 60
            }
        }
        
        FastRTPS.registerReader(topic: .rovVidSessionCurrent) { (videoSession: RovVideoSession) in
            print("rovVidSessionCurrent:", videoSession)
        }
        
        FastRTPS.registerReader(topic: .rovVidSessionRep) { (videoSessionCommand: RovVideoSessionCommand) in
            print("rovVidSessionRep:", videoSessionCommand)
        }
        
        FastRTPS.registerReader(topic: .rovLightPowerCurrent) { (lightPower: RovLightPower) in
            DispatchQueue.main.async {
                if lightPower.power > 0 {
                    // Light On
                    self.lightOn = true
                    self.lightButton.title = "\u{10078B}"
                    self.lightButton.contentTintColor = .white
                } else {
                    // Light Off
                    self.lightOn = false
                    self.lightButton.title = "\u{10074C}"
                    self.lightButton.contentTintColor = nil
                }
            }
        }
        
    }
    
    private func registerWriters() {
        FastRTPS.registerWriter(topic: .rovLightPowerRequested, ddsType: RovLightPower.self)
        FastRTPS.registerWriter(topic: .rovDatetime, ddsType: String.self)
        FastRTPS.registerWriter(topic: .rovVideoOverlayModeCommand, ddsType: String.self)
        FastRTPS.registerWriter(topic: .rovVidSessionReq, ddsType: RovVideoSessionCommand.self)
        FastRTPS.registerWriter(topic: .rovDepthConfigRequested, ddsType: RovDepthConfig.self)
        FastRTPS.registerWriter(topic: .rovControlTarget, ddsType: RovTridentControlTarget.self)
        FastRTPS.registerWriter(topic: .rovLightPowerRequested, ddsType: RovLightPower.self)
    }
    
    
    @IBAction func recordingButtonPress(_ sender: Any) {
    }
    
    @IBAction func lightButtonPress(_ sender: Any) {
        let lightPower = RovLightPower.init(id: "fwd", power: lightOn ? 0:1)
        FastRTPS.send(topic: .rovLightPowerRequested, ddsData: lightPower)
    }
    
}
