//
//  DisplayInfo.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

import AppKit
import CoreGraphics

public struct DisplayInfo: Identifiable, Equatable {
    public let id: CGDirectDisplayID
    public let name: String
    public let resolutionPixels: CGSize
    public let sizePoints: CGSize
    public let scale: CGFloat
    public let refreshHz: Double?
    public let colorSpaceName: String?
    public let isMain: Bool
    public let isBuiltin: Bool
    public let isHiDPI: Bool
}
