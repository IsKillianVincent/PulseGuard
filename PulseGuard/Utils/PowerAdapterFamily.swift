//
//  PowerAdapterFamilyMapper.swift
//  CoreKit
//
//  Created by You on 24/08/2025.
//
//
//  PowerAdapterFamilyMapper.swift
//  PulseGuard
//

import Foundation

public enum PowerAdapterFamilyMapper {
    // Surcharge pratique si ton code source est un Int?
    public static func label(code: Int?, watts: Int?, id: String?) -> String {
        label(code: code.map { UInt32($0) }, watts: watts, id: id)
    }

    public static func label(code: UInt32?, watts: Int?, id: String?) -> String {
        if let c = code {
            switch c {
            case 0x00:                return "Inconnu"
            case 0x01, 0x02:          return "USB"
            case 0x04, 0x06, 0x10:    return "USB-C"
            case 0x0B:                return "MagSafe"
            case 0x0C:                return "MagSafe 2"
            case 0x0D, 0x0E:          return "MagSafe 3"
            default: break
            }
        }
        if let w = watts {
            if [45, 60, 85].contains(w) { return "MagSafe" }
            if [18, 20, 29, 30, 35, 61, 65, 67, 87, 96, 100, 140].contains(w) { return "USB-C" }
        }
        if let s = id?.lowercased() {
            if s.contains("usbc") || s.contains("usb-c") { return "USB-C" }
            if s.contains("magsafe3") || s.contains("ms3") { return "MagSafe 3" }
            if s.contains("magsafe2") || s.contains("ms2") { return "MagSafe 2" }
            if s.contains("magsafe")  { return "MagSafe" }
        }
        return "—"
    }
}
