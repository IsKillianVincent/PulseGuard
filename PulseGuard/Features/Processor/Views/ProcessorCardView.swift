//
//  ProcessorCardView.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import SwiftUI

struct ProcessorCardView: View {
    @ObservedObject var vm: CPUViewModel

    var body: some View {
        SectionCard(title: "Processor", icon: "cpu", accent: .pgBlue) {
            Text(vm.totalPercentText)
                .font(.title3).monospacedDigit()
        } content: {
            VStack(spacing: Theme.spacing) {
                BarGauge(progress: vm.snapshot?.total.total ?? 0,
                         leftLabel: "Total",
                         rightLabel: breakdown,
                         accent: .pgBlue)

                if let s = vm.snapshot {
                    HStack(spacing: 8) {
                        Pill(value: s.total.user,  label: "User")
                        Pill(value: s.total.system,label: "System")
                        Pill(value: s.total.idle,  label: "Idle")
                    }
                }

                if let s = vm.snapshot {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Per-core").font(.caption).foregroundStyle(.secondary)
                        ForEach(Array(s.perCore.enumerated()), id: \.offset) { idx, core in
                            HStack(spacing: 8) {
                                Text("\(idx+1)").font(.caption2)
                                    .frame(width: 18, alignment: .trailing)
                                    .foregroundStyle(.secondary)
                                ProgressView(value: core.total).progressViewStyle(.linear)
                                Text("\(Int(round(core.total*100)))%")
                                    .font(.caption2).monospacedDigit()
                                    .frame(width: 36, alignment: .trailing)
                            }
                        }
                    }
                }

                HistoryLine(points: vm.history)
            }
        }
    }

    private var breakdown: String {
        guard let t = vm.snapshot?.total else { return "" }
        let u = Int(round(t.user*100)), s = Int(round(t.system*100))
        return "U \(u)% • S \(s)%"
    }
}

private struct Pill: View {
    let value: Double
    let label: String
    var body: some View {
        VStack(spacing: 6) {
            GeometryReader { geo in
                Capsule().fill(.quaternary).overlay(
                    Capsule().fill(Color.pgBlue.opacity(0.65))
                        .frame(width: geo.size.width * value),
                    alignment: .leading
                )
            }.frame(height: 8)
            Text(label).font(.caption2).foregroundStyle(.secondary)
        }
    }
}
