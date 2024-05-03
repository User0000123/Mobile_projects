//
//  CommentsStack.swift
//  MP
//
//  Created by aleksej on 4/12/24.
//

import UIKit

class CommentsStack: UIStackView {

    func addComment(author: String, description: String) {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "RowViewController", bundle: bundle)
        let rowView = RowView();
        let view = nib.instantiate(withOwner: rowView, options: nil).first as! UIView
        rowView.addSubview(view)
        rowView.view.author.text = author
        rowView.view.descr.text = description
        addArrangedSubview(rowView)
        
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height + rowView.view.frame.height)
    }
}

class RowView : UIView{
   
    @IBOutlet var view: RowView!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var descr: UILabel!
}
