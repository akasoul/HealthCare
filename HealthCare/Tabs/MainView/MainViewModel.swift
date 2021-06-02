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
    var subscribers=[Storage.RecordSubscriber]()
    var subscriber=Storage.RecordSubscriber()
    @Published var records = [Storage.Record]()
    private var cancellables = Set<AnyCancellable>()
   init() {
//        self.storage.objectWillChange.sink { _ in
//            self.objectWillChange.send()
//            print("change")
//        }
//        .store(in: &cancellables)
//        self.subscriber.setReceiveClosure(closure: self.handler(input:))
////        self.storage.all.publisher.subscribe(self.subscriber)
//        self.storage.requestCalculatedRecords(self.subscriber)
////        var list = Storage.shared.all
    }
    
    func handler(input: Storage.Record){
        
        DispatchQueue.main.async{
        self.records.append(input)
            print("@received: \(input.date)")
        }
    }
}



