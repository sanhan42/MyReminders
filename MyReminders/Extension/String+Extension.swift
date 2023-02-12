//
//  String+Extension.swift
//  MyReminders
//
//  Created by 한상민 on 2023/02/13.
//

import Foundation

extension String {
    var isEmptyOrWhitespace: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
