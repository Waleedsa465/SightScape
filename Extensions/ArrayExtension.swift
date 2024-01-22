//
//  ArrayExtension.swift
//  ToyTime
//
//  Created by Hunain on 12/04/2023.
//

import Foundation

public extension Array where Element: Hashable {
    func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter{ seen.insert($0).inserted }
    }
}
