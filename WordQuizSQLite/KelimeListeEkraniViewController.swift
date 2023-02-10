//
//  KelimeListeEkraniViewController.swift
//  WordQuizSQLite
//
//  Created by Kadir Yılmaz on 28.01.2023.
//

import UIKit

class KelimeListeEkraniViewController: UIViewController {
    
    var aramaYapiliyorMu = false
    var arananKelime = ""
    
    var kelimeListesi = [Kelime]()
    
    static var duzenlenenKelimeIngilizce: String?
    static var duzenlenenKelimeTurkce: String?
    static var duzenlenenKelimeCumle: String?

    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var kelimeListeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kelimeListeTableView.delegate = self
        kelimeListeTableView.dataSource = self
        
        searchBar.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if aramaYapiliyorMu {
            kelimeListesi = DBManager().aramaYap(ingilizce: arananKelime)
        }else{
            kelimeListesi = DBManager().tumKelimeleriAl()
        }
        
        kelimeListeTableView.reloadData()

    }
    
}

extension KelimeListeEkraniViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kelimeListesi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let kelime = kelimeListesi[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! KelimeTableViewCell
        
        cell.ingilizceLabel.text = kelime.ingilizce
        cell.cumleTextView.text = kelime.cumle
        cell.turkceLabel.text = kelime.turkce
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        
        let duzenleAction = UIContextualAction(style: .normal, title: "Kelime Düzenle"){
                    (UIContextualAction, view, boolValue) in
                        
            KelimeListeEkraniViewController.duzenlenenKelimeIngilizce = self.kelimeListesi[indexPath.row].ingilizce
            
            KelimeListeEkraniViewController.duzenlenenKelimeTurkce = self.kelimeListesi[indexPath.row].turkce
            
            KelimeListeEkraniViewController.duzenlenenKelimeCumle = self.kelimeListesi[indexPath.row].cumle
            
            
            self.performSegue(withIdentifier: "toKelimeDuzenlemeEkraniVC", sender: nil)
                    
        }
                
        return UISwipeActionsConfiguration(actions: [duzenleAction])
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let silAction = UIContextualAction(style: .destructive, title: "Sil"){
                    (UIContextualAction, view, boolValue) in
            
            let kelime = self.kelimeListesi[indexPath.row]
            
            DBManager().kelimeSil(ingilizce: kelime.ingilizce!)
            
            self.kelimeListesi = DBManager().tumKelimeleriAl()
            self.kelimeListeTableView.reloadData()

                                
        }
                
        return UISwipeActionsConfiguration(actions: [silAction])
        
    }
    
}

extension KelimeListeEkraniViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        arananKelime = searchText
        print("arama sonucu: \(searchText)")
        
        if searchText == "" {
            aramaYapiliyorMu = false
            kelimeListesi = DBManager().tumKelimeleriAl()
        }else{
            aramaYapiliyorMu = true
            kelimeListesi = DBManager().aramaYap(ingilizce: searchText)
        }
        
        kelimeListeTableView.reloadData()
    }
    
}
