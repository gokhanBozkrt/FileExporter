//
//  ContentView.swift
//  AddDocumentsFromFiles
//
//  Created by Gökhan Bozkurt on 18.12.2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var fileVM = SavedDocumentsVM()
    
    @State private var showImporting = false
    @State private var selecteDocumentUrls = [URL]()
    
    
    @State private var showQuickLook = false
    
    var body: some View {
        
        NavigationStack {
            List {
                ForEach(fileVM.savedFiles.keys.sorted(),id: \.self) { key in
                    NavigationLink {
                        let type = fileVM.savedFiles[key]
                        let url = PhotoModelFileManager.instance.get(key: key, type: type!)!
                       PreviewController(url: url)
                    } label: {
                        Text(key)
                    }

                }
              
            }
            .navigationTitle("File Kayıt")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showImporting.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                      }
                  }
            .fileImporter(
               isPresented: $showImporting,
               allowedContentTypes: [.pdf,.png,.audio,.avi,.mp3,.contact,.wav,.text,.svg,.plainText,.mpeg4Movie,.movie,.mpeg,.emailMessage,.commaSeparatedText,.epub,.image,.spreadsheet,.content],allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let file):
                    selecteDocumentUrls = file
                    guard selecteDocumentUrls[0].startAccessingSecurityScopedResource() else {
                        print("Güvenlik Hatası")
                        return
                    }
                    
                    
                     let fileType = selecteDocumentUrls[0].pathExtension
                    let fileName = selecteDocumentUrls[0].deletingPathExtension().lastPathComponent
                    
                    let data = try? Data(contentsOf: selecteDocumentUrls[0])
                    
                    fileVM.savedFiles[fileName] = fileType
                    fileVM.saveFileDetails()
                    
                    PhotoModelFileManager.instance.add(key: fileName, value: data!, withType: fileType)
                    
                
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
       
    }
}

#Preview {
    ContentView()
}

