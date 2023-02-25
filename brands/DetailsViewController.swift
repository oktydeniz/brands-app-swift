//
//  DetailsViewController.swift
//  markalar
//
//  Created by oktay on 23.02.2023.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var detailText: UITextView!
    var viewController : ViewController?
    
    var desctiption:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailText.text = desctiption
        self.navigationItem.largeTitleDisplayMode = .never
        
    }
    func setDesc(d:String) {
        desctiption = d
        if isViewLoaded {
            detailText.text = desctiption
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewController?.dataDescription = detailText.text
        detailText.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        detailText.becomeFirstResponder()
    }
    

}
