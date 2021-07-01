//
//  Calculations.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 23.04.2021.
//

import Foundation
import CoreML

class Calculations{
    
    let rpeaks = try? modelRPeaks.init(configuration: MLModelConfiguration())
    let qpeaks = try? modelQPeaks.init(configuration: MLModelConfiguration())
    let tpeaks = try? modelTPeaks.init(configuration: MLModelConfiguration())
    
    let treshholdR: Double = 0.3
    let treshholdQ: Double = 0.3
    let treshholdT: Double = 0.2
    let filterRadius: Int = 10
    
    func getRRs(ecgMarks: [Double])->[Double]{
        var indexes: [Int]=[]
        for i in 0..<ecgMarks.count{
            if(ecgMarks[i]>self.treshholdR){
                indexes.append(i)
            }
        }
        var rrs:[Double]=[]
        if(indexes.count>1){
            for i in 1..<indexes.count{
                rrs.append(Double(indexes[i]-indexes[i-1]))
            }
        }
        return rrs
    }
    
    func getMarksR(data: [Double])->[Double]{
        var data=data
        
        guard let minValue=data.min(),
              let maxValue=data.max(),
              let model = self.rpeaks
//              let model=self.qpeaks
        
        else{ return [] }
        let scaledMin:Double=0
        let scaledMax:Double=1
        
        for j in 0..<data.count{
            let value = (scaledMax-scaledMin)*(data[j]-minValue)/(maxValue-minValue)+scaledMin
            data[j]=value
        }
        let frameWidth=500
        
        let step = frameWidth/2
        var marks:[Double] = .init(repeating: 0, count: data.count*2)
        let count = data.count/step + 1
        data.append(contentsOf: [Double].init(repeating: 0, count: frameWidth))
        for j in 0..<count{
            if let tmpMLarr = try? MLMultiArray(shape: [frameWidth as NSNumber], dataType: .float32){
                let tmpArr=Array(data[j*step..<j*step + frameWidth])
                for i in 0..<frameWidth{
                    tmpMLarr[i] = NSNumber(value:tmpArr[i])
                }
                let out = try? model.prediction(input1: tmpMLarr)
                if let output = out?.output1{
                    for i in 0..<frameWidth{
                        if(marks[step*j + i] < Double(output[i].doubleValue)){
                            marks[step*j + i] = Double(output[i].doubleValue)
                        }
                    }
                }
            }
        }
        
        marks.removeSubrange(data.count..<marks.count)
        self.filterMarks2(ecg: data, marks: &marks)
        for i in 0..<marks.count{
            if(marks[i]>self.treshholdR){
                marks[i]=1
            }
        }
        //self.filterMarks2(ecg: data, marks: &marks)
        return marks
    }
    
