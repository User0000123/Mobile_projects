//
//  BooksPageController.swift
//  MP
//
//  Created by aleksej on 3/11/24.
//

import UIKit

class BooksPageController: UIViewController {
    
    internal var library : Library?
    internal var currentPage = 1
    internal var selectedCellIndex = 0
    @IBOutlet weak var uiTableView: UITableView!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiTableView.dataSource = self
        uiTableView.delegate = self
        
        library = Library(nPageItems: 10, reloadView: uiTableView.reloadData)
        library!.loadPage(page: currentPage)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Perform actions when the view is about to appear
        if navigationController?.viewControllers.first == self {
            navigationController?.setNavigationBarHidden(true, animated: true )
        }
    }
        
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Perform actions when the view is about to disappear
        if navigationController?.viewControllers.first == self {
            navigationController?.setNavigationBarHidden(false , animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailBookPage" {
            
            if let destinationVC = segue.destination as? BookDatailedInfoViewController {
                destinationVC.book = library?.getBook(index: selectedCellIndex)
                destinationVC.library = library
            }
        }
        else if (segue.identifier == "openFilter") {
            
            if let destinationVC = segue.destination as? FilterViewController {
                destinationVC.library = library
            }
        }
    }
}

extension BooksPageController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (library?.getBooksCount() ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IDcustomCell", for: indexPath) as! CustomTableViewCell
        
        guard let library = library else {
            return cell
        }
        
        if let book = library.getBook(index: indexPath.item) {
            cell.lBookAuthors.text = book.authors.joined(separator: ", ")
            cell.lBookPrice.text = book.price != nil ? "$ \(book.price!)" : "Not available for sale"
            cell.lBookRating.text = String(format: "%.2f", book.rating)
            cell.lBookTitle.text = book.title
            
            if let images = book.images {
                cell.lBookPreview.image = UIImage(data: images[0])
            }
        }

        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let library = library else {
            return
        }
        
        let contentHeight = scrollView.contentSize.height
        let tableViewHeight = scrollView.bounds.height
        let offsetY = scrollView.contentOffset.y

        if (!library.isSearchedResult) {
            if (offsetY > contentHeight - tableViewHeight && contentHeight > tableViewHeight) {
                if (currentPage < 3 && currentPage > 0) {
                    uiTableView.isUserInteractionEnabled = false
                    uiTableView.isScrollEnabled = false
                    uiTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                    currentPage += 1
                    library.loadPage(page: currentPage)
                    uiTableView.isScrollEnabled = true
                    uiTableView.isUserInteractionEnabled = true
                }
            }
            
            if scrollView.contentOffset.y < 0 && !scrollView.isDragging {
                if (currentPage > 1) {
                    uiTableView.isUserInteractionEnabled = false
                    uiTableView.isScrollEnabled = false
                    scrollView.contentOffset.y = 0
                    uiTableView.scrollToRow(at: IndexPath(row: library.getPageSize() - 1, section: 0), at: .bottom, animated: true)
                    currentPage -= 1
                    library.loadPage(page: currentPage)
                    uiTableView.isScrollEnabled = true
                    uiTableView.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedCellIndex = indexPath.row
        return indexPath
    }
}


extension BooksPageController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let textToSearch = searchBar.text else {
            return
        }
        
        if (!textToSearch.isEmpty) {
            library?.applyFilter {
                book in
                return book.title.contains(textToSearch)
            }
        } else {
            library?.loadPage(page: 1)
        }
    }
}
