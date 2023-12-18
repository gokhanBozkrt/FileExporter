//
//  SavedDocumentsVM.swift
//  AddDocumentsFromFiles
//
//  Created by Gökhan Bozkurt on 19.12.2023.
//

import Foundation

class SavedDocumentsVM: ObservableObject {
    
    let defaults = UserDefaults.standard
    @Published var savedFiles = [String:String]()
    
    init() {
        getFileDetails()
    }
    
    func saveFileDetails() {
        defaults.setValue(savedFiles, forKey: "saveDocuments")
    }
    
    func getFileDetails() {
        savedFiles = defaults.dictionary(forKey: "saveDocuments") as? [String: String] ?? [String:String]()
    }
}
