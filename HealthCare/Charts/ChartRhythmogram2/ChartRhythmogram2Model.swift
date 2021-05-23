//
//  ChartRhythmogram2Model.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 03.05.2021.
//

import Foundation
import CoreGraphics
import UIKit

class ChartRhythmogram2Model: ObservableObject{
    @Published var img: UIImage?
    @Published var imgAxisX: UIImage?
    @Published var imgAxisY: UIImage?
    
    var axisColor=UIColor.blue
    var axisWidth: CGFloat = 60
    var axisHeight: CGFloat = 20
    let axisFontSize:CGFloat=12
    var height: CGFloat?
    var width: CGFloat?
    var topColor: UIColor?
    var bottomColor: UIColor?
    var data: [Double]?
    var frequency: Double?
    init() {
        
    }
    
    func setSize(height: CGFloat,width:CGFloat){
        self.height=height - self.axisHeight
        self.width=width-self.axisWidth
        self.update()
    }
    
    func setup(data: [Double],frequency: Double,topColor: UIColor,bottomColor: UIColor){
        self.data=data
        self.frequency=frequency
        self.topColor=topColor
        self.bottomColor=bottomColor
        self.update()
    }
    
    func update(){
        guard let data=self.data,
              let frequency=self.frequency,
              let topColor=self.topColor,
              let bottomColor=self.bottomColor,
              let height=self.height,
              let width=self.width
        else{ return }

        var tmpData: [Double]=[]
        for i in 0..<data.count{
            tmpData.append(data[i])
            tmpData.append(data[i])
        }
        guard var min = tmpData.min(),
              var max = tmpData.max()
        else{ return }

        
        min = 0
        
//        max += 100
        min = 0
//        max = 2000
        let dataHeight=max-min
        let step = width/CGFloat(tmpData.count-1)
        
        let layer=CAShapeLayer()
        let grLayer=CAGradientLayer()
        
        grLayer.colors=[topColor.cgColor,bottomColor.cgColor]
        
        layer.frame=CGRect(x: 0, y: 0, width: width, height: height)
        grLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
        
        let path = UIBezierPath()
        for i in 0..<tmpData.count{
            var pointY = tmpData[i]
            pointY -= min
            pointY /= dataHeight
            pointY *= Double(height)
            pointY = Double(height) - pointY
            if(i==0){
                path.move(to: .init(x: step*CGFloat(i), y: CGFloat(pointY)))
            }
            else{
                path.addLine(to: .init(x: step*CGFloat(i), y: CGFloat(pointY)))
                
            }
        }
        path.addLine(to: .init(x: width, y: height))
        path.addLine(to: .init(x: 0, y: height))
        path.close()
        layer.path=path.cgPath
        layer.fillColor = UIColor.red.cgColor
        
        
        grLayer.mask=layer

        let renderer = UIGraphicsImageRenderer(bounds: grLayer.bounds)
        self.img = renderer.image(actions: { context in
            grLayer.render(in: context.cgContext)
        })
        
        
        let xMarksPeriod=50
        let xMarksCount = Int(width/CGFloat(xMarksPeriod))
        let xMarksStartValue:CGFloat=0
        let xMarksEndValue:CGFloat=CGFloat(data.count)
        let xMarksFormat=NSString(string: Localization.getString("IDS_CHART_RHYTHMOGRAM_X_MARKS_FORMAT"))

        let yMarksPeriod=25
        let yMarksCount = Int(height/CGFloat(yMarksPeriod))
        let yMarksStartValue:CGFloat=0
        var yMarksEndValue:CGFloat=1
        if(frequency != 0){
        yMarksEndValue=CGFloat(Double(max)/frequency)
        }
        let yMarksFormat=NSString(string: Localization.getString("IDS_CHART_RHYTHMOGRAM_Y_MARKS_FORMAT"))

        //axis x
        do{
            let layer = CALayer()
            layer.frame=CGRect(x: 0, y: 0, width: width, height: axisHeight)

            let count = xMarksCount
            let step = width/CGFloat(count)
            for i in 0..<count{
                let textLayer=CATextLayer()
                textLayer.frame=CGRect(x: step*CGFloat(i), y: 5, width: step, height: axisHeight-5)
                let value = Double((CGFloat(i)/CGFloat(count-1)) * (xMarksEndValue-xMarksStartValue) + xMarksStartValue)
                textLayer.string = NSString(format: xMarksFormat, value)
                textLayer.foregroundColor=self.axisColor.cgColor
                textLayer.fontSize=self.axisFontSize
                textLayer.alignmentMode = .left
                layer.addSublayer(textLayer)
            }
            let renderer = UIGraphicsImageRenderer(bounds: layer.bounds)
            self.imgAxisX = renderer.image(actions: { context in
                layer.render(in: context.cgContext)
            })
        }
        //axis y
        do{
            let layer = CALayer()
            layer.frame=CGRect(x: 0, y: 0, width: axisWidth, height: height)
            let count = yMarksCount
            let step = height/CGFloat(count)
            for i in 0..<count{
                let textLayer=CATextLayer()
                textLayer.frame=CGRect(x: 0, y: CGFloat(count-i-1)*step+(step-self.axisFontSize), width: axisWidth-10, height: self.axisFontSize)
                let value = Double((CGFloat(i)/CGFloat(count-1)) * (yMarksEndValue-yMarksStartValue) + yMarksStartValue)
                textLayer.string = NSString(format: yMarksFormat, value)
                textLayer.foregroundColor=self.axisColor.cgColor
                textLayer.fontSize=self.axisFontSize
                textLayer.alignmentMode = .right

                layer.addSublayer(textLayer)
            }
            
            let renderer = UIGraphicsImageRenderer(bounds: layer.bounds)
            self.imgAxisY = renderer.image(actions: { context in
                layer.render(in: context.cgContext)
            })
        }
        
    }
}
