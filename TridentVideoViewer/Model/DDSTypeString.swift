//
//  DDSTypeString.swift
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 14.10.2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

extension String: DDSType {
    static var isKeyed: Bool { false }
    static var ddsTypeName: String { "DDS::String" }
}
