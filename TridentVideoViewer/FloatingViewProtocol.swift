//
//  FloatingViewProtocol.swift
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 13.10.2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Cocoa

protocol FloatingViewProtocol: NSView {
    var xConstraint: NSLayoutConstraint! { get set }
    var yConstraint: NSLayoutConstraint! { get set }

    var mousePosRelatedToView: CGPoint? { get set }
    var isDragging: Bool { get set }
    var cpv: CGFloat { get set }
    var cph: CGFloat { get set }
    var alignConst: CGFloat { get }
    var isAlignFeedbackSent: Bool { get set }
}

extension FloatingViewProtocol {
    func mouseDownAct(with event: NSEvent) {
        guard let window = window else { return }
        let titlebarHeight = window.titlebarHeight
        mousePosRelatedToView = NSEvent.mouseLocation
        mousePosRelatedToView!.x -= frame.origin.x
        mousePosRelatedToView!.y -= frame.origin.y
        isAlignFeedbackSent = abs(frame.origin.y - (window.frame.height - frame.height - titlebarHeight) / 2) <= alignConst
        isDragging = true
    }

    func mouseDraggedAct(with event: NSEvent) {
        if (!isDragging) { return }
        guard let mousePos = mousePosRelatedToView, let windowFrame = window?.frame else { return }
        let titlebarHeight = window!.titlebarHeight
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

    func mouseUpAct(with event: NSEvent) {
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
