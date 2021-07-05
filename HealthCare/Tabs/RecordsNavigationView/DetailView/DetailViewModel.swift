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
                    self.rMarks=self.calculations.getMarksR(ecg: self.data)
                    self.qMarks=self.calculations.getMarksQ2(ecg: self.data,marksR: self.rMarks)
                    self.tMarks=self.calculations.getMarksT2(ecg: self.data,marksR: self.rMarks)
//                    self.qMarks=self.calculations.getMarksQ2(ecg: self.data,marksR: self.rMarks,hearRate: self.heartRate)
//                    self.tMarks=self.calculations.getMarksT2(ecg: self.data,marksR: self.rMarks,hearRate: self.heartRate)
                    self.rr=self.calculations.getRR(rMarks: self.rMarks)
                    self.qt=self.calculations.getQT(qMarks: self.qMarks, tMarks: self.tMarks)
                    self.hrvIndex = self.calculations.getHrvIndex(self.rr)
                    
                    
                }
            }
        }
        var rMarks:[Double]=[]
        var qMarks:[Double]=[]
        var tMarks:[Double]=[]
        var rr:[Double]=[]
        var qt:[Double]=[]
        var duration: Double = 0
        var frequency: Double = 0
        var date: String=""
        var heartRate: Double = 0
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
                        self.recentEcgData2.duration=self.record!.duration
                        self.recentEcgData2.frequency=self.record!.samplingFrequency ?? 0
                        self.recentEcgData2.date=self.dateFormatter.string(from: self.record!.date)
                        self.recentEcgData2.heartRate=self.record!.heartRate
                        self.recentEcgData2.data=self.record!.ecgData
                        self.recentRRData=rrValues
                        
                        let peaksMin=min(self.recentEcgData2.heartRate * self.recentEcgData2.duration/60, Double(self.recentEcgData2.rr.count))
                        let peaksMax=max(self.recentEcgData2.heartRate * self.recentEcgData2.duration/60, Double(self.recentEcgData2.rr.count))
                        self.recentEcgData2.reliability = 100*peaksMin/peaksMax
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
