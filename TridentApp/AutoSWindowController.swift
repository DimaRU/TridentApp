//
//  AutoSWindowController.swift
//  TridentApp
//
//  Created by Dmitriy Borovikov on 14.10.2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Cocoa

class AutoSWindowController: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
        print(self.windowFrameAutosaveName)
        self.windowFrameAutosaveName = "TridentVideoWindow"
    }

}
