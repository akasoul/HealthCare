//
//  HealthKitStorageModel.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 22.04.2021.
//

import Foundation
import CoreML
import HealthKit
import Combine

class DetailViewModel: ObservableObject{
    struct ecgData{
        let calculations=Calculations()
        var data:[Double]=[]{
            didSet{
                if(self.data != []){
                    self.marks=self.calculations.getEcgMarks(data: self.data)
                    self.rrs=self.calculations.getRRs(ecgMarks: self.marks)
                }
            }
        }
        var marks:[Double]=[]
        var rrs:[Double]=[]
        var duration: Double = 0
    }
    let storage = Storage.shared
    var record: Storage.Record? = nil{
        didSet{
            if(self.record != nil){
                DispatchQueue.global().async{
                    var rrValues: [Double]=[]
                    for _ in 0..<100{
                        rrValues.append(Double.random(in: 400...450))
                    }
                    DispatchQueue.main.async{
                        self.recentEcgData2.data=self.record!.ecgData
                        self.recentEcgData2.duration=self.record!.duration
                        self.recentRRData=rrValues
                    }
                }
            }
        }
    }
    @Published var recentRRData:[Double]=[]
    @Published var recentEcgData2 = ecgData()
    @Published var recentEcgMarksData: [Double]=[]
    
    
    init() {
    }
    
    func setRecord(_ record: Storage.Record){
        //DispatchQueue.main.async{
        self.record=record
        
        //}
    }
}
