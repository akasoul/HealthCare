//
//  Localization.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 07.05.2021.
//

import Foundation

class Localization{
    static let langFiles:[String:String]=[
        "en":"langEN",
        "ru":"langRU"
    ]
    static func getString(_ id: String)->String{
        let currentLanguage = Locale.current.languageCode ?? "en"
        let langFile = self.langFiles[currentLanguage] ?? "langEN"
        return NSLocalizedString(id, tableName: langFile,comment: "")
        
    }
}
