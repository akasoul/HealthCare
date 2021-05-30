//
//  Calculations.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 23.04.2021.
//

import Foundation
import CoreML

class Calculations{
    
    let mpd500 = try? mpd500_0905.init(configuration: MLModelConfiguration())
    let mpd1000 = try? model1205.init(configuration: MLModelConfiguration())
    let mpd1305 = try? model1305.init(configuration: MLModelConfiguration())
    let mpd1405 = try? model1405.init(configuration: MLModelConfiguration())
    let mpd1505 = try? model1505.init(configuration: MLModelConfiguration())
    let mpd1605 = try? model1605.init(configuration: MLModelConfiguration())
    
    let mh = try? healthModel.init(configuration: MLModelConfiguration())
    let mh2605 = try? healthModel2605.init(configuration: MLModelConfiguration())

    let treshhold: Double = 0.3
    let filterRadius: Int = 10
    
    func getRRs(ecgMarks: [Double])->[Double]{
        var indexes: [Int]=[]
        for i in 0..<ecgMarks.count{
            if(ecgMarks[i]>self.treshhold){
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
    
    func getEcgMarks(data: [Double])->[Double]{
        var data=data
        let str = data.map({ String($0) }).joined(separator: " ")
        try? str.data(using: .utf8)!.write(to: URL(fileURLWithPath: "/Users/antonvoloshuk/Desktop/AppleWatch ECG Samples/current.txt"))
        
        
        guard let minValue=data.min(),
              let maxValue=data.max(),
              let model = self.mpd1605
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
            if(marks[i]>self.treshhold){
                marks[i]=1
            }
        }
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
    
    func getHealthValue(rrs: [Double]) -> Double{
        var out: Double = 0
        guard let model = self.mh2605
        else{
            return out
        }
        var counter = 0
        let frameWidth=100
        if let tmpMLarr = try? MLMultiArray(shape: [frameWidth as NSNumber], dataType: .float32){
            
            for i in 0..<frameWidth{
                tmpMLarr[i] = NSNumber(value:rrs[counter])
                counter += 1
                if(counter==rrs.count){
                    counter = 0
                }
            }
            let ans = try? model.prediction(input1: tmpMLarr)
            if let output = ans?.output1{
                out=output[0].doubleValue
            }
        }
        if(out<0){
            out=0
        }
        if(out>100){
            out=100
        }
        return out
    }
    
    
    
}
