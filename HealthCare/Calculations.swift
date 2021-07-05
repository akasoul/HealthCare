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
    
    func getRR(rMarks: [Double])->[Double]{
        var indexes: [Int]=[]
        for i in 0..<rMarks.count{
            if(rMarks[i]>self.treshholdR){
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
    
    func getQT(qMarks: [Double],tMarks: [Double])->[Double]{
        var qt=[Double]()
        for i in 0..<qMarks.count{
            if(qMarks[i]>self.treshholdQ){
                if(tMarks.count-i>0){
                for j in 0..<tMarks.count-i{
                    if(tMarks[i+j]>treshholdT){
                        qt.append(Double(j))
                        break
                    }
                }
                }
            }
        }
        return qt
    }
    func getMarksR(ecg: [Double])->[Double]{
        var data=ecg
        
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
    
    func getMarksQ(ecg: [Double])->[Double]{
        var data=ecg
        
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
    

    
    func getMarksT(ecg: [Double])->[Double]{
        var data=ecg
        
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
    
    func getMarksQ2(ecg: [Double],marksR: [Double],hearRate: Double=0)->[Double]{
        var output=[Double](repeating: 0, count: ecg.count)
        var countR=0
        for i in 0..<marksR.count{
            if(marksR[i]==1){
                countR += 1
            }
        }
        if(countR==0){
            return output
        }
        if(hearRate != 0){
            countR=Int(hearRate)
        }
        let len = Int(0.5*Double(ecg.count)/Double(countR))
        for i in 0..<ecg.count{
            if(marksR[i]==1){
                var index=i
                var value=ecg[i]
                for j in 0..<len{
                    if(i-j>0){
                        if(ecg[i-j]<value){
                            index=i-j
                            value=ecg[i-j]
                        }
                    }
                }
                output[index]=1
            }
        }
        return output
    }
    

    func getMarksT2(ecg: [Double],marksR: [Double],hearRate: Double=0)->[Double]{
        var output=[Double](repeating: 0, count: ecg.count)
        
        var countR=0
        for i in 0..<marksR.count{
            if(marksR[i]==1){
                countR += 1
            }
        }
        if(countR==0){
            return output
        }
        if(hearRate != 0){
            countR=Int(hearRate)
        }

        let len = Int(0.5*Double(ecg.count)/Double(countR))
        
//        print("len: \(len)")
        for i in 0..<ecg.count{
            if(marksR[i]==1){
                var nextLen=len
                var index1=i
//                print("found R peak at: \(i)")
                var value1=ecg[i]
                for j in 0..<len{
                    if(i+j<ecg.count){
                        if(ecg[i+j]<value1){
                            index1=i+j
                            value1=ecg[i+j]
                            nextLen -= 1
                        }
                    }
                }
//                print("found S peak at: \(index1)")
//                print("search for T peak in range \(index1)..\(index1+nextLen)")
                var index2=index1
                var value2=value1
                if(nextLen>0){
                for j in 0..<nextLen{
                    if(j+index1<ecg.count){
                        if(ecg[j+index1]>value2){
                            index2=j+index1
                            value2=ecg[j+index1]
                        }
                    }
                }
//                    print("found T peak at: \(index2)")
                output[index2]=1
                }
            }
        }
        return output
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
