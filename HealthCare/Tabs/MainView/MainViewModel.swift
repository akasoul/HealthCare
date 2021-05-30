//
//  MainViewModel.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 10.05.2021.
//

import Foundation
import Combine

class MainViewModel: ObservableObject{
    @Published var storage = Storage.shared
    @Published var list: [Storage.Record]=[]{
        didSet{
            print("didset")
        }
    }
    @Published var healths: [Double]=[]
    init() {
       print("mv init started")
        self.list = storage.all
//        self.healths=storage.all.compactMap({ $0.calculatedData.health})
//        guard let list = self.storage.getAll()
//        else{
//            self.list=[]
//            return
//        }
//        for i in list{
//            self.list.append(i)
//        }
//        print("mv init finished")
    }
    
}
