//
//  StorageReading.swift
//  PulseGuard
//
//  Created by Killian VINCENT on 22/08/2025.
//

import Foundation

final class StorageReader: StorageReading {
    func volumes() -> [DiskVolume] {
        let fm = FileManager.default
        let keys: Set<URLResourceKey> = [
            .volumeNameKey,
            .volumeTotalCapacityKey,
            .volumeAvailableCapacityKey,
            .volumeAvailableCapacityForImportantUsageKey,
            .volumeIsInternalKey
        ]

        let urls = fm.mountedVolumeURLs(
            includingResourceValuesForKeys: Array(keys),
            options: [.skipHiddenVolumes]
        ) ?? []

        var items: [DiskVolume] = []
        items.reserveCapacity(urls.count)

        for url in urls {
            guard let rv = try? url.resourceValues(forKeys: keys),
                  let totalAny = rv.volumeTotalCapacity
            else { continue }

            // ➜ Normalisation en Int64 (évite le conflit Int?/Int64?)
            let total = Int64(totalAny)

            let free: Int64
            if let imp = rv.volumeAvailableCapacityForImportantUsage {
                free = Int64(imp)
            } else if let avail = rv.volumeAvailableCapacity {
                free = Int64(avail)
            } else {
                free = 0
            }

            items.append(
                DiskVolume(
                    name: rv.volumeName ?? url.lastPathComponent,
                    total: total,
                    free: free,
                    isInternal: rv.volumeIsInternal ?? false
                )
            )
        }

        // ➜ Tri: internes d’abord, puis nom (A→Z)
        items.sort {
            if $0.isInternal != $1.isInternal { return $0.isInternal && !$1.isInternal }
            return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }

        return items
    }
}
