//
//  CreateReviewViewController.swift
//  MP
//
//  Created by aleksej on 4/6/24.
//

import UIKit
import Firebase

class CreateReviewViewController: UIViewController {

    @IBOutlet var desc: UITextView!
    @IBOutlet var starImageViews: [UIImageView]!
    
    private var filledStars = 1
    var book: Book?
    var user: User?
    var reloadDetailedPage: (() -> Void)?
    
    private let dbReference = Database
        .database(url: "https://mpproject-750b8-default-rtdb.europe-west1.firebasedatabase.app")
        .reference(withPath: "Reviews")
    private let dbBooks = Database
        .database(url: "https://mpproject-750b8-default-rtdb.europe-west1.firebasedatabase.app")
        .reference(withPath: "Library")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initStarsSubviews()
        setStarCount()
    }
    
    @objc func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let tappedImageView = gestureRecognizer.view as? UIImageView else {
            return
        }
        
        filledStars = starImageViews.firstIndex(of: tappedImageView)! + 1
        setStarCount()
    }
    
    func initStarsSubviews() {
       for view in starImageViews {
        view.image = UIImage.init(systemName: "star")
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
       }
    }
    
    func setStarCount() {
       if filledStars < 1 {return}
       for index in 0...filledStars-1 {
        starImageViews[index].image = UIImage.init(systemName: "star.fill")
       }
        if filledStars == 5 {
            return
        }
        
        for index in filledStars...4 {
            starImageViews[index].image = UIImage.init(systemName: "star")
        }
    }
    
    @IBAction func sendReview() {
        let review = Review(email: user!.email!, description: desc.text)
        let nRatings = book!.ratingsNumber
        let newRating = (Double(nRatings) * book!.rating + Double(filledStars))/(Double(nRatings) + Double(1))
        
        dbBooks.child(book!.ID).child("rating").setValue(newRating)
        dbBooks.child(book!.ID).child("ratingsNumber").setValue(nRatings + 1)
        dbReference.child(book!.ID).childByAutoId().setValue(review.getEncoded())
        
        book?.rating = newRating
        book?.ratingsNumber = nRatings + 1
        
        reloadDetailedPage?()
    }
}
