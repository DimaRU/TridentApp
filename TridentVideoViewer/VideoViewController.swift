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

    private var videoDecoder: VideoDecoder!
    private let videoDecoderQueue = DispatchQueue.init(label: "in.ioshack.Trident", qos: .background)
    private let dispatchGroup = DispatchGroup()
    
    private var lightOn = false
    private var depth: Float = 0 {
        didSet { depthLabel.stringValue = String(format: "Depth: %.1f", depth) }
    }
    private var temperature: Double = 0 {
        didSet { tempLabel.stringValue = String(format: "Temp: %.1f℃", temperature) }
    }

    deinit {
        print("Deinit VideoViewController")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        statusLabel.stringValue = ""
        depthLabel.stringValue = ""
        tempLabel.stringValue = ""
        
        videoDecoder = VideoDecoder()
    }

    func windowWillClose(_ notification: Notification) {
        stop()
        FastRTPS.stopRTPS()
    }

    override func viewWillAppear() {
        super.viewWillAppear()
        view.window?.delegate = self
        imageView.image = NSImage(named: "Trident")
        statusLabel.stringValue = "Connecting to Trident..."
        statusLabel.textColor = NSColor.lightGray
    }

    override func viewDidAppear() {
        super.viewDidAppear()

        start()
    }

    override func viewWillDisappear() {
        super.viewWillDisappear()
       
        stop()
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
    }

    private func start() {
        videoDecoder.delegate = self

        FastRTPS.registerWriter(topic: .rovLightPowerRequested, ddsType: RovLightPower.self)
        FastRTPS.registerReader(topic: .rovCamFwdH2640Video) { (videoData: RovVideoData) in
            self.videoDecoderQueue.async { [weak self] in
                self?.dispatchGroup.enter()
                self?.videoDecoder.decodeVideo(data: videoData.data)
                self?.dispatchGroup.leave()
            }
        }
        
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
}
