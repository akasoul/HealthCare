//
//  NavigationViewModel.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 29.04.2021.
//

import Foundation
import Combine


class NavigationViewModel: ObservableObject{
    
    
    
    @Published var storage = Storage.shared
    @Published var records = [Storage.Record]()
    private var cancellables = Set<AnyCancellable>()
    init() {
        self.storage.objectWillChange.sink { _ in
            
            for i in 0..<self.storage.all.count{
                    if(!self.records.contains(self.storage.all[i])){
                        DispatchQueue.main.async{
                            if(i<self.storage.all.count){
                            self.records.append(self.storage.all[i])
                            }
                        }
                    }
            }

        }
        .store(in: &cancellables)
    }
    
}
