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
        if(documents == nil || documents.isEmpty){
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

extension URL {
    /// Indicates whether the URL has a file extension corresponding to a common image format.
    var isImage: Bool {
        let imageExtensions = ["jpg", "jpeg", "png", "gif", "heic"]
        return imageExtensions.contains(self.pathExtension)
    }
}

struct Document: Identifiable {
    let id = UUID()
    let url: URL
    let createDate : Date?
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

extension URL {
    /// The time at which the resource was created.
    /// This key corresponds to an Date value, or nil if the volume doesn't support creation dates.
    /// A resource’s creationDateKey value should be less than or equal to the resource’s contentModificationDateKey and contentAccessDateKey values. Otherwise, the file system may change the creationDateKey to the lesser of those values.
    var creation: Date? {
        get {
            return (try? resourceValues(forKeys: [.creationDateKey]))?.creationDate
        }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.creationDate = newValue
            try? setResourceValues(resourceValues)
        }
    }
    /// The time at which the resource was most recently modified.
    /// This key corresponds to an Date value, or nil if the volume doesn't support modification dates.
    var contentModification: Date? {
        get {
            return (try? resourceValues(forKeys: [.contentModificationDateKey]))?.contentModificationDate
        }
        set {
            var resourceValues = URLResourceValues()
            resourceValues.contentModificationDate = newValue
            try? setResourceValues(resourceValues)
        }
    }
    /// The time at which the resource was most recently accessed.
    /// This key corresponds to an Date value, or nil if the volume doesn't support access dates.
    ///  When you set the contentAccessDateKey for a resource, also set contentModificationDateKey in the same call to the setResourceValues(_:) method. Otherwise, the file system may set the contentAccessDateKey value to the current contentModificationDateKey value.
    var contentAccess: Date? {
        get {
            return (try? resourceValues(forKeys: [.contentAccessDateKey]))?.contentAccessDate
        }
        // Beginning in macOS 10.13, iOS 11, watchOS 4, tvOS 11, and later, contentAccessDateKey is read-write. Attempts to set a value for this file resource property on earlier systems are ignored.
        set {
            var resourceValues = URLResourceValues()
            resourceValues.contentAccessDate = newValue
            try? setResourceValues(resourceValues)
        }
    }
}
