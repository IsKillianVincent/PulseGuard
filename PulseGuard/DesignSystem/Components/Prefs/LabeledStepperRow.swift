//
//  LabeledStepperRow.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 23/08/2025.
//

import SwiftUI

struct LabeledStepperRow: View {
    let titleKey: LocalizedStringKey
    @Binding var value: Int
    let range: ClosedRange<Int>
    var step: Int = 5
    var unitSuffix: String? = nil
    var valueWidth: CGFloat = 56

    init(titleKey: LocalizedStringKey,
         value: Binding<Int>,
         range: ClosedRange<Int>,
         step: Int = 5,
         unitSuffix: String? = nil,
         valueWidth: CGFloat = 56) {
        self.titleKey = titleKey
        self._value = value
        self.range = range
        self.step = step
        self.unitSuffix = unitSuffix
        self.valueWidth = valueWidth
    }

    var body: some View {
        HStack(spacing: 12) {
            Text(titleKey)

            Spacer()

            Text("\(value)\(unitSuffix ?? "")")
                .monospacedDigit()
                .frame(width: valueWidth, alignment: .trailing)
                .foregroundStyle(.secondary)

            Stepper("", value: $value, in: range, step: step)
                .labelsHidden()
        }
        .accessibilityElement(children: .combine)
    }
}
