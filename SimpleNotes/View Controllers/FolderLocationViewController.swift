//
//  FolderLocationViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/10/22.
//

import UIKit

class FolderLocationViewController: UITableViewController {

    @IBOutlet var selectFolderButton: CustomButton!
    var location: SharingLocation?
    var currentfolder: String?
    var allFiles = [CloudServiceFiles]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Folders"
        
        let nib = UINib(nibName: "TableRowCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableRowCell")
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if location == .googledrive {
            GoogleInteractor().fetchFiles(folderID: currentfolder ?? "root", onCompleted: {
                (files, error) in
                self.allFiles = files!
                print(self.allFiles.count)
                self.tableView.reloadData()
                
            })
        } else if location == .dropbox {
            DropboxInteractor().fetchFiles(folderID: currentfolder ?? "", onCompleted: {
                (files, error) in
                self.allFiles = files!
                
            })
        }
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return allFiles.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableRowCell", for: indexPath) as? TableRowCell else {
            fatalError("Unable to dequeue the note cell.")
        }
         
        let file = allFiles[indexPath.row]
        cell.logOutButton.isHidden = true
        cell.name.text = file.name
        cell.icon.image = file.type.icon
        cell.background.backgroundColor = UIColor.clear
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
