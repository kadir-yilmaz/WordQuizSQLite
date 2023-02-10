//
//  SonucEkraniViewController.swift
//  WordQuizSQLite
//
//  Created by Kadir Yılmaz on 29.01.2023.
//

import UIKit

class SonucEkraniViewController: UIViewController {
    
    @IBOutlet weak var sonucLabel: UILabel!
    
    var dogruSayisi: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true
        
        if let d = dogruSayisi {
            sonucLabel.text = "\(d) Doğru \(10-d) Yanlış"
        }
    }
    
    @IBAction func tekrarDene(_ sender: Any) {
        
        navigationController?.popToRootViewController(animated: true)

    }

}
