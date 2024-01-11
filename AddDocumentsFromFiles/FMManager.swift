//
//  FMManager.swift
//  AddDocumentsFromFiles
//
//  Created by Gökhan Bozkurt on 18.12.2023.
//

import Foundation

class DocumentSaverManager {
    static let instance = DocumentSaverManager()
    let folderName = "added_documents"
    private init() {
        createFolderIfNeeded()
    }
    
   private func createFolderIfNeeded() {
       guard let url = getFolderPath() else { return }
       print(url)
       if !FileManager.default.fileExists(atPath: url.path) {
           do {
               try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
               print("Created folder")
           } catch let error {
               print("Error creating folder:\(error.localizedDescription)")
           }
       }
    }
    
    private func getFolderPath() -> URL? {
        return FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
    }
    
    private func getImagePath(key:String,type: String) -> URL? {
        guard let folder = getFolderPath() else {
            return nil
        }
        return folder.appendingPathComponent(key + ".\(type)")
    }
    
    func add(key: String, value: Data,withType type: String) {
        guard let url = getImagePath(key: key, type: type) else {
                  return
              }
        do {
            try value.write(to: url, options: .completeFileProtection)
        } catch let error {
            print("Error saving to file manager \(error.localizedDescription)")
        }
    }
    
    func copy(key: String, value: URL,withType type: String) {
        guard let url = getImagePath(key: key, type: type) else {
                  return
              }
        do {
            try FileManager.default.copyItem(at: value ,to: url)
            
        } catch let error {
            print("Error saving to file manager \(error.localizedDescription)")
        }
    }
    
    func get(key: String,type: String) -> URL? {
        guard
            let url = getImagePath(key: key, type: type),
            FileManager.default.fileExists(atPath: url.path) else {
                return nil
            }
        return url
    }
}



