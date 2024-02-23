//
//  Document.swift
//  CameraApp
//
//  Created by Ahmet Çetinkaya on 23.02.2024.
//

import Foundation

struct Document: Identifiable {
    let id = UUID()
    let url: URL
    let createDate : Date?
}
