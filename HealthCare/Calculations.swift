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
        
        
       var data=rrs

        let dataScaled = [0.7169208088737351, 0.6796798708875674, 0.7944883941707892, 0.9256462354091767, 0.8420162092650332, 0.9630716713433223, 0.9409146741493157, 0.8641732064590398, 0.9182605696778411, 0.8092597256334603, 0.8052361883202716, 0.7316921403364062, 0.6583128010642771, 0.45568600561198674, 0.3564585303983944, 0.24615086246958726, 0.1873781459483933, 0.2941395946052373, 0.23683841068020525, 0.1727551221976383, 0.09601365450736202, 0.0, 0.19491211939164452, 0.12605342471017214, 0.10949795132184881, 0.35724845776911074, 0.4234068400216398, 0.34907286466705845, 0.4630716713433223, 0.547527815094244, 0.5839788257096953, 0.8273931855142782, 0.8535737200214735, 0.8813322410211634, 0.893715869384382, 0.8818293482986314, 1.0, 0.7903165491456844, 0.8296325809018146, 0.8388023885588024, 0.7461508624695873, 0.7243064746050706, 0.4810568235122241, 0.596013654507362, 0.3712298618610655, 0.3273931855142782, 0.17260681448572224, 0.2867539288739018, 0.06696809885948783, 0.19491211939164493, 0.1698703118207174, 0.09601365450736202, 0.19491211939164452, 0.21468141348619862, 0.19074027436653973, 0.35724845776911074, 0.3643215141709555, 0.40815819051774277, 0.45568600561198674, 0.6583128010642771, 0.5913644914410309, 0.7756935253949294, 0.8609593857528091, 0.8296325809018146, 0.8494018749963688, 0.9335290084179801, 0.8301296881792826, 0.79770221487702, 0.8444039123644856, 0.8240310570961313, 0.6870655366189029, 0.7243064746050706, 0.6361558038702705, 0.5812423230446909, 0.5041718450251051, 0.4234068400216402, 0.3498627920377752, 0.27198259741123065, 0.1555960876355143, 0.05458447049626968, 0.17725597755205294, 0.014771331462671079, 0.025041807570927103, 0.2294527449488697, 0.2867539288739018, 0.30554879764976195, 0.371707179902291, 0.43031518771174937, 0.3966006797613024, 0.5918418094822573, 0.6135214886350375, 0.7461508624695873, 0.8018740599021247, 0.807475583707808, 0.7829308834143489, 0.8005870252539404, 0.8301296881792826, 0.8346305435336976, 0.9404175668718477, 0.8905020486781512]
        guard let minValue=data.min(),
              let maxValue=data.max(),
              let model = self.mh2605
        else{ return 0 }
        let scaledMin:Double=0
        let scaledMax:Double=1
        
        for j in 0..<data.count{
            let value = (scaledMax-scaledMin)*(data[j]-minValue)/(maxValue-minValue)+scaledMin
            data[j]=value
        }
        
        var out: Double = 0
        var counter = 0

        
        let frameWidth=100
        if let tmpMLarr = try? MLMultiArray(shape: [frameWidth as NSNumber], dataType: .float64){
            
            for i in 0..<frameWidth{
                tmpMLarr[i] = NSNumber(value:dataScaled[counter])
                counter += 1
                if(counter==data.count){
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