    func getMarksQ(data: [Double])->[Double]{
        var data=data
        
        guard let minValue=data.min(),
              let maxValue=data.max(),
              let model=self.qpeaks
        
        else{ return [] }
        let scaledMin:Double=0
        let scaledMax:Double=1
        
        for j in 0..<data.count{
            let value = (scaledMax-scaledMin)*(data[j]-minValue)/(maxValue-minValue)+scaledMin
            data[j]=value
        }
        let frameWidth=500
        
        let step = frameWidth/2
        var marks:[Double] = .init(repeating: 0, count: data.count*2)
        let count = data.count/step + 1
        data.append(contentsOf: [Double].init(repeating: 0, count: frameWidth))
        for j in 0..<count{
            if let tmpMLarr = try? MLMultiArray(shape: [frameWidth as NSNumber], dataType: .float32){
                let tmpArr=Array(data[j*step..<j*step + frameWidth])
                for i in 0..<frameWidth{
                    tmpMLarr[i] = NSNumber(value:tmpArr[i])
                }
                let out = try? model.prediction(input1: tmpMLarr)
                if let output = out?.output1{
                    for i in 0..<frameWidth{
                        if(marks[step*j + i] < Double(output[i].doubleValue)){
                            marks[step*j + i] = Double(output[i].doubleValue)
                        }
                    }
                }
            }
        }
        
        marks.removeSubrange(data.count..<marks.count)
        self.filterMarks2(ecg: data, marks: &marks)
        for i in 0..<marks.count{
            if(marks[i]>self.treshholdQ){
                marks[i]=1
            }
        }
        //self.filterMarks2(ecg: data, marks: &marks)
        return marks
    }
    

    
    func getMarksT(data: [Double])->[Double]{
        var data=data
        
        guard let minValue=data.min(),
              let maxValue=data.max(),
              let model=self.tpeaks
        
        else{ return [] }
        let scaledMin:Double=0
        let scaledMax:Double=1
        
        for j in 0..<data.count{
            let value = (scaledMax-scaledMin)*(data[j]-minValue)/(maxValue-minValue)+scaledMin
            data[j]=value
        }
        let frameWidth=500
        
        let step = frameWidth/2
        var marks:[Double] = .init(repeating: 0, count: data.count*2)
        let count = data.count/step + 1
        data.append(contentsOf: [Double].init(repeating: 0, count: frameWidth))
        for j in 0..<count{
            if let tmpMLarr = try? MLMultiArray(shape: [frameWidth as NSNumber], dataType: .float32){
                let tmpArr=Array(data[j*step..<j*step + frameWidth])
                for i in 0..<frameWidth{
                    tmpMLarr[i] = NSNumber(value:tmpArr[i])
                }
                let out = try? model.prediction(input1: tmpMLarr)
                if let output = out?.output1{
                    for i in 0..<frameWidth{
                        if(marks[step*j + i] < Double(output[i].doubleValue)){
                            marks[step*j + i] = Double(output[i].doubleValue)
                        }
                    }
                }
            }
        }
        
        marks.removeSubrange(data.count..<marks.count)
        self.filterMarks2(ecg: data, marks: &marks)
        var str=""
        for i in 0..<marks.count{
            if(marks[i]>self.treshholdT){
                marks[i]=1
            }
            if(marks[i] > 0){
                str.append("\(i) \(marks[i]);")
            }
        }
        print(str)
        //self.filterMarks2(ecg: data, marks: &marks)
        return marks
    }
    
    func filterMarks(ecg: [Double],marks: inout [Double]){
        for i in 0..<ecg.count{
            if(marks[i]==1){
                var backRadius=self.filterRadius
                var forwardRadius=self.filterRadius
                while(i-backRadius<0){
                    backRadius -= 1
                }
                while(i+forwardRadius>ecg.count){
                    forwardRadius -= 1
                }
                let maxValue=ecg[i-backRadius..<i+forwardRadius].max()
                for j in i-backRadius..<i+forwardRadius{
                    if(ecg[j] != maxValue!){
                        marks[j]=0
                    }
                }
            }
        }
    }
    
    func filterMarks2(ecg: [Double],marks: inout [Double]){
        let rad = 30
        for i in 0..<ecg.count-rad{
            let tmp = Array(marks[i..<i+rad])
            if let tmpMax=tmp.max(){
                for j in i..<i+rad{
                    if(marks[j] != tmpMax){
                        marks[j]=0
                    }
                }
            }
        }
        
    }
    
    
    
    func getHrvIndex(_ rrs: [Double])->Double{
        var out:Double = 0
        let divider: Double = 5
        var dict: [Int:Int] = [:]
        
        for i in 0..<rrs.count{
            let key = Int( Double(Int(rrs[i]/divider)) * divider)
            if let _ = dict[key] {
                dict[key]! += 1
            }
            else{
                dict[key]=1
            }
            
        }
        
        let sorted = Array(dict.sorted(by: { $0.1 > $1.1}))

        let AMo = 100*Double(sorted.first?.value ?? 0)/Double(rrs.count)
        if(AMo != 0){
            out = Double(rrs.count) / AMo
        }
        return out
    }
    
}
