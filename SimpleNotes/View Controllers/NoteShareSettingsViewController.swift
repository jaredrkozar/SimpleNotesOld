//
//  NoteShareSettingsViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/8/22.
//

import UIKit
import GoogleSignIn

class NoteShareSettingsViewController: UITableViewController {
    var getNoteData: ((_ exportType: SharingType)->(Data))?
    private var filesExport = UIDocumentBrowserViewController()
    private var models = [Sections]()
    var format: SharingType?
    var currentNoteTitle: String?
    var currentNoteView: UIViewController!
    var sharingLocation: SharingLocation?
    
    let google = GoogleInteractor()
    let dropbox = DropboxInteractor()
    
    var folderID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), style: .insetGrouped)
        tableView.register(TableRowCell.self, forCellReuseIdentifier: TableRowCell.identifier)
        configure()
        
        title = "Settings"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: sharingLocation?.buttonMessage, style: .done, target: self, action: #selector(uploadNote))
        
    }

    func configure() {
        models.append(Sections(title: "Format", settings: [
            SettingsOptions(title: "PDF", option: "", rowIcon: nil, control: nil) {
                
                self.format = .pdf
            },
            SettingsOptions(title: "Image", option: "", rowIcon: nil, control: nil) {
                
                self.format = .image
            }
        ]))
        
        models.append(Sections(title: "Location", settings: [
            SettingsOptions(title: "Folder", option: "", rowIcon: nil, control: nil) {
                
                if self.sharingLocation?.currentLocation.isSignedIn == false {
                    self.sharingLocation?.currentLocation.signIn(vc: self)
                           } else {
                               let vc = FolderLocationViewController()
                              let navController = UINavigationController(rootViewController: vc)
                               vc.location = self.sharingLocation
                               vc.currentfolder = self.sharingLocation?.currentLocation.defaultFolder
                               vc.serviceType = .upload
                               self.navigationController?.present(navController, animated: true, completion: nil)
                           }
             },
        ]))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return  models.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return models[section].settings.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].settings[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableRowCell.identifier, for: indexPath) as? TableRowCell else {
            fatalError("Unable to dequeue the settings cell.")
        }
        
        cell.configureCell(with: model)
        
        if  models[1].settings[0].title == "Folder" {
         // Own Account
           cell.accessoryType = .none
           //cell.backgroundColor = UIColor.red
        }else{
         //Guest Account
            cell.accessoryType = .checkmark
        }
       
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let model = models[indexPath.section].settings[indexPath.row]
        
        model.handler!()
    }

    func showSettingsPage(viewController: UIViewController) {
        switch currentDevice {
        case .iphone:
            show(viewController, sender: true)
        case .ipad, .mac:
            splitViewController?.setViewController(viewController, for: .secondary)
        case .none:
            return
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func uploadNote() {
        let noteData = self.getNoteData!(format ?? .pdf)
        
        switch sharingLocation {
        case .googledrive,.dropbox:
            sharingLocation?.currentLocation.uploadFile(note: noteData, noteName: currentNoteTitle!, noteFormat: format ?? .pdf, folderID: folderID, onCompleted: {_,_ in
                print("slsl")
            })
        case .files:
            let dataAsURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(String(describing: currentNoteTitle!)).\(format!.dropboxFileType)")
            try! noteData.write(to: dataAsURL)
    
            let documentController = UIDocumentPickerViewController(forExporting: [dataAsURL])
            present(documentController, animated: true)
        case .email:
            sendEmail(noteTitle: currentNoteTitle!, notePDF: noteData)
        case .messages:
            sendText(noteTitle: currentNoteTitle!, notePDF: noteData)
        case .print:
            let printInfo = UIPrintInfo(dictionary: nil)
            printInfo.jobName = currentNoteTitle!
            
            let printController = UIPrintInteractionController()
            printController.printingItem = currentNoteView
             printController.showsNumberOfCopies = false

            printController.present(animated: true)
        default:
            print("This export type is not supported")
        }
    } 
}
