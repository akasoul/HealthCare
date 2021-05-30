//
//  NavigationViewModel.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 29.04.2021.
//

import Foundation



class NavigationViewModel: ObservableObject{
    let storage = Storage.shared
    @Published var list: [Storage.Record]=[]
//    {
//        didSet{
//            for i in 0..<self.list.count{
//                let str=self.list[i].ecgData.map( { String($0) } ).joined(separator: " ")
//                try? str.write(toFile: "/Users/antonvoloshuk/Documents/_NN/nn_ecg/ecg\(i).txt", atomically: true, encoding: .utf8)
//
//            }
//        }
//    }
    init() {
//        guard let list = self.storage.getAll()
//        else{
//            self.list=[]
//            return
//        }
//        for i in list{
//            self.list.append(i)
//        }
    }
}
