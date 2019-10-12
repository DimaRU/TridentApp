//
//  RovQuaternion.swift
//  Test3d
//
//  Created by Dmitriy Borovikov on 11.10.2019.
//  Copyright © 2019 Dmitriy Borovikov. All rights reserved.
//

import Foundation
import SceneKit

public typealias Scalar = Double


extension RovQuaternion {
    func scnQuaternion() -> SCNQuaternion {
        return SCNQuaternion(-x, -z, -y, w)
    }
}

extension RovQuaternion {
    static let zero = RovQuaternion(0, 0, 0, 0)
    static let identity = RovQuaternion(0, 0, 0, 1)

    var lengthSquared: Scalar {
        return x * x + y * y + z * z + w * w
    }

    var length: Scalar {
        return sqrt(lengthSquared)
    }

    var inverse: RovQuaternion {
        return -self
    }

    var pitch: Scalar {
        return asin(min(1, max(-1, 2 * (w * y - z * x))))
    }

    var yaw: Scalar {
        return atan2(2 * (w * z + x * y), 1 - 2 * (y * y + z * z))
    }

    var roll: Scalar {
        return atan2(2 * (w * x + y * z), 1 - 2 * (x * x + y * y))
    }

    init(_ x: Scalar, _ y: Scalar, _ z: Scalar, _ w: Scalar) {
        self.init(x: x, y: y, z: z, w: w)
    }

    init(pitch: Scalar, yaw: Scalar, roll: Scalar) {
        let t0 = cos(yaw * 0.5)
        let t1 = sin(yaw * 0.5)
        let t2 = cos(roll * 0.5)
        let t3 = sin(roll * 0.5)
        let t4 = cos(pitch * 0.5)
        let t5 = sin(pitch * 0.5)
        self.init(
            t0 * t3 * t4 - t1 * t2 * t5,
            t0 * t2 * t5 + t1 * t3 * t4,
            t1 * t2 * t4 - t0 * t3 * t5,
            t0 * t2 * t4 + t1 * t3 * t5
        )
    }

    init(_ v: [Scalar]) {
        assert(v.count == 4, "array must contain 4 elements, contained \(v.count)")

        x = v[0]
        y = v[1]
        z = v[2]
        w = v[3]
    }

    func toPitchYawRoll() -> (pitch: Scalar, yaw: Scalar, roll: Scalar) {
        return (pitch, yaw, roll)
    }

    func toArray() -> [Scalar] {
        return [x, y, z, w]
    }

    func dot(_ v: RovQuaternion) -> Scalar {
        return x * v.x + y * v.y + z * v.z + w * v.w
    }

    func normalized() -> RovQuaternion {
        let lengthSquared = self.lengthSquared
        if lengthSquared ~= 0 || lengthSquared ~= 1 {
            return self
        }
        return self / sqrt(lengthSquared)
    }

    func interpolated(with q: RovQuaternion, by t: Scalar) -> RovQuaternion {
        let dot = max(-1, min(1, self.dot(q)))
        if dot ~= 1 {
            return (self + (q - self) * t).normalized()
        }

        let theta = acos(dot) * t
        let t1 = self * cos(theta)
        let t2 = (q - (self * dot)).normalized() * sin(theta)
        return t1 + t2
    }

    static prefix func - (q: RovQuaternion) -> RovQuaternion {
        return RovQuaternion(-q.x, -q.y, -q.z, q.w)
    }

    static func + (lhs: RovQuaternion, rhs: RovQuaternion) -> RovQuaternion {
        return RovQuaternion(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z, lhs.w + rhs.w)
    }

    static func - (lhs: RovQuaternion, rhs: RovQuaternion) -> RovQuaternion {
        return RovQuaternion(lhs.x - rhs.x, lhs.y - rhs.y, lhs.z - rhs.z, lhs.w - rhs.w)
    }

    static func * (lhs: RovQuaternion, rhs: RovQuaternion) -> RovQuaternion {
        return RovQuaternion(
            lhs.w * rhs.x + lhs.x * rhs.w + lhs.y * rhs.z - lhs.z * rhs.y,
            lhs.w * rhs.y + lhs.y * rhs.w + lhs.z * rhs.x - lhs.x * rhs.z,
            lhs.w * rhs.z + lhs.z * rhs.w + lhs.x * rhs.y - lhs.y * rhs.x,
            lhs.w * rhs.w - lhs.x * rhs.x - lhs.y * rhs.y - lhs.z * rhs.z
        )
    }

    static func * (lhs: RovQuaternion, rhs: Scalar) -> RovQuaternion {
        return RovQuaternion(lhs.x * rhs, lhs.y * rhs, lhs.z * rhs, lhs.w * rhs)
    }

    static func / (lhs: RovQuaternion, rhs: Scalar) -> RovQuaternion {
        return RovQuaternion(lhs.x / rhs, lhs.y / rhs, lhs.z / rhs, lhs.w / rhs)
    }

    static func ~= (lhs: RovQuaternion, rhs: RovQuaternion) -> Bool {
        return lhs.x ~= rhs.x && lhs.y ~= rhs.y && lhs.z ~= rhs.z && lhs.w ~= rhs.w
    }
}
