//
//  CaseWrappable.swift
//
//  Created by JechtSh0t on 10/29/24.
//  Copyright © 2024 Brook Street Games. All rights reserved.
//

///
/// A protocol for wrappable enumerations.
///
protocol CaseWrappable: CaseIterable, Equatable {
    var display: String { get }
    var next: Self { get }
}

extension CaseWrappable {
    var next: Self {
        let cases = Array(Self.allCases)
        let index = cases.firstIndex(of: self)!
        return index == cases.count - 1 ? cases[0] : cases[index + 1]
    }
}
