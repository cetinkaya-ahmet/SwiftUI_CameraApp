//
//  CameraScreen.swift
//  CameraApp
//
//  Created by Ahmet Çetinkaya on 19.02.2024.
//

import Foundation
import SwiftUI

struct CameraScreen: View {
    @State private var capturedImage: UIImage?
    @State private var signedImage: UIImage?
    @State private var showCapturedImage = false
    @State private var didTapCapture: Bool? = false
    @State private var flash: Bool = false
    @State private var cameraDevice: Int = 0 // 0 -> Rear 1 -> front
    @ObservedObject var dataModel: DataModel = DataModel()
    @State private var showingPurchaseScreen = false
    @State private var needToForceUpdate = false
    
    var body: some View {
        VStack{
            ImagePickerView(capturedImage: self.$capturedImage,
                            didTapCapture: self.$didTapCapture,
                            flash: self.$flash,
                            cameraDevice: self.$cameraDevice,
                            sourceType: .camera
            )
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            .overlay(
                VStack{
                    HStack(alignment: .bottom){
                        Image(systemName: flash ? "bolt.fill" : "bolt.slash.fill")
                            .foregroundColor(.white)
                            .onTapGesture {
                                flash.toggle()
                            }
                    }
                    .padding()
                    .padding(.top, 48)
                    .padding(.horizontal, 8)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height*0.1)
                    .background(Color.orange.opacity(0.70))
                    
                    
                    Spacer()
                    HStack{
                        NavigationLink(destination: GalleryScreen()){
                            if(capturedImage != nil){
                                Image(uiImage: capturedImage!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(10)
                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white, lineWidth: 3))
                            }else{
                                AsyncImage(url: dataModel.getFirstItem()?.url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 60, height: 60)
                                        .cornerRadius(10)
                                        .overlay(RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 3))
                                } placeholder: {
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(8)
                                        .frame(width: 60, height: 60)
                                        .overlay(RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 3))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                        }
                        Spacer()
                        Button {
                            didTapCapture = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                didTapCapture = false
                            }
                       } label: {
                           Label {} icon: {
                               ZStack {
                                   Circle()
                                       .strokeBorder(.white, lineWidth: 2)
                                       .frame(width: 72, height: 72)
                                   Circle()
                                       .fill(Color.white)
                                       .frame(width: 60, height: 60)
                               }
                           }
                       }
                        Spacer()
                        
                        Button {
                            if(cameraDevice == 0){ cameraDevice = 1} else{cameraDevice = 0}
                        } label: {
                            ZStack(alignment: .center) {
                                Circle()
                                    .fill(Color("Gray").opacity(0.5))
                                    .frame(width: 48, height: 48)
                                Image(systemName: "arrow.triangle.2.circlepath.camera")
                                    .foregroundColor(.white)
                            }.frame(width: 60, height: 60)
                        }
                    }
                    .padding()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/6)
                    .background(Color.orange.opacity(0.70))
                    
                }
            )
        }
        .onChange(of: capturedImage) { newValue in
            if(newValue != nil){
                showCapturedImage = true
            }
        }
       
        .onAppear(perform: {
            dataModel.getItems()

        })
        .ignoresSafeArea()
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
                
    }
}

struct CameraScreen_Previews: PreviewProvider {
    static var previews: some View {
        CameraScreen()
    }
}
