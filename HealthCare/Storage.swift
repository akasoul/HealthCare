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



class Storage: ObservableObject{
    static var shared=Storage()
    var appFolder: String
    @Published var records: [Record]=[]
    @Published var userInfo: UserInfo?{
        didSet{
            self.objectWillChange.send()
        }
    }
    
    private let healthStore = HKHealthStore()
    private let ecgType = HKObjectType.electrocardiogramType()
    private let heightType=HKObjectType.quantityType(forIdentifier: .height)
    private let weightType=HKObjectType.quantityType(forIdentifier: .bodyMass)
    private let genderType=HKCharacteristicType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)
    
    
    func getRecords(){
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
                self.records=[]
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
                                self.records.append(record)
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
            if(expectedCount > 0){
                while(queryIsFinished == []){
                    print("waiting \(queryIsFinished.count) \(expectedCount)")
                    usleep(100)
                }
                while(queryIsFinished.count != expectedCount){
                    print("waiting \(queryIsFinished.count) \(expectedCount)")
                    usleep(100)
                }
            }
            print("query is finished")
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
                if(allSamples.count>0){
                    height = allSamples[0].quantity.doubleValue(for: HKUnit.init(from: .centimeter))
                }
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
                if(allSamples.count>0){
                    weight = allSamples[0].quantity.doubleValue(for: HKUnit.init(from: .kilogram))
                }
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
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first{
            self.appFolder = url.path + "/EcgAnalyzer/"
            var isDir: ObjCBool=false
            if !FileManager.default.fileExists(atPath: self.appFolder,isDirectory: &isDir){
                do {
                    try FileManager.default.createDirectory(atPath: self.appFolder, withIntermediateDirectories: true, attributes: [:])
                }
                catch{
                    print(error)
                }
            }
            
        }
        else{
            self.appFolder=""
        }
        
        
        self.healthStore.requestAuthorization(toShare: nil, read: [ecgType,heightType!,weightType!,genderType!]) { (success, error) in
            if success {
                print("HealthKit Auth successful")
                DispatchQueue.global().async {
                    self.getUserInfo()
                    self.getRecords()
                    let observerQuery = HKObserverQuery.init(sampleType: self.ecgType, predicate: nil, updateHandler: { query,completionHandler,error in
                        print(query)
                        self.getRecords()
                        print("new data received")
                    })
                    self.healthStore.execute(observerQuery)
                }
            } else {
                print("HealthKit Auth Error")
            }
        }
    }
    
    
}




extension Storage{
    
