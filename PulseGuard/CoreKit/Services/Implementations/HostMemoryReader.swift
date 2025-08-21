//
//  HostMemoryReader.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//


import Foundation
import Darwin

final class HostMemoryReader: MemoryReading {
    func sample() -> MemorySnapshot? {
        var total: UInt64 = 0
        var len = MemoryLayout<UInt64>.size
        sysctlbyname("hw.memsize", &total, &len, nil, 0)

        var pageSize: vm_size_t = 0
        host_page_size(mach_host_self(), &pageSize)

        var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.size / MemoryLayout<integer_t>.size)
        var vm = vm_statistics64()
        let r = withUnsafeMutablePointer(to: &vm) { ptr -> kern_return_t in
            ptr.withMemoryRebound(to: integer_t.self, capacity: Int(count)) { iptr in
                host_statistics64(mach_host_self(), HOST_VM_INFO64, iptr, &count)
            }
        }
        guard r == KERN_SUCCESS else { return nil }

        let page = UInt64(pageSize)
        let free = UInt64(vm.free_count) * page
        let active = UInt64(vm.active_count) * page
        let inactive = UInt64(vm.inactive_count) * page
        let wired = UInt64(vm.wire_count) * page
        let compressed = UInt64(vm.compressor_page_count) * page

        let used = min(total, active + inactive + wired + compressed)

        let ratio = total == 0 ? 0.0 : Double(used) / Double(total)
        let pressure: MemoryPressure =
            ratio >= 0.95 ? .critical :
            ratio >= 0.85 ? .high :
            ratio >= 0.70 ? .medium : .low

        return MemorySnapshot(date: Date(),
                              totalBytes: total,
                              usedBytes: used,
                              freeBytes: free,
                              wiredBytes: wired,
                              compressedBytes: compressed,
                              pressure: pressure)
    }
}
