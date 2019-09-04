//
//  DDSType.swift
//  TridentVideoViewer
//
//  Created by Dmitriy Borovikov on 31/08/2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation

protocol DDSType: Codable {
    static var ddsTypeName: String { get }
    static var isKeyed: Bool { get }
}
