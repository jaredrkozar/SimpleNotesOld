//
//  AccountSettingsViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/21/22.
//

import UIKit

class AccountSettingsViewController: UITableViewController {

    var models = [Sections]()
    
    override func viewDidLoad() {
        let nib = UINib(nibName: "TableRowCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableRowCell")
        
        configure()
        
        title = "Account Settings"

        tableView.rowHeight = 70
    }
    
    func configure() {
        models.append(Sections(title: "Advanced", settings: [
            SettingsOptions(title: "Google Drive", option: "", icon: UIImage(named: "GoogleDrive"), iconBGColor: UIColor(named: "Blue")!, detailViewType: nil) {
                            
                GoogleInteractor().signOut()
                },
                        
            SettingsOptions(title: "Dropbox", option: "", icon: UIImage(named: "Dropbox"), iconBGColor: UIColor(named: "LightBlue")!, detailViewType: nil) {
                  
                    DropboxInteractor().signOut()
                    
                },
        ])
        )
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
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableRowCell", for: indexPath) as? TableRowCell else {
            fatalError("Unable to dequeue the settings cell.")
        }
        
        let model = models[indexPath.section].settings[indexPath.row]
        
        cell.configureCell(with: model)

        return cell
    }
}

extension AccountSettingsViewController: TableRowCellDelegate {
    func buttonTapped(cell: TableRowCell, num: Int?) {
            
        switch num {
            case 0:

                if GoogleInteractor().isSignedIn == true {
                    GoogleInteractor().signOut()
                } else {

                    GoogleInteractor().signIn(vc: self)
                    
                }
            case 1:
            if DropboxInteractor().isSignedIn == true {
                DropboxInteractor().signOut()
        
                } else {
                    DropboxInteractor().signIn(vc: self)
                }
        default:
            return
        }
    }
}
