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
    @Published var records = [Storage.Record](){
        didSet{
//            self.records=self.records.sorted(by: { $0.date < $1.date})
        }
    }
    @Published var info: Storage.UserInfo?
    private var cancellables = Set<AnyCancellable>()
    init() {
        self.storage.objectWillChange.sink { _ in
//            DispatchQueue.main.async{
//            self.objectWillChange.send()
//            }

            for i in 0..<self.storage.records.count{
                if(self.storage.records[i].calculatedData != nil){
                    if(!self.records.contains(self.storage.records[i])){
                        //                            sleep(UInt32.random(in: 1...3))
                        DispatchQueue.main.async{
                            self.records.append(self.storage.records[i])
                            self.records=self.records.sorted(by: { $0.date>$1.date})
                        }
                    }
                }
            }

            if(self.storage.userInfo != nil){
                DispatchQueue.main.async{
                self.info=self.storage.userInfo
                }
            }
            //            DispatchQueue.main.async{
//            self.records=self.storage.all
//            }
        
        }
        .store(in: &cancellables)
    }
    
}



