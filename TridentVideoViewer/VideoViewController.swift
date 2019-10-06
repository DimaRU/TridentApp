//
//  VideoViewController.swift
//  TestH264Decode
//
//  Created by Dmitriy Borovikov on 26/08/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Cocoa
import Carbon.HIToolbox

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
    @IBOutlet weak var recordingButton: FlatButton!
    
    private var videoDecoder: VideoDecoder!
    private let videoDecoderQueue = DispatchQueue.init(label: "in.ioshack.Trident", qos: .background)
    private let dispatchGroup = DispatchGroup()
    
    private var tridentCommandTimer: Timer?
    
    private var lightOn = false
    private var videoSessionId: UUID?
    
    private var depth: Float = 0 {
        didSet { depthLabel.stringValue = String(format: "Depth: %.1f", depth) }
    }
    private var temperature: Double = 0 {
        didSet { tempLabel.stringValue = String(format: "\u{1001ec} %.1f℃", temperature) }
    }
    
    private var batteryTime: Int32 = 0 {
        didSet {
            var time = "\u{1006e8} "
            guard batteryTime != 65535 else {
                batteryTimeLabel.stringValue = time + "charging"
                return
            }
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
            var time = "Remaining time:\n"
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
        self.cameraTimeLabel.textColor = .systemGray

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
        
        tridentCommandTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            let thrust = self.forwardLever - self.backwardLever
            let yaw = self.leftLever - self.rightLever
            let pitch = self.upLever - self.downLever
            let tridentCommand = RovTridentControlTarget(id: "control", pitch: pitch, yaw: yaw, thrust: thrust, lift: 0)
            FastRTPS.send(topic: .rovControlTarget, ddsData: tridentCommand)
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

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let timeMs = UInt(Date().timeIntervalSince1970 * 1000)
            FastRTPS.send(topic: .rovDatetime, ddsData: String(timeMs))
            FastRTPS.send(topic: .rovVideoOverlayModeCommand, ddsData: "on")
            let videoReq = RovVideoSessionCommand(sessionID: "", metadata: "", request: .stopped, response: .unknown, reason: "")
            FastRTPS.send(topic: .rovVidSessionReq, ddsData: videoReq)
        }
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
        
        FastRTPS.registerReader(topic: .rovControlCurrent) { (tridentControlTarget: RovTridentControlTarget) in
            print(tridentControlTarget)
        }
        
        FastRTPS.registerReader(topic: .rovVidSessionCurrent) { (videoSession: RovVideoSession) in
            DispatchQueue.main.async {
                switch videoSession.state {
                case .unknown:
                    break
                case .recording:
                    if self.videoSessionId == nil {
                        self.videoSessionId = UUID(uuidString: videoSession.sessionID)
                    }
                    let sec = videoSession.totalDurationS % 60
                    let min = (videoSession.totalDurationS / 60)
                    let hour = videoSession.totalDurationS / 3600
                    self.recordingTimeLabel.stringValue = String(format: "%2.2d:%2.2d:%2.2d", hour, min, sec)
                    
                    self.recordingButton.activeButtonColor = NSColor(named: "recordActive")!
                    self.recordingButton.buttonColor = NSColor(named: "recordNActive")!
                    self.cameraTimeLabel.textColor = .white

                case .stopped:
                    self.videoSessionId = nil
                    self.recordingTimeLabel.stringValue = ""
                    self.cameraTimeLabel.textColor = .systemGray
                    self.recordingButton.activeButtonColor = NSColor(named: "stopActive")!
                    self.recordingButton.buttonColor = NSColor(named: "stopNActive")!
                }
            }
        }
        
        FastRTPS.registerReader(topic: .rovVidSessionRep) { (videoSessionCommand: RovVideoSessionCommand) in
            DispatchQueue.main.async {
                switch videoSessionCommand.response {
                case .unknown:
                    break
                case .accepted:
                    self.videoSessionId = UUID(uuidString: videoSessionCommand.sessionID)
                case .rejectedGeneric:
                    self.videoSessionId = nil
                case .rejectedInvalidSession:
                    self.videoSessionId = nil
                case .rejectedSessionInProgress:
                    self.videoSessionId = nil
                    let alert = NSAlert()
                    alert.messageText = "Recording"
                    alert.informativeText = "Already in progress"
                    alert.runModal()
                case .rejectedNoSpace:
                    self.videoSessionId = nil
                    let alert = NSAlert()
                    alert.messageText = "Recording"
                    alert.informativeText = "No space left"
                    alert.runModal()
                }
            }
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
    }
    
    private func startRecordingSession(id: UUID) {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let isoDate = formatter.string(from: Date())
        let metadata = #"{"start_ts":"\#(isoDate)"}"#

        let videoSessionCommand = RovVideoSessionCommand(sessionID: id.uuidString.lowercased(),
                                                         metadata: metadata,
                                                         request: .recording,
                                                         response: .unknown,
                                                         reason: "")
        FastRTPS.send(topic: .rovVidSessionReq, ddsData: videoSessionCommand)
    }
    
    private func stopRecordingSession(id: UUID) {
        let videoSessionCommand = RovVideoSessionCommand(sessionID: id.uuidString.lowercased(),
                                                         metadata: "",
                                                         request: .stopped,
                                                         response: .unknown,
                                                         reason: "")
        FastRTPS.send(topic: .rovVidSessionReq, ddsData: videoSessionCommand)
    }

    @IBAction func recordingButtonPress(_ sender: Any) {
        if let videoSessionId = videoSessionId {
            stopRecordingSession(id: videoSessionId)
        } else {
            startRecordingSession(id: UUID())
        }
    }
    
    @IBAction func lightButtonPress(_ sender: Any) {
        let lightPower = RovLightPower.init(id: "fwd", power: lightOn ? 0:1)
        FastRTPS.send(topic: .rovLightPowerRequested, ddsData: lightPower)
    }
 
   
    override func keyUp(with event: NSEvent) {
        processKeyEvent(event: event)
    }
    
    override func keyDown(with event: NSEvent) {
        processKeyEvent(event: event)
    }
    
    private var leftLever: Float = 0
    private var rightLever: Float = 0
    private var forwardLever: Float = 0
    private var backwardLever: Float = 0
    private var upLever: Float = 0
    private var downLever: Float = 0

    private func processKeyEvent(event: NSEvent) {
        var lever: Float = 0.1
        if NSEvent.modifierFlags.contains(.option) { lever = 0.25 }
        if NSEvent.modifierFlags.contains(.control) { lever = 0.50 }
        if NSEvent.modifierFlags.contains(.shift) { lever = 1 }

        if event.type == .keyDown {
            switch event.specialKey {
            case .upArrow?:
                forwardLever = lever
                backwardLever = 0
            case .downArrow?:
                backwardLever = lever
                forwardLever = 0
            case .leftArrow?:
                leftLever = lever
                rightLever = 0
            case .rightArrow?:
                rightLever = lever
                leftLever = 0
            default:
                switch Int(event.keyCode) {
                case kVK_ANSI_W:
                    upLever = lever
                    downLever = 0
                case kVK_ANSI_S:
                    downLever = lever
                    upLever = 0
                default:
                    break
                }
            }
        }
        
        if event.type == .keyUp {
            switch event.specialKey {
            case .upArrow?:
                forwardLever = 0
            case .downArrow?:
                backwardLever = 0
            case .leftArrow?:
                leftLever = 0
            case .rightArrow?:
                rightLever = 0
            default:
                switch Int(event.keyCode) {
                case kVK_ANSI_W:
                    upLever = 0
                case kVK_ANSI_S:
                    downLever = 0
                default:
                    break
                }
            }
        }

    }
}
