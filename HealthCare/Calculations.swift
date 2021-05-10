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
    
    func getRRs2(data: [Double])->[Double]{
        var marks:[Double]=[]
        var data=data
        guard let minValue=data.min(),
              let maxValue=data.max(),
              let model = self.mpd500
        else{ return [] }
        let scaledMin:Double=0
        let scaledMax:Double=1
        
        for j in 0..<data.count{
            let value = (scaledMax-scaledMin)*(data[j]-minValue)/(maxValue-minValue)+scaledMin
            data[j]=value
        }
        let frameWidth=1000
        for j in 0..<Int(data.count/frameWidth){
            if let tmpMLarr = try? MLMultiArray(shape: [frameWidth as NSNumber], dataType: .double){
                for i in 0..<frameWidth{
                    tmpMLarr[i] = NSNumber(value:data[i+j*frameWidth])
                }
                let out = try? model.prediction(input1: tmpMLarr)
                if let output = out?.output1{
                    for i in 0..<frameWidth{
                        marks.append( Double(output[i].doubleValue) )
                    }
                }
            }
        }
        for i in 0..<marks.count{
            if(marks[i]>0.5){
                marks[i]=1
            }
        }
        //let newmarks=self.getRRs2(data: data)
        print(marks.count)
        //print(newmarks.count)
        return marks
    }
    
    
    
    func getRRs(data: [Double])->[Double]{
        var data=data
                        let str = data.map({ String($0) }).joined(separator: " ")
                        try? str.data(using: .utf8)!.write(to: URL(fileURLWithPath: "/Users/antonvoloshuk/Desktop/AppleWatch ECG Samples/current.txt"))
                    

        guard let minValue=data.min(),
              let maxValue=data.max(),
              let model = self.mpd500
        else{ return [] }
        let scaledMin:Double=0
        let scaledMax:Double=1
        
        for j in 0..<data.count{
            let value = (scaledMax-scaledMin)*(data[j]-minValue)/(maxValue-minValue)+scaledMin
            data[j]=value
        }
        let frameWidth=1000
        let step = frameWidth/10
        var marks:[Double] = .init(repeating: 0, count: data.count*2)
        let count = data.count/step + 1
        for j in 0..<count{
            //init the data which would be sended to nn
            if let tmpMLarr = try? MLMultiArray(shape: [frameWidth as NSNumber], dataType: .double){
                for i in 0..<frameWidth{
                    if(j*step + i < data.count){
                    tmpMLarr[i] = NSNumber(value:data[step*j + i])
                    }
                    else{
                        tmpMLarr[i] = NSNumber(value:0)
                    }
                }
                let out = try? model.prediction(input1: tmpMLarr)
                if let output = out?.output1{
                    for i in 0..<frameWidth{
                        if(marks[step*j + i] == 0){
                            marks[step*j + i] = Double(output[i].doubleValue)
                        }
                    }
                }
            }
        }
        
        
        
        for i in 0..<marks.count{
            if(marks[i]>0.5){
                marks[i]=1
            }
        }
        //let newmarks=self.getRRs2(data: data)
        print(marks.count)
        //print(newmarks.count)
        return marks
    }
    
}
