//
//  CameraControlView.swift
//  TestFloatWim
//
//  Created by Dmitriy Borovikov on 22/09/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Cocoa

class CameraControlView: NSVisualEffectView {
    @IBOutlet weak var xConstraint: NSLayoutConstraint!
    @IBOutlet weak var yConstraint: NSLayoutConstraint!

    var mousePosRelatedToView: CGPoint?
    var isDragging: Bool = false
    var cpv: CGFloat = 0
    var cph: CGFloat = 0
    let alignConst: CGFloat = 10
    private var isAlignFeedbackSent = false

    override func awakeFromNib() {
        self.roundCorners(withRadius: 6)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    override func mouseDown(with event: NSEvent) {
        let titlebarHeight = window!.titlebarHeight
        mousePosRelatedToView = NSEvent.mouseLocation
        mousePosRelatedToView!.x -= frame.origin.x
        mousePosRelatedToView!.y -= frame.origin.y
        isAlignFeedbackSent = abs(frame.origin.y - (window!.frame.height - frame.height - titlebarHeight) / 2) <= alignConst
        isDragging = true
    }

    override func mouseDragged(with event: NSEvent) {
        let titlebarHeight = window!.titlebarHeight
        guard let mousePos = mousePosRelatedToView, let windowFrame = window?.frame else { return }
        let currentLocation = NSEvent.mouseLocation
        var newOrigin = CGPoint(
            x: currentLocation.x - mousePos.x,
            y: currentLocation.y - mousePos.y
        )
        // stick to center
        let yPosWhenCenter = (windowFrame.height - frame.height - titlebarHeight) / 2
        if abs(newOrigin.y - yPosWhenCenter) <= alignConst {
            newOrigin.y = yPosWhenCenter
            if !isAlignFeedbackSent {
                NSHapticFeedbackManager.defaultPerformer.perform(.alignment, performanceTime: .default)
                isAlignFeedbackSent = true
            }
        } else {
            isAlignFeedbackSent = false
        }
        // bound to window frame
        let xMax = windowFrame.width - frame.width
        let yMax = windowFrame.height - frame.height - titlebarHeight
        newOrigin = newOrigin.constrained(to: NSRect(x: 0, y: 0, width: xMax, height: yMax))
        // apply position
        xConstraint.constant = newOrigin.x + frame.width / 2
        yConstraint.constant = newOrigin.y + frame.height / 2
    }

    override func mouseUp(with event: NSEvent) {
        isDragging = false
        guard let windowFrame = window?.frame else { return }
        //         save final position
        cph = xConstraint.constant / windowFrame.width
        cpv = yConstraint.constant / windowFrame.height
        //        Preference.set(xConstraint.constant / windowFrame.width, for: .controlBarPositionHorizontal)
        //        Preference.set(yConstraint.constant / windowFrame.height, for: .controlBarPositionVertical)
    }

    func windowDidResize() {
        // update control bar position
        //        let cph = Preference.float(for: .controlBarPositionHorizontal)
        //        let cpv = Preference.float(for: .controlBarPositionVertical)
        guard let window = window else { return }
        let windowWidth = window.frame.width
        let oscHalfWidth: CGFloat = frame.width / 2

        var xPos = windowWidth * CGFloat(cph)
        if xPos < oscHalfWidth {
            xPos = oscHalfWidth
        } else if xPos + oscHalfWidth > windowWidth {
            xPos = windowWidth - oscHalfWidth
        }

        let windowHeight = window.frame.height
        let oscHalHeight = frame.height / 2

        var yPos = windowHeight * CGFloat(cpv)
        if yPos < oscHalHeight {
            yPos = oscHalHeight
        } else if yPos + oscHalHeight > windowHeight {
            yPos = windowHeight - oscHalHeight
        }

        xConstraint.constant = xPos
        yConstraint.constant = yPos

    }
}
