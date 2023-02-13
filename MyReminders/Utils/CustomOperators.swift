//
//  CustomOperators.swift
//  MyReminders
//
//  Created by 한상민 on 2023/02/13.
//

import Foundation
import SwiftUI

public func ??<T>(lhs: Binding<Optional<T>>, rhs: T) -> Binding<T> {
    Binding {
        lhs.wrappedValue ?? rhs
    } set: {
        lhs.wrappedValue = $0
    }

}
