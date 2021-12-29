//
//  ReusableDocumentsTableView.swift
//  VisionText
//
//  Created by JaredKozar on 12/16/21.
//

import UIKit
import WSTagsField

class ReusableTableView: NSObject, UITableViewDataSource, UITableViewDelegate {

    var note = [Note]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as? NoteTableViewCell else {
            fatalError("Unable to dequeue the image cell.")
        }
        
        let singlenote = note[indexPath.row]

        cell.noteTitle.text = singlenote.title

        cell.noteText.text = singlenote.text
        cell.noteDate.text = singlenote.date!.formatted()
        
        cell.noteTags.addTags(singlenote.tags!)
       
        cell.accessibilityLabel = "\(singlenote.title) Created on \(singlenote.date)"
        
        cell.layoutIfNeeded()
        return cell
    }

}
