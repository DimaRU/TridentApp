//
//  RovModelView.swift
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 13.10.2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Cocoa
import SceneKit

class RovModelView: SCNView, FloatingViewProtocol {
    weak var xConstraint: NSLayoutConstraint?
    weak var yConstraint: NSLayoutConstraint?

    var mousePosRelatedToView: CGPoint?
    var isDragging: Bool = false
    var cpv: CGFloat = 0
    var cph: CGFloat = 0
    let alignConst: CGFloat = -1
    var isAlignFeedbackSent = false

    override func awakeFromNib() {
        super.awakeFromNib()
        self.roundCorners(withRadius: 6)
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
    
    func savePosition(cph: CGFloat, cpv: CGFloat) {
        Preference.rovModelViewCPH = cph
        Preference.rovModelViewCPV = cpv
    }
    
    func loadPosition() -> (cph: CGFloat?, cpv: CGFloat?) {
        return (
            Preference.rovModelViewCPH,
            Preference.rovModelViewCPV
        )
    }
    
}
