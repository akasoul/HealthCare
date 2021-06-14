//
//  ChartHistogramModel.swift
//  HealthCare
//
//  Created by Anton Voloshuk on 04.05.2021.
//

import Foundation
import UIKit
import SwiftUI

class ChartHistogramModel: ObservableObject{
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
    let axisFontSize:CGFloat=11
    var height: CGFloat?
    var width: CGFloat?
    var topColor: UIColor?
    var bottomColor: UIColor?
    var data: [Double]?
    var frequency: Double?
    let divider: Double = 10
    init() {
        
    }
    
    func setSize(height: CGFloat,width:CGFloat){
        self.height=height - self.axisHeight
        self.width=width-self.axisWidth
        self.update()
    }
    
    func setColors(topColor: UIColor,bottomColor: UIColor,axisColor: UIColor){
        self.topColor=topColor
        self.bottomColor=bottomColor
        self.axisColor=axisColor
    }
    
    func setData(data: [Double],frequency: Double){
        self.data=data
        self.frequency=frequency
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
        
        var dict: [Int:Int] = [:]
        
        for i in 0..<data.count{
            let key = Int( Double(Int(data[i]/self.divider)) * self.divider)
            if let _ = dict[key] {
                dict[key]! += 1
            }
            else{
                dict[key]=1
            }
            
        }
        
        
        guard var max = dict.map({ $1 }).max()
        else{ return }
        
        let min = 0
        max += 1
        
        let sorted = dict.sorted(by: { $0.0 < $1.0})
        let arrSorted = Array(sorted)
        
        
        let step = width / CGFloat(arrSorted.count == 0 ? 1 : arrSorted.count+2)
        let stepAxisX=CGFloat(arrSorted[arrSorted.count-1].key-arrSorted[0].key)/CGFloat(arrSorted.count == 0 ? 1 : arrSorted.count)
        
        let dataHeight=CGFloat(max-min)
        
        let mainLayer = CALayer()
        mainLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
        mainLayer.backgroundColor = UIColor.clear.cgColor
        
        for i in 0..<arrSorted.count{
            let maskLayer = CAShapeLayer()
            maskLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
            maskLayer.backgroundColor = UIColor.clear.cgColor
            let posY = height-CGFloat(arrSorted[i].value)*height/dataHeight
            if posY == 0{
                continue
            }
            let path=UIBezierPath(rect: CGRect(x: (CGFloat(i+1))*step, y: posY, width: step, height: height-posY))
            maskLayer.path = path.cgPath
            maskLayer.fillColor = UIColor.red.cgColor
            
            let gradientLayer=CAGradientLayer()
            gradientLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
            gradientLayer.backgroundColor = UIColor.clear.cgColor
            gradientLayer.colors=[topColor.cgColor,bottomColor.cgColor]
            gradientLayer.mask=maskLayer
            
            mainLayer.addSublayer(gradientLayer)
            
            let borderLayer=CAShapeLayer()
            borderLayer.frame=CGRect(x: 0, y: 0, width: width, height: height)
            borderLayer.backgroundColor = UIColor.clear.cgColor
            borderLayer.path=path.cgPath
            borderLayer.strokeColor = UIColor.white.cgColor
            borderLayer.fillColor=UIColor.clear.cgColor
            borderLayer.lineWidth=0.5
            
            mainLayer.addSublayer(borderLayer)
        }
        
        let renderer = UIGraphicsImageRenderer(bounds: mainLayer.bounds)
        self.img = renderer.image(actions: { context in
            mainLayer.render(in: context.cgContext)
        })
        
        
        let xMarksPeriod=50
        let xMarksCount = Int(width/CGFloat(xMarksPeriod))
        let xMarksStartValue:CGFloat=(CGFloat(arrSorted[0].key)-stepAxisX)/CGFloat(frequency)
        let xMarksEndValue:CGFloat=(CGFloat(arrSorted[arrSorted.count-1].key)+stepAxisX)/CGFloat(frequency)
        let xMarksFormat=NSString(string: Localization.getString("IDS_CHART_HISTOGRAM_X_MARKS_FORMAT"))
        
        let yMarksPeriod=25
        let yMarksCount = Int(height/CGFloat(yMarksPeriod))
        let yMarksStartValue:CGFloat=0
        let yMarksEndValue:CGFloat=CGFloat(max)
        let yMarksFormat=NSString(string: Localization.getString("IDS_CHART_HISTOGRAM_Y_MARKS_FORMAT"))
        
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
