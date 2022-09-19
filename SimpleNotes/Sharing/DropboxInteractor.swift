//
//  DropboxInteractor.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/20/22.
//

import UIKit
import SwiftyDropbox

class DropboxInteractor: APIInteractor {
    var defaultFolder: String = "/"
    
    
    var filesInFolder = [CloudServiceFiles]()
    let client = DropboxClientsManager.authorizedClient

    func fetchFiles(folderID: String, onCompleted: @escaping ([CloudServiceFiles]?, Error?) -> ()) {
        
        client!.files.listFolder(path: "").response { [self] response, error in
            if let result = response {
        
                for file in result.entries {
                    var isFolder: Bool = true
                    
                    if file is Files.FileMetadata {
                        isFolder = false
                    }
                
                    self.filesInFolder.append(CloudServiceFiles(name: file.name, type: self.getFileType(type: file.name), folderID: file.pathLower!))
                }
                
                onCompleted(self.filesInFolder, nil)
                
            }
        }

            
    }
    
    func signIn(vc: UIViewController) {
        let scopeRequest = ScopeRequest(scopeType: .user, scopes: [], includeGrantedScopes: false)
            DropboxClientsManager.authorizeFromControllerV2(
                UIApplication.shared,
                controller: vc,
                loadingStatusDelegate: nil,
                openURL: { (url: URL) -> Void in UIApplication.shared.open(url, options: [:], completionHandler: nil) },
                scopeRequest: scopeRequest
            )
    }
    
    var isSignedIn: Bool {
        if DropboxClientsManager.authorizedClient == nil {
            return false
        } else {
            return true
        }
        
    }
    
    func signOut() {
        DropboxClientsManager.unlinkClients()
    }
    
    func uploadFile(note: Data, noteName: String, folderID: String?, onCompleted: @escaping (Double, String?) -> ()) {
        var progress: Double?
        let newPath = folderID! + "/\(noteName).pdf"
        client?.files.upload(path: newPath, mode: .add, autorename: true, clientModified: nil, mute: false, input: note)
            
            .progress { progressData in
                progress = progressData.fractionCompleted
                print(progress)
            }
        
            .response(queue: DispatchQueue.global(qos: .userInteractive), completionHandler: { response, error in
                if let _ = response {
                    onCompleted(progress ?? 0.0, "D")
                }
               
            })
    }
    
    
    func getFileType(type: String) -> MimeTypes {
        let type = (type as NSString).pathExtension

        switch type {
            case "txt", "md", "html":
            return .document
            case "xlxs", "xls", "xlm", "xl", "gsheet":
            return .spreadsheet
            case "pdf":
            return .pdf
            case "ppt", "pptx", "pptm", "gslides":
            return .presentation
            case "mp3", "m4a", "flac", "mp4", "wav":
            return .audiofile
            default:
            return .other
        }
        
    }
}
