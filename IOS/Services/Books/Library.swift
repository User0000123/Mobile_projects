//
//  Library.swift
//  MP
//
//  Created by aleksej on 3/27/24.
//

import Foundation
import Firebase

class Library {
    private var books = [Book]()
    private let dbLibraryReference : DatabaseReference
    private let dbStorage : StorageReference
    private let nPageItems : Int
    private let jsonDecoder : JSONDecoder
    private var viewsUpdater = [() -> Void]()
    public var isSearchedResult = false
    
    init(nPageItems : Int, reloadView: @escaping () -> Void) {
        dbLibraryReference = Database
            .database(url: "https://mpproject-750b8-default-rtdb.europe-west1.firebasedatabase.app")
            .reference(withPath: "Library")
        
        dbStorage = Storage
            .storage(url: "gs://mpproject-750b8.appspot.com")
            .reference(withPath: "images")
        
        self.nPageItems = nPageItems
        viewsUpdater.append(reloadView)
        jsonDecoder = JSONDecoder()
    }
    
    public func subscribeForUpdates(delegate: @escaping ()-> Void)
    {
        viewsUpdater.append(delegate)
    }
    
    public func unsubscribe()
    {
        viewsUpdater.removeLast()
    }
    
    public func getBook(index: Int) -> Book? {
        return books.indices.contains(index) ? books[index] : nil
    }
    
    public func getBooksCount() -> Int {
        return books.count
    }
    
    public func getPageSize() -> Int {
        return nPageItems
    }
    
    private func notifyAllToUpdate()
    {
        DispatchQueue.main.async {
            for delegate in self.viewsUpdater
            {
                delegate()
            }
        }
    }
    
    public func applyFilter(filter: @escaping (Book) -> Bool) {
        isSearchedResult = true
        dbLibraryReference.queryOrderedByKey().getData(completion: { [self]
                error, snapshot in
            books.removeAll()
                do {
                    for jsonBook in snapshot.children.allObjects as! [DataSnapshot] {
                        let book = try jsonDecoder.decode(Book.self, from: JSONSerialization.data(withJSONObject: jsonBook.value!, options: []))
                        if (filter(book)) {
                            books.append(book)
                            
                            dbStorage.child(book.imagesLinks[0]).getData(maxSize: 2 * 1024 * 1024, completion: {
                                data, error in
                                
                                if let imageData = data {
                                    if (book.images == nil) {
                                        book.images = [Data]()
                                    }
                                    book.images!.append(imageData)
                                    notifyAllToUpdate()
                                } else {
                                    print("Error in loading image \(error!.localizedDescription)")
                                }
                            })
                        }
                    }
                } catch {
                    fatalError("Decoding error")
                }
                
            notifyAllToUpdate()
            })
    }
    
    public func loadPage(page: Int) {
        if (page > 3) {
            return
        }
        isSearchedResult = false
        dbLibraryReference.queryOrderedByKey().queryStarting(atValue: "\((page - 1) * nPageItems + 1)").queryLimited(toFirst: UInt(nPageItems)).getData(completion: { [self]
                error, snapshot in
            books.removeAll()
                do {
                    for jsonBook in snapshot.children.allObjects as! [DataSnapshot] {
                        let book = try jsonDecoder.decode(Book.self, from: JSONSerialization.data(withJSONObject: jsonBook.value!, options: []))
                        books.append(book)
                        dbStorage.child(book.imagesLinks[0]).getData(maxSize: 2 * 1024 * 1024, completion: {
                            data, error in
                            
                            if let imageData = data {
                                if (book.images == nil) {
                                    book.images = [Data]()
                                }
                                book.images!.append(imageData)
                                notifyAllToUpdate()
                            } else {
                                print("Error in loading image \(error!.localizedDescription)")
                            }
                        })
                    }
                } catch {
                    fatalError("Decoding error")
                }
                
            notifyAllToUpdate()
            })
    }
}
