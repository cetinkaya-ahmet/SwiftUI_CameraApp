//
//  ImagePickerView.swift
//  CameraApp
//
//  Created by Ahmet Çetinkaya on 19.02.2024.
//

import Foundation
import SwiftUI

struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var capturedImage: UIImage?
    @Binding var didTapCapture: Bool?
    @Binding var flash: Bool
    @Binding var cameraDevice: Int
    
    @Environment(\.presentationMode) var isPresented
    var sourceType: UIImagePickerController.SourceType
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = self.sourceType
        imagePicker.delegate = context.coordinator
        imagePicker.showsCameraControls = false
        
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        let cameraAspectRatio: CGFloat = 4.0 / 3.0
        let imageHeight = screenWidth * cameraAspectRatio
        let scale = ceil((screenHeight / imageHeight) * 10.0) / 10.0
        var transform = CGAffineTransform(translationX: 0, y: (screenHeight - imageHeight) / 2)
        transform = transform.scaledBy(x: scale, y: scale)
        imagePicker.cameraViewTransform = transform
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        if (didTapCapture == true){
            uiViewController.takePicture()
        }
        if(flash == true){
            uiViewController.cameraFlashMode = .on
        }else{
            uiViewController.cameraFlashMode = .off
        }
        if(cameraDevice == Camera.Rear.rawValue){
            uiViewController.cameraDevice = .rear
        }else{
            uiViewController.cameraDevice = .front
        }
    }

    // Connecting the Coordinator class with this struct
    func makeCoordinator() -> Coordinator {
        return Coordinator(picker: self)
    }
}
