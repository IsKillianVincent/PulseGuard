//
//  MachCPUReader.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import Foundation
import Darwin

final class MachCPUReader: CPUReading {
    private struct CoreTimes { let user: UInt32, system: UInt32, idle: UInt32, nice: UInt32 }
    private var last: [CoreTimes] = []

    func sample() -> CPUSnapshot? {
        var numCPUs: natural_t = 0
        var cpuInfo: processor_info_array_t?
        var numCPUInfo: mach_msg_type_number_t = 0

        let kr = host_processor_info(mach_host_self(),
                                     PROCESSOR_CPU_LOAD_INFO,
                                     &numCPUs,
                                     &cpuInfo,
                                     &numCPUInfo)
        guard kr == KERN_SUCCESS, let cpuInfo else { return nil }
        defer {
            let sz = vm_size_t(numCPUInfo) * vm_size_t(MemoryLayout<integer_t>.size)
            vm_deallocate(mach_task_self_, vm_address_t(bitPattern: cpuInfo), sz)
        }

        let cpuCount = Int(numCPUs)
        let stride = Int(CPU_STATE_MAX)
        var times: [CoreTimes] = []
        times.reserveCapacity(cpuCount)

        for cpu in 0..<cpuCount {
            let base = cpu * stride
            let user  = UInt32(cpuInfo[base + Int(CPU_STATE_USER)])
            let nice  = UInt32(cpuInfo[base + Int(CPU_STATE_NICE)])
            let sys   = UInt32(cpuInfo[base + Int(CPU_STATE_SYSTEM)])
            let idle  = UInt32(cpuInfo[base + Int(CPU_STATE_IDLE)])
            times.append(CoreTimes(user: user &+ nice, system: sys, idle: idle, nice: nice))
        }

        guard !last.isEmpty, last.count == times.count else {
            last = times
            let zeros = Array(repeating: CPUCoreLoad(user: 0, system: 0, idle: 1), count: times.count)
            let la = Self.loadAverage()
            return CPUSnapshot(date: Date(),
                               total: CPUCoreLoad(user: 0, system: 0, idle: 1),
                               perCore: zeros,
                               loadAvg1: la.0, loadAvg5: la.1, loadAvg15: la.2)
        }

        var perCore: [CPUCoreLoad] = []
        perCore.reserveCapacity(times.count)
        var totUser: Double = 0, totSys: Double = 0, totIdle: Double = 0

        for i in 0..<times.count {
            let p = last[i], c = times[i]
            let du = Double(c.user  &- p.user)
            let ds = Double(c.system &- p.system)
            let di = Double(c.idle   &- p.idle)
            let sum = max(du + ds + di, 1)
            perCore.append(CPUCoreLoad(user: du / sum, system: ds / sum, idle: di / sum))
            totUser += du; totSys += ds; totIdle += di
        }
        last = times

        let tsum = max(totUser + totSys + totIdle, 1)
        let total = CPUCoreLoad(user: totUser / tsum, system: totSys / tsum, idle: totIdle / tsum)
        let la = Self.loadAverage()

        return CPUSnapshot(date: Date(),
                           total: total,
                           perCore: perCore,
                           loadAvg1: la.0, loadAvg5: la.1, loadAvg15: la.2)
    }

    private static func loadAverage() -> (Double, Double, Double) {
        var la = [Double](repeating: 0, count: 3)
        return getloadavg(&la, 3) == 3 ? (la[0], la[1], la[2]) : (0,0,0)
    }
}
