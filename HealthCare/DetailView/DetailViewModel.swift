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
                    self.marks=self.calculations.getRRs(data: self.data)
                    var indexes: [Int]=[]

                    for i in 0..<self.marks.count{
                        if(marks[i]>0){
                            indexes.append(i)
                        }
                    }
                    var _rrs:[Double]=[]
                    if(indexes.count>1){
                    for i in 1..<indexes.count{
                        _rrs.append(Double(indexes[i]-indexes[i-1]))
                    }
                    }
                    self.rrs=_rrs
                }
            }
        }
        var marks:[Double]=[]
        var rrs:[Double]=[]
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
