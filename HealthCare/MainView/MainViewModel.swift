//
//  MainViewModel.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 10.05.2021.
//

import Foundation


class MainViewModel: ObservableObject{
    let storage = Storage.shared
    @Published var list: [Storage.Record]=[]

    init() {
        guard let list = self.storage.getAll()
        else{
            self.list=[]
            return
        }
        for i in list{
            self.list.append(i)
        }
    }
    
}
