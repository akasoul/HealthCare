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
    struct EcgData{
        let calculations=Calculations()
        var data:[Double]=[]{
            didSet{
                if(self.data != []){
                    self.marks=self.calculations.getEcgMarks(data: self.data)
                    self.rrs=self.calculations.getRRs(ecgMarks: self.marks)
                    self.health = self.calculations.getHealthValue(rrs: self.rrs)
                    self.hrvIndex = self.calculations.getHrvIndex(self.rrs)
                    
                    
                }
            }
        }
        var marks:[Double]=[]
        var rrs:[Double]=[]
        var duration: Double = 0
        var frequency: Double = 0
        var date: String=""
        var heartRate: Double = 0{
            didSet{
                let peaksMin=min(self.heartRate * self.duration/60, Double(self.rrs.count))
                let peaksMax=max(self.heartRate * self.duration/60, Double(self.rrs.count))
                self.reliability = 100*peaksMin/peaksMax

            }
        }
        var health: Double = 0
        var hrvIndex: Double = 0
        var reliability: Double = 0
    }
    let dateFormatter=DateFormatter()
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
                        self.recentEcgData2.frequency=self.record!.samplingFrequency ?? 0
                        self.recentEcgData2.date=self.dateFormatter.string(from: self.record!.date)
                        self.recentEcgData2.heartRate=self.record!.heartRate
                        self.recentRRData=rrValues
                    }
                }
            }
        }
    }
    @Published var recentRRData:[Double]=[]
    @Published var recentEcgData2 = EcgData()
    @Published var recentEcgMarksData: [Double]=[]
    
    
    init() {
        self.dateFormatter.dateStyle = .medium
        self.dateFormatter.timeStyle = .medium
    }
    
    func setRecord(_ record: Storage.Record){
        //DispatchQueue.main.async{
        self.record=record
        
        //}
    }
}
