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

protocol RecordStorageListener: class{
    func receive(record: Storage.Record)
}

class Storage: RecordStorage,ObservableObject{
    func recordIsReady(record: Record) {
        //self.publisher.send(record)
        //print("send: \(record.date)")

    }
    
    static var shared=Storage()
    var publisher=PassthroughSubject<Storage.Record,Never>()
    var publisherArr=PassthroughSubject<[Storage.Record],Never>()
    private var finished = false
    @Published var all: [Record]=[]{
        didSet{
            self.all.publisher.sink(receiveValue: { i in
                self.publisher.send(i)
            })
        }
    }
    var userInfo: UserInfo?
    var loaded = false
    private let healthStore = HKHealthStore()
    private let ecgType = HKObjectType.electrocardiogramType()
    private let heightType=HKObjectType.quantityType(forIdentifier: .height)
    private let weightType=HKObjectType.quantityType(forIdentifier: .bodyMass)
    private let genderType=HKCharacteristicType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)
    
    
    private func getAll(){
            if(self.healthStore.authorizationStatus(for: self.ecgType) == .sharingDenied){
            var queryIsFinished:[Bool]=[]
            var expectedCount=0
            
                let ecgQuery = HKSampleQuery(sampleType: self.ecgType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil){ (query, samples, error) in
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
                            let date = (allSamples[i] as HKSample).endDate
                            let heartRate = (allSamples[i]).averageHeartRate?.doubleValue(for: HKUnit(from: "count/min")) ?? 0
                            let symtomsStatus = (allSamples[i]).symptomsStatus
                            let samplingFrequency = (allSamples[i]).samplingFrequency?.doubleValue(for: HKUnit.hertz()) ?? 0
                            let classification = (allSamples[i]).classification
                            let ecgData=ecgSamples.map( { $0.0 } )
                            let duration=Double((allSamples[i] as HKSample).endDate.timeIntervalSince1970 - (allSamples[i] as HKSample).startDate.timeIntervalSince1970)
                            
                            let record = Record(date: date, ecgData: ecgData, heartRate: heartRate, symptomsStatus: symtomsStatus, classification: classification, samplingFrequency: samplingFrequency,duration: duration,storage: self)
                            DispatchQueue.main.async{
                                self.all.append(record)
                            }
                            queryIsFinished.append(true)
                            
                        @unknown default:
                            print("@")

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
            self.loaded = true
            let appFolder = FileManager.default.urls(for: .documentDirectory, in: .allDomainsMask)[0].appendingPathComponent("test").absoluteString
            
            if !FileManager.default.fileExists(atPath: appFolder){
                FileManager.default.createFile(atPath: appFolder, contents: nil, attributes: [:])
            }
            
            //            guard let tmp = self.all
            //            else{ return nil }
            //            for i in 0..<tmp.count{
            //                let str = tmp[i].ecgData.map({ String($0) }).joined(separator: " ")
            //                try? str.data(using: .utf8)!.write(to: URL(fileURLWithPath: "/Users/antonvoloshuk/Desktop/AppleWatch ECG Samples/\(i+1).txt"))
            //            }
            
        }
        
    }
    
    func requestCalculatedRecords(_ subscriber: RecordSubscriber){
        self.publisher.subscribe(subscriber)
            print("requested")
        while(!self.loaded){
            sleep(1)
            print("wait")
        }
        for i in 0..<self.all.count{
            while(self.all[i].calculatedData == nil){
                print("wait calc")
                sleep(100)
            }
            self.publisher.send(self.all[i])
            print("send: \(all[i].date)")

        }

    }
    
    func getUserInfo(){
        
        guard let heightType=self.heightType,
              let weightType=self.weightType
        else{
            return
        }
        
        var dateOfBirth: Date = Date()
        var height: Double = 0
        var weight: Double = 0
        var gender: String = ""
        
        if(healthStore.authorizationStatus(for: heightType) == .sharingDenied){
            var fetched=false
            let heightQuery = HKSampleQuery(sampleType: heightType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil){ (query, samples, error) in
                if let error = error {
                    fatalError("*** An error occurred \(error.localizedDescription) ***")
                }
                
                guard let samples = samples
                else{ return }
                guard
                    let allSamples = (samples as? [HKQuantitySample])?.sorted(by: { $0.startDate > $1.startDate })
                else {
                    fetched = true
                    return
                }
                height = allSamples[0].quantity.doubleValue(for: HKUnit.init(from: .centimeter))
                fetched=true
            }
            self.healthStore.execute(heightQuery)
            while(!fetched){
                sleep(1)
            }
        }
        
        
        if(healthStore.authorizationStatus(for: weightType) == .sharingDenied){
            var fetched=false
            let heighQuery = HKSampleQuery(sampleType: weightType, predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: nil){ (query, samples, error) in
                if let error = error {
                    fatalError("*** An error occurred \(error.localizedDescription) ***")
                }
                
                guard let samples = samples
                else{
                    fetched=true
                    return
                }
                guard
                    let allSamples = (samples as? [HKQuantitySample])?.sorted(by: { $0.startDate > $1.startDate })
                else {
                    fetched=true
                    return
                }
                weight = allSamples[0].quantity.doubleValue(for: HKUnit.init(from: .kilogram))
                fetched=true
            }
            self.healthStore.execute(heighQuery)
            while(!fetched){
                sleep(1)
            }
        }
        
        let tmpGender = try? healthStore.biologicalSex().biologicalSex
        if(tmpGender == HKBiologicalSex.notSet){
            gender = Localization.getString("IDS_CHART_USERINFO_GENDER_NONSET")
        }
        if(tmpGender == HKBiologicalSex.female){
            gender = Localization.getString("IDS_CHART_USERINFO_GENDER_FEMALE")
        }
        if(tmpGender == HKBiologicalSex.male){
            gender = Localization.getString("IDS_CHART_USERINFO_GENDER_MALE")
        }
        if(tmpGender == HKBiologicalSex.other){
            gender = Localization.getString("IDS_CHART_USERINFO_GENDER_OTHER")
        }
        
        if let birthdayComponents = try? self.healthStore.dateOfBirthComponents(){
            if let date = birthdayComponents.date{
                dateOfBirth=date
            }
        }
        self.userInfo=UserInfo(dateOfBirth: dateOfBirth, height: height, weight: weight, gender: gender)
    }
    
    private init() {
        
        
        self.healthStore.requestAuthorization(toShare: nil, read: [ecgType,heightType!,weightType!,genderType!]) { (success, error) in
            if success {
                print("HealthKit Auth successful")
                DispatchQueue.global().async {
                    self.getAll()
                }
            } else {
                print("HealthKit Auth Error")
            }
        }
        self.getUserInfo()
    }
    
    
}