    class Record: Hashable,Equatable{
        weak var storage: Storage?
        static func ==(lhs:Record,rhs:Record)->Bool{
            return lhs.ecgData==rhs.ecgData && lhs.calculatedData?.health==rhs.calculatedData?.health && lhs.date == rhs.date
        }
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.calculatedData?.rMarks)
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
                self.storage?.objectWillChange.send()
            }
        }
        
        init(date: Date, ecgData: [Double], heartRate: Double, symptomsStatus: HKElectrocardiogram.SymptomsStatus?, classification: HKElectrocardiogram.Classification?, samplingFrequency: Double?,duration: Double,storage: Storage?=nil){
            self.date=date
            self.ecgData=ecgData
            self.heartRate=heartRate
            self.symptomsStatus=symptomsStatus
            self.classification=classification
            self.samplingFrequency=samplingFrequency
            self.duration=duration
            self.storage=storage
            let calendar=Calendar.current
            
            self.path=Storage.shared.appFolder + "/" + String(calendar.component(.year, from: date)) +
                String(calendar.component(.month, from: date)) +
                String(calendar.component(.day, from: date)) +
                String(calendar.component(.hour, from: date)) +
                String(calendar.component(.minute, from: date)) +
                String(calendar.component(.second, from: date))
            
            DispatchQueue.global().async{
                let calculations=Calculations()
                var tmp = CalculatedData()
                var isDir: ObjCBool=false
                
                tmp.ecg=self.ecgData
                
                if(!FileManager.default.fileExists(atPath: self.path, isDirectory: &isDir)){
                    do{
                        try FileManager.default.createDirectory(at: URL(fileURLWithPath: self.path), withIntermediateDirectories: true, attributes: [:])
                    }
                    catch{
                        print(error)
                    }
                }
                let rMarksPath=self.path+"/rmarks.txt"
                let qMarksPath=self.path+"/qmarks.txt"
                let tMarksPath=self.path+"/tmarks.txt"
                let rrsPath=self.path+"/rrs.txt"
                
                if(FileManager.default.fileExists(atPath: rMarksPath, isDirectory: &isDir)){
                    do{
                        let strArr = try String(contentsOfFile: rMarksPath).split(separator: ",")
                        tmp.rMarks = strArr.compactMap({ Double($0) })
                    }
                    catch{
                        tmp.rMarks=calculations.getMarksR(ecg: tmp.ecg)
                        let str=tmp.rMarks.map({ String($0) }).joined(separator: ",")
                        if let data=str.data(using: .utf8){
                            try? data.write(to: URL(fileURLWithPath: rMarksPath))
                        }
                        
                    }
                }
                else{
                    tmp.rMarks=calculations.getMarksR(ecg: tmp.ecg)
                    let str=tmp.rMarks.map({ String($0) }).joined(separator: ",")
                    if let data=str.data(using: .utf8){
                        try? data.write(to: URL(fileURLWithPath: rMarksPath))
                    }
                }
                
                if(FileManager.default.fileExists(atPath: qMarksPath, isDirectory: &isDir)){
                    do{
                        let strArr = try String(contentsOfFile: qMarksPath).split(separator: ",")
                        tmp.qMarks = strArr.compactMap({ Double($0) })
                    }
                    catch{
                        tmp.qMarks=calculations.getMarksQ(ecg: tmp.ecg)
                        let str=tmp.qMarks.map({ String($0) }).joined(separator: ",")
                        if let data=str.data(using: .utf8){
                            try? data.write(to: URL(fileURLWithPath: qMarksPath))
                        }
                        
                    }
                }
                else{
                    tmp.qMarks=calculations.getMarksQ(ecg: tmp.ecg)
                    let str=tmp.qMarks.map({ String($0) }).joined(separator: ",")
                    if let data=str.data(using: .utf8){
                        try? data.write(to: URL(fileURLWithPath: qMarksPath))
                    }
                }
                
                if(FileManager.default.fileExists(atPath: tMarksPath, isDirectory: &isDir)){
                    do{
                        let strArr = try String(contentsOfFile: tMarksPath).split(separator: ",")
                        tmp.tMarks = strArr.compactMap({ Double($0) })
                    }
                    catch{
                        tmp.tMarks=calculations.getMarksT(ecg: tmp.ecg)
                        let str=tmp.tMarks.map({ String($0) }).joined(separator: ",")
                        if let data=str.data(using: .utf8){
                            try? data.write(to: URL(fileURLWithPath: tMarksPath))
                        }
                        
                    }
                }
                else{
                    tmp.tMarks=calculations.getMarksT(ecg: tmp.ecg)
                    let str=tmp.tMarks.map({ String($0) }).joined(separator: ",")
                    if let data=str.data(using: .utf8){
                        try? data.write(to: URL(fileURLWithPath: tMarksPath))
                    }
                }
                

                if(FileManager.default.fileExists(atPath: rrsPath, isDirectory: &isDir)){
                    do{
                        let strArr = try String(contentsOfFile: rrsPath).split(separator: ",")
                        tmp.rr = strArr.compactMap({ Double($0) })
                    }
                    catch{
                        tmp.rr=calculations.getRR(rMarks: tmp.rMarks)
                        let str=tmp.rr.map({ String($0) }).joined(separator: ",")
                        if let data=str.data(using: .utf8){
                            try? data.write(to: URL(fileURLWithPath: rrsPath))
                        }
                    }
                    
                }
                else{
                    tmp.rr=calculations.getRR(rMarks: tmp.rMarks)
                    let str=tmp.rr.map({ String($0) }).joined(separator: ",")
                    if let data=str.data(using: .utf8){
                        try? data.write(to: URL(fileURLWithPath: rrsPath))
                    }
                }
                
                
                tmp.hrvIndex=calculations.getHrvIndex(tmp.rr)
                self.calculatedData=tmp
            }
            
        }
    }
    
    struct CalculatedData: Equatable,Hashable{
        func hash(into hasher: inout Hasher) {
            hasher.combine(self.health)
        }
        var ecg:[Double]=[]
        var rMarks:[Double]=[]
        var qMarks:[Double]=[]
        var tMarks:[Double]=[]
        var rr:[Double]=[]
        var qt:[Double]=[]
        var heartRate: Double = 0
        var health: Double = 0
        var hrvIndex: Double = 0
        static func ==(lhs:CalculatedData,rhs:CalculatedData)->Bool{
            return lhs.rMarks == rhs.rMarks
        }
        
    }
    
    
    
    struct UserInfo{
        let dateOfBirth: Date
        let height: Double
        let weight: Double
        let gender: String
    }
}



