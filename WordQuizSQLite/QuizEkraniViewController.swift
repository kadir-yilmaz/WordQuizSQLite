//
//  QuizEkraniViewController.swift
//  WordQuizSQLite
//
//  Created by Kadir Yılmaz on 29.01.2023.
//

import UIKit

class QuizEkraniViewController: UIViewController {
    
    @IBOutlet weak var soruSirasiLabel: UILabel!
    @IBOutlet weak var dogruLabel: UILabel!
    @IBOutlet weak var yanlisLabel: UILabel!
    @IBOutlet weak var ingilizceLabel: UILabel!
    @IBOutlet weak var cumleLabel: UITextView!
    
    @IBOutlet weak var butonA: UIButton!
    @IBOutlet weak var butonB: UIButton!
    @IBOutlet weak var butonC: UIButton!
    @IBOutlet weak var butonD: UIButton!
    
    var sorular = [Kelime]()
    var yanlisSecenekler = [Kelime]()
    var dogruSoru = Kelime()
    
    var soruSayac = 0
    var dogruSayac = 0
    var yanlisSayac = 0
    
    var secenekler = [Kelime]()
    var seceneklerKaristirmaListesi = Set<Kelime>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sorular = DBManager().rasgele10SoruGetir(tabloAdi: DBManager.tablo)
        soruYukle()
    }
    

    @IBAction func butonATikla(_ sender: Any) {
        dogruKontrol(button: butonA)
        soruSayacKontrol()
    }
    
    @IBAction func butonBTikla(_ sender: Any) {
        dogruKontrol(button: butonB)
        soruSayacKontrol()
    }
    
    @IBAction func butonCTikla(_ sender: Any) {
        dogruKontrol(button: butonC)
        soruSayacKontrol()
    }
    
    @IBAction func butonDTikla(_ sender: Any) {
        dogruKontrol(button: butonD)
        soruSayacKontrol()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! SonucEkraniViewController
        destination.dogruSayisi = dogruSayac
        
    }
    
    func soruYukle(){
        
        soruSirasiLabel.text = "\(soruSayac + 1). Soru"
        dogruLabel.text = "Doğru : \(dogruSayac)"
        yanlisLabel.text = "Yanlış : \(yanlisSayac)"
        
        dogruSoru = sorular[soruSayac]
        
        ingilizceLabel.text = dogruSoru.ingilizce
        
        cumleLabel.text = dogruSoru.cumle

        
        yanlisSecenekler = DBManager().rasgele3YanlisSecenekGetir(kelimeId: dogruSoru.id!)
        
        seceneklerKaristirmaListesi.removeAll()
        
        seceneklerKaristirmaListesi.insert(dogruSoru)
        seceneklerKaristirmaListesi.insert(yanlisSecenekler[0])
        seceneklerKaristirmaListesi.insert(yanlisSecenekler[1])
        seceneklerKaristirmaListesi.insert(yanlisSecenekler[2])
        
        secenekler.removeAll()
        
        for s in seceneklerKaristirmaListesi {
            secenekler.append(s)
        }
        
        butonA.setTitle(secenekler[0].turkce, for: .normal)
        butonB.setTitle(secenekler[1].turkce, for: .normal)
        butonC.setTitle(secenekler[2].turkce, for: .normal)
        butonD.setTitle(secenekler[3].turkce, for: .normal)
        
    }
    
    func dogruKontrol(button:UIButton){
        
        let secilenCevap = button.titleLabel?.text
        let dogruCevap = dogruSoru.turkce
        
        if dogruCevap == secilenCevap {
            dogruSayac += 1
        }else{
            yanlisSayac += 1
        }
        
        dogruLabel.text = "Doğru : \(dogruSayac)"
        yanlisLabel.text = "Yanlış : \(yanlisSayac)"
        
    }
    
    func soruSayacKontrol(){
        soruSayac += 1
        
        if soruSayac != 10 {
            soruYukle()
        }else{
            performSegue(withIdentifier: "toSonucEkraniVC", sender: nil)
        }
    }
    
}
