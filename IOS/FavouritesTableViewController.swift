//
//  BooksPageController.swift
//  MP
//
//  Created by aleksej on 3/11/24.
//

import UIKit

class FavouritesViewController: BooksPageController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiTableView.dataSource = self
        uiTableView.delegate = self
        
        library = Library(nPageItems: 10, reloadView: uiTableView.reloadData)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Perform actions when the view is about to appear
        if navigationController?.viewControllers.first == self {
            navigationController?.setNavigationBarHidden(true, animated: true )
        }
        
        library!.applyFilter {
            book in
            return SceneDelegate.customUser!.favourites!.contains(book.ID)
        }
    }
}