protocol RecordStorage: class{
    func recordIsReady(record: Storage.Record)
}


extension Storage{
    
    class RecordSubscriber: Subscriber{
        
        var receiveClosure: ((Record)->Void)?
        
        func setReceiveClosure(closure: @escaping (Record)->Void){
            self.receiveClosure=closure
        }
        
        func receive(subscription: Subscription) {
            subscription.request(.unlimited)
        }
        
        func receive(_ input: Storage.Record) -> Subscribers.Demand {
            self.receiveClosure?(input)
            return .unlimited
        }
        
        func receive(completion: Subscribers.Completion<Never>) {
            
        }
        
        typealias Input = Record
        typealias Failure = Never
        
        
    }
    
    class CalculatedData: Equatable,Hashable{
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.health)
        }
        var ecg:[Double]=[]
        var marks:[Double]=[]
        var rrs:[Double]=[]
        var heartRate: Double = 0
        var health: Double = 0
        var hrvIndex: Double = 0
        static func ==(lhs:CalculatedData,rhs:CalculatedData)->Bool{
            return lhs.marks == rhs.marks
        }
        
    }
    
    class Record: Hashable,Equatable{
        weak var storage: RecordStorage?
        static func ==(lhs:Record,rhs:Record)->Bool{
            return lhs.ecgData==rhs.ecgData && lhs.calculatedData?.health==rhs.calculatedData?.health
        }
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.calculatedData?.marks)
        }
        var path: String
        let date: Date
        let ecgData: [Double]
        let heartRate: Double
        let symptomsStatus: HKElectrocardiogram.SymptomsStatus?
        let classification: HKElectrocardiogram.Classification?
        let samplingFrequency: Double?
        let duration: Double
        var comment: String?
        var calculatedData: CalculatedData?{
            didSet{
                self.storage?.recordIsReady(record: self)
            }
        }
        
        init(date: Date, ecgData: [Double], heartRate: Double, symptomsStatus: HKElectrocardiogram.SymptomsStatus?, classification: HKElectrocardiogram.Classification?, samplingFrequency: Double?,duration: Double,storage: RecordStorage?=nil){
            self.date=date
            self.ecgData=ecgData
            self.heartRate=heartRate
            self.symptomsStatus=symptomsStatus
            self.classification=classification
            self.samplingFrequency=samplingFrequency
            self.duration=duration
            self.storage=storage
            let calendar=Calendar.current
            self.path=String(calendar.component(.year, from: date)) +
                String(calendar.component(.month, from: date)) +
                String(calendar.component(.day, from: date)) +
                String(calendar.component(.hour, from: date)) +
                String(calendar.component(.minute, from: date)) +
                String(calendar.component(.second, from: date))
            
                        DispatchQueue.global().async{
                        let calculations=Calculations()
                            let tmp = CalculatedData()
                            tmp.ecg=self.ecgData
                            tmp.marks=calculations.getEcgMarks(data: tmp.ecg)
                            tmp.rrs=calculations.getRRs(ecgMarks: tmp.marks)
                            
                            let path="/Users/antonvoloshuk/Desktop/RRs/"+self.path+".txt"
                            //try? tmp.rrs.map( { String($0) }).joined(separator: " ").data(using: .utf8)?.write(to: URL(fileURLWithPath: path))
                            
                            tmp.hrvIndex=calculations.getHrvIndex(tmp.rrs)
                            tmp.health=calculations.getHealthValue(rrs: tmp.rrs)
                            self.calculatedData=tmp
                            print("calculations are finished")
                        }
            
        }
    }
    struct UserInfo{
        let dateOfBirth: Date
        let height: Double
        let weight: Double
        let gender: String
    }
}
