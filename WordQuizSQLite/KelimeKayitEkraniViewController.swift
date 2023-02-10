//
//  KelimeKayitEkraniViewController.swift
//  WordQuizSQLite
//
//  Created by Kadir Yılmaz on 28.01.2023.
//

import UIKit

class KelimeKayitEkraniViewController: UIViewController {
        
    @IBOutlet weak var ingilizceTextField: UITextField!
    @IBOutlet weak var turkceTextField: UITextField!
    @IBOutlet weak var cumleTextView: UITextView!
    @IBOutlet weak var kaydetButon: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kaydetButon.isHidden = true
        
        ingilizceTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        turkceTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
            if ingilizceTextField.text?.isEmpty == true || turkceTextField.text?.isEmpty == true {
                kaydetButon.isHidden = true
            } else {
                kaydetButon.isHidden = false
            }
    }
    

    @IBAction func kaydet(_ sender: Any) {
        
        let ing = ingilizceTextField.text!
        let tur = turkceTextField.text!
        let cum = cumleTextView.text ?? ""
        
        DBManager().kelimeEkle(tabloAdi: DBManager.tablo, ingilizce: "\(ing)", turkce: "\(tur)", cumle: "\(cum)")
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
