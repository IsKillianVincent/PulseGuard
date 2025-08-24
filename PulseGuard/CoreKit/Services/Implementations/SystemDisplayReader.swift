//
//  SystemDisplayReader.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//

import AppKit
import CoreGraphics

public final class SystemDisplayReader: DisplayReading {
    public init() {}

    public func current() -> [DisplayInfo] {
        NSScreen.screens.compactMap { s in
            let key = NSDeviceDescriptionKey("NSScreenNumber")
            guard let n = s.deviceDescription[key] as? NSNumber else { return nil }
            let did  = CGDirectDisplayID(truncating: n)
            let mode = CGDisplayCopyDisplayMode(did)

            let pxW = CGFloat(mode?.pixelWidth  ?? 0)
            let pxH = CGFloat(mode?.pixelHeight ?? 0)
            let hz  = mode?.refreshRate
            let scale = s.backingScaleFactor

            let pointsW = s.frame.size.width
            let hiDPIRatio = (pointsW > 0) ? (pxW / pointsW) > 1.01 : false
            let isHiDPI = hiDPIRatio || scale > 1.0

            return DisplayInfo(
                id: did,
                name: s.localizedName,
                resolutionPixels: .init(width: pxW, height: pxH),
                sizePoints: s.frame.size,
                scale: scale,
                refreshHz: (hz ?? 0) > 0 ? hz : nil,
                colorSpaceName: s.colorSpace?.localizedName,
                isMain: s == NSScreen.main,
                isBuiltin: CGDisplayIsBuiltin(did) != 0,
                isHiDPI: isHiDPI
            )
        }
        .sorted { ($0.isMain ? 0 : 1, $0.name) < ($1.isMain ? 0 : 1, $1.name) }
    }
}
