//
//  Item.swift
//  CameraApp
//
//  Created by Ahmet Çetinkaya on 19.02.2024.
//

import SwiftUI

struct Item: Identifiable {

    let id = UUID()
    let url: URL
    let createDate : Date?

}

extension Item: Equatable {
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.id == rhs.id && lhs.id == rhs.id
    }
}
