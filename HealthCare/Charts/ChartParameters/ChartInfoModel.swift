//
//  ChartInfoModel.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 22.05.2021.
//

import Foundation

class ChartInfoModel: ObservableObject{
    @Published var descriptions: [String]=[]
    @Published var values: [String]=[]
    
    func setup(descriptions: [String],values: [String]){
        self.descriptions=descriptions
        self.values=values
    }
}
