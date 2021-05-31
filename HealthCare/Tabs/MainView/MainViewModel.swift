//
//  MainViewModel.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 10.05.2021.
//

import Foundation
import Combine

class MainViewModel: ObservableObject{
    
    
    
    var storage = Storage.shared
    var subscribers=[Storage.RecordSubscriber]()
    var subscriber=Storage.RecordSubscriber()
    @Published var records = [Storage.Record]()
    init() {
        self.storage.publisher.subscribe(self.subscriber)
        self.subscriber.setReceiveClosure(closure: self.handler(input:))
    }
    
    func handler(input: Storage.Record){
        DispatchQueue.main.async{
        self.records.append(input)
        }
    }
}



