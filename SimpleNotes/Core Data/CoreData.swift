//
//  CoreData.swift
//  SimpleNotes
//
//  Created by JaredKozar on 12/23/21.
//

import UIKit
import CoreData

let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

func saveTag(currentTag: Tags?, name: String, symbol: String, color: String) {
  
    let newTag = currentTag ?? Tags(context: context)
    newTag.symbol = symbol
    newTag.name = name
    newTag.color = color
    newTag.note = nil
    do {
        try context.save()
    } catch {
        print("An error occured while saving a tag.")
    }
}

func fetchTags() {
    let request = Tags.fetchRequest() as NSFetchRequest<Tags>
    let sort = NSSortDescriptor(key: #keyPath(Tags.name), ascending: true)
    request.sortDescriptors = [sort]
    
    do {
        tags = try context.fetch(request)
    } catch {
        print("Fetch failed")
    }
}

func saveStrokes(strokes: [UIBezierPath], note: Note) {
   
}

func saveTextBoxes(textBoxes: [UITextField], note: Note) {
    var textboxesset = Set<TextBox>()
    
    for textBox in textboxesset {
        let newTextbox = TextBox(context: context)
        textboxesset.insert(newTextbox)
    }
    
    do {
        try context.save()
    } catch {
        print("An error occured while saving a note.")
    }
}

func saveImages(images: [UIImage], note: Note) {
    var imageset = Set<Image>()
    
    for image in images {
        let newImage = Image(context: context)
        let imageAsData = image.jpegData(compressionQuality: 1.0)
        newImage.image = imageAsData
        imageset.insert(newImage)
    }
    
    do {
        try context.save()
    } catch {
        print("An error occured while saving a note.")
    }
}

func createNewNote() {
    let newNote = Note(context: context)
    newNote.date = (UserDefaults.standard.object(forKey: "defaultNoteDate") as? Date)!
    newNote.title = UserDefaults.standard.string(forKey: "defaultNoteTitle")
    newNote.isLocked = false
    newNote.noteID = UUID().uuidString
    newNote.tags = NSSet()
    
    do {
        try context.save()
    } catch {
        print("An error occured while saving a note.")
    }
}

func saveTitle(title: String, index: Int) {
    if notes.indices.contains(index) {
        notes[index].setValue(title, forKey: "title")
    }
    
    do {
        try context.save()
    } catch {
        print("An error occured while saving a note.")
    }
}

func saveDate(date: Date, index: Int) {
    if notes.indices.contains(index) {
        notes[index].setValue(date, forKey: "date")
    }
    
    do {
        try context.save()
    } catch {
        print("An error occured while saving a note.")
    }
}

func saveNoteLock(isLocked: Bool, index: Int) {
    if notes.indices.contains(index) {
        notes[index].setValue(isLocked, forKey: "isLocked")
    }
    
    do {
        try context.save()
    } catch {
        print("An error occured while saving a note.")
    }
}

func fetchNotes(tag: String?, sortOption: sortOptions?) {
    let request = Note.fetchRequest() as NSFetchRequest<Note>
    let sort = NSSortDescriptor(key: sortOption?.sortType, ascending: sortOption!.ascending)
    request.sortDescriptors = [sort]
    
    if tag != nil {
        request.predicate = NSPredicate(format:  "tags.name CONTAINS[c] %@", tag!)
    }

    do {
        
        notes = try context.fetch(request)
    } catch {
        print("Fetch failed")
    }
}

func fetchNoteLockedStatus(index: Int) -> Bool {
    var isLocked: Bool = false
    if notes.indices.contains(index) {
        isLocked = notes[index].value(forKeyPath: "isLocked") as? Bool ?? false
    }
    return isLocked
}

func fetchDate(index: Int) -> Date {
    var date = Date()
    if notes.indices.contains(index) {
        date = (notes[index].value(forKeyPath: "date") as? Date)!
    }
    return date
}

func fetchNoteTitle(index: Int) -> String {
    var title: String = ""
    if notes.indices.contains(index) {
        title = notes[index].value(forKeyPath: "title") as? String ?? ""
    }
    return title
}

func deleteNote(index: Int) {

    context.delete(notes[index])
    do {
        try context.save()
    } catch {
        print("An error occured")
    }
}

func fetchTagsForNote(index: Int) -> [String] {
    guard let context = notes[index].managedObjectContext else {
        fatalError("unable to load managed object context")
    }
    let tagFetchRequest: NSFetchRequest<Tags> = Tags.fetchRequest()
    tagFetchRequest.sortDescriptors = [NSSortDescriptor(key: #keyPath(Tags.name), ascending: true)]
    
    var tagarray = [String]()
    do {
        tagarray = try context.fetch(tagFetchRequest).map({$0.name ?? ""})
    } catch {
        print("An error occured")
    }
    
    return tagarray
}

func deleteTag(tag: Tags) {
    context.delete(tag)
    
    do {
        try context.save()
    } catch {
        print("An error occured")
    }
}
