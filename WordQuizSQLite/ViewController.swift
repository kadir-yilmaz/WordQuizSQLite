//
//  ViewController.swift
//  WordQuizSQLite
//
//  Created by Kadir Yılmaz on 28.01.2023.
//

import UIKit

class ViewController: UIViewController {
        
    let dbm = DBManager()
    
    var listeler = [String]()

    @IBOutlet weak var listeTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        listeTableView.delegate = self
        listeTableView.dataSource = self
        
        listeler = dbm.tabloAdlariAl()
        
    }
    
    
    @IBAction func listeEkle(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Yeni Liste", message: "Eklemek istediğiniz liste adını yazınız.", preferredStyle: .alert)
        
        alertController.addTextField{
            textfield in
            textfield.placeholder = "Listem"
        }
        
        let iptalAction = UIAlertAction(title: "İptal", style: .destructive) {
            action in
            
            self.dismiss(animated: true, completion: nil)
        }
        
        let kaydetAction = UIAlertAction(title: "Kaydet", style: .default){
            action in
                        
            let yeniListe = (alertController.textFields![0] as UITextField).text!
            
            if yeniListe != "" {
                self.dbm.tabloEkle(ad: yeniListe)

            }else{
                let alert = UIAlertController(title: "Uyarı", message: "Liste adı boş olamaz!", preferredStyle: .alert)
                self.present(alert, animated: true, completion: nil)

                // dismiss the alert after 2 seconds
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    alert.dismiss(animated: true, completion: nil)
                }

            }
            
            self.listeler = self.dbm.tabloAdlariAl()
            self.listeTableView.reloadData()
            
        }
        
        alertController.addAction(iptalAction)
        alertController.addAction(kaydetAction)

        self.present(alertController, animated: true)
        
    }
    

}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listeler.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = listeler[indexPath.row]
        cell.contentConfiguration = content
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let listeGetirAction = UIContextualAction(style: .normal, title: "Kelime Listesi"){
                    (UIContextualAction, view, boolValue) in
            
            DBManager.tablo = self.listeler[indexPath.row]
            
            self.performSegue(withIdentifier: "toKelimeListeEkraniVC", sender: nil)
                    
        }
                
        return UISwipeActionsConfiguration(actions: [listeGetirAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let silAction = UIContextualAction(style: .destructive, title: "Sil"){
                    (UIContextualAction, view, boolValue) in
            
            DBManager.tablo = self.listeler[indexPath.row]
            
            let alertController = UIAlertController(title: "Uyarı", message: "Liste silinecek emin misiniz?", preferredStyle: .alert)
            
                        
            let iptalAction = UIAlertAction(title: "İptal", style: .destructive) {
                action in
                
                self.dismiss(animated: true, completion: nil)
            }
            
            let evetAction = UIAlertAction(title: "Evet", style: .default){
                action in
                            
                DBManager().deleteTable(tableName: DBManager.tablo)
                self.listeler = self.dbm.tabloAdlariAl()
                self.listeTableView.reloadData()
            }
            
            alertController.addAction(iptalAction)
            alertController.addAction(evetAction)

            self.present(alertController, animated: true)
            
            
        }
                
        return UISwipeActionsConfiguration(actions: [silAction])
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DBManager.tablo = self.listeler[indexPath.row]
        
        let kayitSayisi = DBManager().kayitSayisiAl()
        print("Kayıt sayısı: \(kayitSayisi)")
        if kayitSayisi >= 10 {
            performSegue(withIdentifier: "toQuizEkraniVC", sender: nil)

        }else{
            let alert = UIAlertController(title: "Uyarı", message: "Kayıt sayısı en az 10 olmalı", preferredStyle: .alert)
            self.present(alert, animated: true, completion: nil)

            // dismiss the alert after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
               alert.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    
}

