//
//  FilterViewController.swift
//  MP
//
//  Created by aleksej on 4/14/24.
//

import UIKit

class FilterViewController: UIViewController {

    internal var library : Library?
    @IBOutlet weak var startPrice: UITextField!
    @IBOutlet weak var finalPrice: UITextField!
    @IBOutlet weak var searchWithoutReviews: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func filtersApply()
    {
        let startPriceP = Double(startPrice.text!) ?? Double(0)
        let finalPriceP = Double(finalPrice.text!) ?? Double(9999)
        let isSearchWithoutReviews = searchWithoutReviews.isOn
        
        library?.applyFilter {
            book in
            
            var result = true
            
            result = result && (book.price! >= startPriceP && book.price! <= finalPriceP)
            
            if (isSearchWithoutReviews)
            {
                result = result && book.ratingsNumber == 0
            }
            
            return result
        }
    }
}
