//
//  CameraControlView.swift
//  TestFloatWim
//
//  Created by Dmitriy Borovikov on 22/09/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Cocoa

class CameraControlView: NSView, FloatingViewProtocol {
    weak var xConstraint: NSLayoutConstraint?
    weak var yConstraint: NSLayoutConstraint?

    var mousePosRelatedToView: CGPoint?
    var isDragging: Bool = false
    var cpv: CGFloat = 0
    var cph: CGFloat = 0
    let alignConst: CGFloat = 10
    var isAlignFeedbackSent = false

    override func awakeFromNib() {
        super.awakeFromNib()
        self.roundCorners(withRadius: 6)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer?.backgroundColor = NSColor(named: "cameraControlBackground")!.cgColor
    }

    override func mouseDown(with event: NSEvent) {
        mouseDownAct(with: event)
    }

    override func mouseDragged(with event: NSEvent) {
        mouseDraggedAct(with: event)
    }

    override func mouseUp(with event: NSEvent) {
        mouseUpAct(with: event)
    }

}
