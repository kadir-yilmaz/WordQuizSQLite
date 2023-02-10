//
//  Kelime.swift
//  WordQuizSQLite
//
//  Created by Kadir Yılmaz on 28.01.2023.
//

import Foundation

class Kelime: Equatable, Hashable{
    
    var id: Int64?
    var ingilizce: String?
    var turkce: String?
    var cumle: String?
    
    // boş init tanımlamak için özellikler nullable olmalı
    init(){
        
    }
    
    init(id: Int, ingilizce: String, turkce: String, cumle: String) {
        self.id = Int64(id)
        self.ingilizce = ingilizce
        self.turkce = turkce
        self.cumle = cumle
    }
    
    func hash(into hasher: inout Hasher) {
            hasher.combine(id)
    }
    
    static func == (lhs: Kelime, rhs: Kelime) -> Bool {
        return lhs.id == rhs.id
    }
}
