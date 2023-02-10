//
//  KelimeDuzenlemeEkraniViewController.swift
//  WordQuizSQLite
//
//  Created by Kadir Yılmaz on 29.01.2023.
//

import UIKit

class KelimeDuzenlemeEkraniViewController: UIViewController {
    
    @IBOutlet weak var ingilizceTextField: UITextField!
    @IBOutlet weak var turkceTextField: UITextField!
    @IBOutlet weak var cumleTextView: UITextView!
    @IBOutlet weak var kaydetButon: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingilizceTextField.text = KelimeListeEkraniViewController.duzenlenenKelimeIngilizce
        turkceTextField.text = KelimeListeEkraniViewController.duzenlenenKelimeTurkce
        cumleTextView.text = KelimeListeEkraniViewController.duzenlenenKelimeCumle
        
        
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
        DBManager().kelimeGuncelle(tabloAdi: DBManager.tablo, eskiIngilizce: KelimeListeEkraniViewController.duzenlenenKelimeIngilizce!, yeniIngilizce: ingilizceTextField.text!, yeniTurkce: turkceTextField.text!, yeniCumle: cumleTextView.text)
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
