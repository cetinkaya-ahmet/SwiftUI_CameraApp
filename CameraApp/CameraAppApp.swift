//
//  CameraAppApp.swift
//  CameraApp
//
//  Created by Ahmet Çetinkaya on 19.02.2024.
//

import SwiftUI

@main
struct CameraAppApp: App {
    @StateObject
    private var dataModel = DataModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView(content: {
                CameraScreen()
                    
            })
            
            .environmentObject(dataModel)
            
        }
    }
}
