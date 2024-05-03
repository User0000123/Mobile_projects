//
//  BookDatailedInfoViewController.swift
//  MP
//
//  Created by aleksej on 4/5/24.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class BookDatailedInfoViewController: UIViewController {

    var book: Book?
    weak var library: Library?
    
    private static var dbStorage = Storage
        .storage(url: "gs://mpproject-750b8.appspot.com")
        .reference(withPath: "images")
    
    private static var dbUsers = Database
        .database(url: "https://mpproject-750b8-default-rtdb.europe-west1.firebasedatabase.app")
        .reference(withPath: "Users")
    
    private static var dbComments = Database
        .database(url: "https://mpproject-750b8-default-rtdb.europe-west1.firebasedatabase.app")
        .reference(withPath: "Reviews")
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var ratingsCount: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var titleB: UILabel!
    @IBOutlet weak var authors: UILabel!
    @IBOutlet weak var likeImage: UIImageView!
    @IBOutlet weak var comments: CommentsStack!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initPage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        library?.subscribeForUpdates(delegate: self.setImagesInScroll)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        library?.unsubscribe()
    }
    
    func initPage()
    {
        guard let book = book else {
            return
        }
        
        setImagesInScroll()
        for imageRef in book.imagesLinks[1...] {
            BookDatailedInfoViewController.dbStorage.child(imageRef).getData(maxSize: 2 * 1024 * 1024, completion: { [self]
                data, error in
                
                if let imageData = data {
                    book.images!.append(imageData)
                } else {
                    print("Error in loading image \(error!.localizedDescription)")
                }
                
                setImagesInScroll()
            })
        }
        
        rating.text = String(format: "%.2f", book.rating)
        ratingsCount.text = "(\(book.ratingsNumber) ratings)"
        titleB.text = book.title
        price.text = String(book.price ?? 0)
        authors.text = book.authors.joined(separator: ", ")
        
        likeImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        likeImage.isUserInteractionEnabled = true
        if (SceneDelegate.customUser!.favourites!.contains(book.ID))
        {
            likeImage.image = UIImage(systemName: "heart.fill")
        }
        
        loadComments()
    }
    
    func loadComments()
    {
        let jsonDecoder = JSONDecoder()
        BookDatailedInfoViewController.dbComments.child(book!.ID).getData(completion: {
            error, snapshot in
            do {
                for review in snapshot.children.allObjects as! [DataSnapshot] {
                    let review = try jsonDecoder.decode(Review.self, from: JSONSerialization.data(withJSONObject: review.value!, options: []))
                    
                    DispatchQueue.main.async {
                        self.comments.addComment(author: review.email, description: review.description)
                    }
                }
            } catch {
                fatalError("Decoding error!")
            }
        })
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard ((gestureRecognizer.view as? UIImageView) != nil) else {
            return
        }
        let user = SceneDelegate.customUser
        
        if (user!.favourites!.contains(book!.ID))
        {
            user!.favourites!.remove(at: user!.favourites!.firstIndex(of: book!.ID)!)
            likeImage.image = UIImage(systemName: "heart")
        }
        else
        {
            user!.favourites!.append(book!.ID)
            likeImage.image = UIImage(systemName: "heart.fill")
        }
        
        let email = Auth.auth().currentUser!.email!
        if let range = email.range(of: ".") {
            let substring = email[..<range.lowerBound]
            
            BookDatailedInfoViewController.dbUsers.child(String(substring)).setValue(SceneDelegate.customUser!.getEncoded())
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createReviewSegue" {
            
            if let destinationVC = segue.destination as? CreateReviewViewController {
                destinationVC.book = book!
                destinationVC.user = Auth.auth().currentUser!
                destinationVC.reloadDetailedPage = {
                    for subview in self.comments.arrangedSubviews {
                        self.comments.removeArrangedSubview(subview)
                        subview.removeFromSuperview()
                        }
                    let oldFrame = self.comments.frame
                    self.comments.frame = CGRect(x: oldFrame.origin.x, y: oldFrame.origin.y, width: oldFrame.width, height: 0)
                    
                    self.initPage()  
                }
            }
        }
    }
    
    func setImagesInScroll() {
        let width = self.view.frame.width
        
        scrollView.isPagingEnabled = true
        
        if let images = book?.images {
            var k = CGFloat(0)
            scrollView.contentSize = CGSize.init(width: CGFloat(CGFloat(images.count) * width), height: containerView.frame.height)
            
            for image in images {
                let img = UIImageView.init(image: UIImage.init(data: image))
                
                img.frame = CGRect.init(x: k * width, y: scrollView.frame.origin.y, width: width, height: containerView.frame.height)
                img.contentMode = .scaleAspectFit
                scrollView.addSubview(img)
                k += 1
            }
        }
    }
    
}
