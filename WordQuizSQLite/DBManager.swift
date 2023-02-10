//
//  DBManager.swift
//  WordQuizSQLite
//
//  Created by Kadir Yılmaz on 28.01.2023.
//

import Foundation
import SQLite

class DBManager {
    
    static var tablo = "colors"
    
    var db: Connection?
    
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

    var tabloAdlari = [String]()
    
    init() {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        print(path)
            do{
                db = try Connection("\(path)/kelimeler.sqlite3")
                let tables = try db!.prepare( "SELECT name FROM sqlite_master WHERE type='table'")
                for table in tables {
                    tabloAdlari.append(table[0] as! String)
                }
            } catch {
                print(error)
            }
    }
    
    func tabloAdlariAl() -> [String] {
        var tabloAdlari = [String]()
        do {
            let query = "SELECT name FROM sqlite_master WHERE type='table'"
            for row in try db!.prepare(query) {
                tabloAdlari.append(row[0] as! String)
            }
        } catch {
            print("Error: \(error)")
        }
        return tabloAdlari
    }

    
    func tabloEkle(ad: String){
        
        let tablo = Table(ad)
        let id = Expression<Int64>("id")
        let ingilizce = Expression<String>("ingilizce")
        let turkce = Expression<String>("turkce")
        let cumle = Expression<String>("cumle")
        
        do{
            db = try Connection("\(path)/kelimeler.sqlite3")
            
            
            try db!.run(tablo.create(temporary: false, ifNotExists: true, block: {
                t in
                t.column(id,primaryKey:true)
                t.column(ingilizce)
                t.column(turkce)
                t.column(cumle)
            }))
        }
        catch{
            print("HATA \(error)")
        }
    }
    
    func kelimeEkle(tabloAdi: String, ingilizce: String, turkce: String, cumle: String){
            let tablo = Table(tabloAdi)
            let ing = Expression<String>("ingilizce")
            let tr = Expression<String>("turkce")
            let cum = Expression<String>("cumle")
            do{
                try db!.run(tablo.insert(ing <- ingilizce, tr <- turkce, cum <- cumle))
            }
            catch{
                print("HATA \(error)")
            }
    }
    
    func kelimeGuncelle(tabloAdi: String, eskiIngilizce: String, yeniIngilizce: String, yeniTurkce: String, yeniCumle: String) {
        let tablo = Table(tabloAdi)
        let ing = Expression<String>("ingilizce")
        let tr = Expression<String>("turkce")
        let cum = Expression<String>("cumle")
        
        do {
                try db!.run(tablo.filter(ing == eskiIngilizce).update(ing <- yeniIngilizce, tr <- yeniTurkce, cum <- yeniCumle))
            } catch {
                print("HATA \(error)")
            }
    }


    
    func tumKelimeleriAl() -> [Kelime] {
        
        var liste = [Kelime]()
        
        do {
            let kelimeler = try db!.prepare("SELECT * FROM \(String(describing: DBManager.tablo))")
                for kelime in kelimeler {
                    let yeniKelime =  Kelime(id: Int(kelime[0] as! Int64) , ingilizce: kelime[1] as! String, turkce: kelime[2] as! String, cumle: kelime[3] as? String ?? "")
                    liste.append(yeniKelime)
                }
            } catch  {
                print("HATA:\(error.localizedDescription)")
            }
        
        return liste
    }
    
    func deleteTable(tableName: String) {
        let query = "DROP TABLE IF EXISTS \(tableName)"
        do {
            try db!.run(query)
            print("Table \(tableName) deleted.")
        } catch {
            print("Error deleting table \(tableName): \(error.localizedDescription)")
        }
    }
    
    func kelimeSil(ingilizce: String){
        let query = "DELETE FROM \(String(describing: DBManager.tablo)) WHERE ingilizce = '\(ingilizce)'"
        do {
            try db!.run(query)
            print("kelime silindi")
        } catch {
            print("kelime silme hatası\(error.localizedDescription)")
        }
    }
    
    func rasgele10SoruGetir(tabloAdi: String) -> [Kelime] {
        var liste = [Kelime]()
        do {
            
            let query = "SELECT * FROM \(tabloAdi) ORDER BY RANDOM() LIMIT 10"

            for row in try db!.prepare(query) {
                let yeniKelime = Kelime(id: Int(row[0] as! Int64), ingilizce: row[1] as! String, turkce: row[2] as! String, cumle: row[3] as? String ?? "")
                liste.append(yeniKelime)
            }
        } catch {
            print("Error: \(error)")
        }
        return liste
    }
    
    func rasgele3YanlisSecenekGetir(kelimeId: Int64) -> [Kelime] {
        var liste = [Kelime]()
        do {
            let query = "SELECT * FROM \(String(describing: DBManager.tablo)) WHERE id != '\(kelimeId)' ORDER BY RANDOM() LIMIT 3"
            for row in try db!.prepare(query) {
                let yeniKelime = Kelime(id: Int(row[0] as! Int64), ingilizce: row[1] as! String, turkce: row[2] as! String, cumle: row[3] as? String ?? "")
                liste.append(yeniKelime)
            }
        } catch {
            print("Error: \(error)")
        }
        return liste
    }
    
    func aramaYap(ingilizce: String) -> [Kelime] {
        
        var liste = [Kelime]()
                
        do {
            let query = "SELECT * FROM \(String(describing: DBManager.tablo))  WHERE ingilizce like '%\(ingilizce)%'"
            for row in try db!.prepare(query) {
                let yeniKelime = Kelime(id: Int(row[0] as! Int64), ingilizce: row[1] as! String, turkce: row[2] as! String, cumle: row[3] as? String ?? "")
                liste.append(yeniKelime)
            }
        } catch {
            print("Error: \(error)")
        }
                
        return liste
        
    }
    
    func kayitSayisiAl() -> Int64 {
        let query = "SELECT COUNT(*) FROM \(DBManager.tablo)"
        do {
            let stmt = try db!.prepare(query)
            for row in stmt {
                return Int64(row[0] as! Int64)
            }
        } catch {
            print("kayit sayisi alma hatasi: (error.localizedDescription)")
        }
        return 0
    }
    
}
