//
//  DataModel.swift
//  CameraApp
//
//  Created by Ahmet Çetinkaya on 19.02.2024.
//

import Foundation
import SwiftUI
import Photos

class DataModel: ObservableObject {
    @Published var items: [Item] = []
    
    init(){
        getItems()
    }
    
    func getItems(){
        items.removeAll()
        let documents = getImagesOnDocumentDirectoryOrderByCreateDate().filter { $0.url.isImage }
        for doc in documents {
            let item = Item(url: doc.url, createDate: doc.createDate )
            items.append(item)
        }
    }
    
    
    func getFirstItem() -> Item?{
        let documents = getImagesOnDocumentDirectoryOrderByCreateDate().filter { $0.url.isImage }
        if(documents.isEmpty){
            return nil
        }
        let firstDocument = documents.first!
        let item = Item(url: firstDocument.url, createDate: firstDocument.createDate )
        return item
    }
    
    /// Adds an item to the data collection.
    func addItem(_ item: Item) {
        items.insert(item, at: 0)
    }
    
    /// Removes an item from the data collection.
    func removeItem(_ item: Item) {
        do{
            try FileManager.default.removeItem(atPath: item.url.path)
            self.items = items.filter { $0.url != item.url }
        }catch{
            print("remove error")
        }
    }
}



func getImagesOnDocumentDirectoryOrderByCreateDate() -> [Document]{
    var documents : [Document] = []
    let fileManager = FileManager.default
    let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
//    let directoryURL = documentsURL.appendingPathComponent(directoryName)
    do {
        var fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
        fileURLs.sort{ (($0.creation)?.compare($1.creation!))! == .orderedDescending }
        fileURLs.forEach { url in
            documents.append(Document(url: url, createDate: url.creation))
        }
        return documents
        // process files
    } catch {
        print(error)
        return []
    }
}


