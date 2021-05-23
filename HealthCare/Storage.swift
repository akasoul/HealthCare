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

class Storage{
    struct Record: Hashable{
        let date: Date
        let ecgData: [Double]
        let heartRate: Double//HKQuantity?
        let symptomsStatus: HKElectrocardiogram.SymptomsStatus?
        let classification: HKElectrocardiogram.Classification?
        let samplingFrequency: Double?
        let duration: Double
    }
    private var finished = false
    static var shared=Storage()
    private var latest: Record?
    private var all: [Record]?
    private let healthStore = HKHealthStore()
    private let ecgType = HKObjectType.electrocardiogramType()
    
    func getAll()->[Record]?{
        if(healthStore.authorizationStatus(for: ecgType) == .sharingDenied){
            var queryIsFinished:[Bool]=[]
            var expectedCount=0
            
            let ecgQuery = HKSampleQuery(sampleType: ecgType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil){ (query, samples, error) in
                if let error = error {
                    fatalError("*** An error occurred \(error.localizedDescription) ***")
                }
                
                guard let samples = samples
                else{ return }
                guard
                    let allSamples = samples as? [HKElectrocardiogram]
                else {
                    return
                }
                print(allSamples)
                expectedCount=allSamples.count
                self.all=[]
                for i in 0..<allSamples.count{
                    var ecgSamples = [(Double,Double)] ()
                    let query = HKElectrocardiogramQuery(allSamples[i]) { (query, result) in
                        
                        switch result {
                        case .error(let error):
                            print("error: ", error)
                            
                        case .measurement(let value):
                            let sample = (value.quantity(for: .appleWatchSimilarToLeadI)!.doubleValue(for: HKUnit.volt()) , value.timeSinceSampleStart)
                            ecgSamples.append(sample)
                            
                            
                        case .done:
                            print("done")
                            let date = (allSamples[i] as HKSample).endDate
                            let heartRate = (allSamples[i]).averageHeartRate?.doubleValue(for: HKUnit(from: "count/min")) ?? 0
                            let symtomsStatus = (allSamples[i]).symptomsStatus
                            let samplingFrequency = (allSamples[i]).samplingFrequency?.doubleValue(for: HKUnit.hertz()) ?? 0
                            let classification = (allSamples[i]).classification
                            let ecgData=ecgSamples.map( { $0.0 } )
                            let duration=Double((allSamples[i] as HKSample).endDate.timeIntervalSince1970 - (allSamples[i] as HKSample).startDate.timeIntervalSince1970)
                            
                            let record = Record(date: date, ecgData: ecgData, heartRate: heartRate, symptomsStatus: symtomsStatus, classification: classification, samplingFrequency: samplingFrequency,duration: duration)
                            self.all?.append(record)
                            queryIsFinished.append(true)
                        }
                    }
                    self.healthStore.execute(query)
                    
                }
                
            }
            
            
            self.healthStore.execute(ecgQuery)
            while(queryIsFinished == []){
                usleep(100)
            }
            while(queryIsFinished.count != expectedCount){
                usleep(100)
            }
            
//            guard let tmp = self.all
//            else{ return nil }
//            for i in 0..<tmp.count{
//                let str = tmp[i].ecgData.map({ String($0) }).joined(separator: " ")
//                try? str.data(using: .utf8)!.write(to: URL(fileURLWithPath: "/Users/antonvoloshuk/Desktop/AppleWatch ECG Samples/\(i+1).txt"))
//            }
            
            return self.all
        }
        
        return nil
    }
    
   
    private init() {
        
        self.healthStore.requestAuthorization(toShare: nil, read: [ecgType]) { (success, error) in
            if success {
                print("HealthKit Auth successful")
            } else {
                print("HealthKit Auth Error")
            }
        }
    }
}

