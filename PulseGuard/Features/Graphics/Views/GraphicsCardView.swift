//
//  GraphicsCardView.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 24/08/2025.
//


import SwiftUI

struct GraphicsCardView: View {
    @ObservedObject var vm: GraphicsViewModel

    private func pct(_ x: Double?) -> String { x.map { String(format: "%.0f%%", $0 * 100) } ?? "—" }
    private func bytes(_ b: UInt64?) -> String {
        guard let b else { return "—" }
        let gb = Double(b) / 1_073_741_824.0
        return String(format: "%.2f GB", gb)
    }
    private func temp(_ c: Double?) -> String { c.map { String(format: "%.0f°C", $0) } ?? "—" }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Graphics")
                    .font(.headline)
                Spacer()
                Text(vm.status.name)
                    .foregroundStyle(.secondary)
            }
            .padding(.bottom, 4)

            HStack(spacing: 12) {
                tile(title: "LOAD", value: pct(vm.status.load))
                tile(title: "MEMORY", value: bytes(vm.status.memoryUsedBytes))
                tile(title: "TEMPERATURE", value: temp(vm.status.temperatureC))
            }
        }
        .padding(12)
        .background(.quaternary.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))
    }

    private func tile(title: String, value: String) -> some View {
        VStack(spacing: 4) {
            Text(value).font(.title3).bold()
            Text(title).font(.caption2).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(.quaternary.opacity(0.15), in: RoundedRectangle(cornerRadius: 12))
    }
}
