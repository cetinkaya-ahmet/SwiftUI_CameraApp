//
//  GalleryScreen.swift
//  CameraApp
//
//  Created by Ahmet Çetinkaya on 19.02.2024.
//

import SwiftUI

struct GalleryScreen: View {
    @EnvironmentObject var dataModel: DataModel
    private static let initialColumns = 4
    @State private var gridColumns = Array(repeating: GridItem(.flexible()), count: initialColumns)
    @Environment(\.dismiss) var dismiss
    
    private var columnsTitle: String {
        gridColumns.count > 1 ? "\(gridColumns.count) Columns" : "1 Column"
    }
    
    var body: some View {
        VStack {
            ScrollView {
                VStack{
                    HStack(alignment: .center){
                        Text("\(dataModel.items.count) " + "Photos")
                        Spacer()
                    }
                    .padding()
                    .frame(height: 50)
                    VStack{
                        LazyVGrid(columns: gridColumns) {
                            ForEach(dataModel.items) { item in
                                GeometryReader { geo in
                                    GridItemView(size: geo.size.width, item: item)
                                }
                                .cornerRadius(8.0)
                                .aspectRatio(1, contentMode: .fit)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .navigationBarItems(leading: NavBackButton(dismiss: self.dismiss))
        .toolbarBackground(Color.blue, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Gallery")
                    .foregroundColor(Color.white)
            }
        }
        .onAppear {
            dataModel.getItems()
        }
    }
}

struct NavBackButton: View {
    let dismiss: DismissAction
    var body: some View {
        Button {
            dismiss()
        } label: {
            Image(systemName: "chevron.left")
                .foregroundColor(Color.white)
            
        }
    }
}

struct GalleryScreen_Previews: PreviewProvider {
    static var previews: some View {
        GalleryScreen()
    }
}
