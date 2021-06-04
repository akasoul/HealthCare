//
//  ChartScaterogramModel.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 04.05.2021.
//

import Foundation
import UIKit
import SwiftUI

class ChartScaterogramModel: ObservableObject{
    @Published var img: UIImage?
    @Published var imgAxisX: UIImage?
    @Published var imgAxisY: UIImage?
    @Published var titleColor=Color.blue
    @Published var textColor = Color.blue
    @Published var title: String=""
    @Published var backgroundColor: Color = Color(red: 1, green: 1, blue: 1).opacity(0.2)

    var axisColor=UIColor.blue
    var axisWidth: CGFloat = 60
    var axisHeight: CGFloat = 20
    let axisFontSize:CGFloat=12

    var height: CGFloat?
    var width: CGFloat?
    var fillColor: UIColor?
    var data: [Double]?
    var frequency: Double?

    init() {
        
    }
    
    func setColors(fillColor: UIColor,axisColor: UIColor){
        self.fillColor=fillColor
        self.axisColor=axisColor
    }
    
    func setSize(height: CGFloat,width:CGFloat){
        self.height=height - self.axisHeight
        self.width=width-self.axisWidth
        self.update()
    }
    
    func setData(data: [Double],frequency: Double){
        self.data=data
        self.frequency=frequency
        self.update()
    }
    
    func update(){
        
        guard let data=self.data,
              let frequency=frequency,
              var dataMax=data.max(),
              var dataMin=data.min(),
              let height=self.height,
              let width=self.width,
              let fillColor=self.fillColor
        else{ return }
        
        let dist=0.2*(dataMax-dataMin)
        dataMin -= dist
        dataMax += dist
        let mainLayer = CALayer()
        mainLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
        mainLayer.backgroundColor = UIColor.clear.cgColor
        
        let radius:CGFloat=2
        
        for i in 0..<data.count-1{
            let xPos = CGFloat(Double(width)*(data[i]-dataMin)/(dataMax-dataMin))
            let yPos = (height - CGFloat(Double(height)*(data[i+1]-dataMin)/(dataMax-dataMin)))
            
            let path=UIBezierPath()
            path.addArc(withCenter: .init(x: xPos, y: yPos), radius: radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
            let pathShadow=UIBezierPath()
            pathShadow.addArc(withCenter: .init(x: xPos, y: yPos), radius: radius+2, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
            
            let layer = CAShapeLayer()
            layer.frame=CGRect(x: 0, y: 0, width: width, height: height)
            layer.backgroundColor = UIColor.clear.cgColor
            layer.path = path.cgPath
            layer.fillColor = fillColor.cgColor
            mainLayer.addSublayer(layer)
            
            let shadowLayer = CAShapeLayer()
            shadowLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
            shadowLayer.backgroundColor = UIColor.clear.cgColor
            shadowLayer.path = pathShadow.cgPath
            shadowLayer.fillColor = fillColor.withAlphaComponent(0.1).cgColor
            mainLayer.addSublayer(shadowLayer)
            
            mainLayer.addSublayer(shadowLayer)
        }
        
        let renderer = UIGraphicsImageRenderer(bounds: mainLayer.bounds)
        self.img = renderer.image(actions: { context in
            mainLayer.render(in: context.cgContext)
        })
        
        let xMarksPeriod=50
        let xMarksCount = Int(width/CGFloat(xMarksPeriod))
        let xMarksStartValue:CGFloat=0
        var xMarksEndValue:CGFloat=1
        if(frequency != 0){
        xMarksEndValue=CGFloat(Double(dataMax)/frequency)
        }
        let xMarksFormat=NSString(string: Localization.getString("IDS_CHART_SCATEROGRAM_X_MARKS_FORMAT"))

        let yMarksPeriod=25
        let yMarksCount = Int(height/CGFloat(yMarksPeriod))
        let yMarksStartValue:CGFloat=0
        var yMarksEndValue:CGFloat=1
        if(frequency != 0){
        yMarksEndValue=CGFloat(Double(dataMax)/frequency)
        }
        let yMarksFormat=NSString(string: Localization.getString("IDS_CHART_SCATEROGRAM_Y_MARKS_FORMAT"))

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
            let step = height/CGFloat(count-1)
            for i in 0..<count{
                var fontSizeOffset:CGFloat=0
                if(i==0){
                    fontSizeOffset = -self.axisFontSize
                }
                else{
                    if(i != count-1){
                        fontSizeOffset = -0.5*self.axisFontSize
                    }
                }
                let textLayer=CATextLayer()
                textLayer.frame=CGRect(x: 0, y: CGFloat(count-i-1)*step+fontSizeOffset, width: axisWidth-10, height: self.axisFontSize)
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


